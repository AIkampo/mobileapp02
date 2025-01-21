import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:intl/intl.dart';

import 'package:ai_kampo_app/api/oberon_api.dart';
import 'package:ai_kampo_app/common/config.dart';
import 'package:ai_kampo_app/controller/account_controller.dart';
import 'package:ai_kampo_app/controller/physical_examination_controller.dart';
import 'package:ai_kampo_app/models/examination_model.dart';
import 'package:ai_kampo_app/models/examination_status_model.dart';
import 'package:ai_kampo_app/widgets/kampo_dialog.dart';
import 'package:ai_kampo_app/models/user_model.dart';


enum SendExaminationDataError {
  apiReturnFalse,
  timeout,
  other
}

class PhysicalExaminationScreen extends StatefulWidget {
  const PhysicalExaminationScreen({super.key});

  @override
  State<PhysicalExaminationScreen> createState() => _PhysicalExaminationScreenState();
}

class _PhysicalExaminationScreenState extends State<PhysicalExaminationScreen> {
  final _currentCarouselIndex = 1.obs;
  final CarouselController _carouselcontroller = CarouselController();
  final _physicalExaminationController =
    Get.find<PhysicalExaminationController>();
  StreamSubscription? _dataStream;
  List tipsList = [
    {
      "title": "「健康指引」提供許多適合您體質的東西。",
      "img": "assets/demo/loading/1.png",
      "tips": "你知道嗎？ \n 您可以隨時到「報告中心」練習八段錦。"
    },
    {
      "title": "「健康指引」提供許多適合您體質的東西。",
      "img": "assets/demo/loading/2.png",
      "tips": "你知道嗎？ \n 「健康指引」提供許多適合您體質的東西。"
    },
    {
      "title": "「健康指引」提供許多適合您體質的東西。",
      "img": "assets/demo/loading/3.png",
      "tips": "你知道嗎？ \n 健康檢測可以讓您暸解您的身體狀況。"
    }
  ];
  late BluetoothDevice _headset;
  String _headsetId = "";

  late BluetoothCharacteristic _mainCharacteristic;
  List<int> oberonData = [];

  final _isAnalysing = false.obs;
  bool _stopGetData = false;

  @override
  void initState() {
    super.initState();
    _headset = Get.arguments['headset'];
    _headsetId = _headset.id.toString();
    getService();
    handleCountdown();
  }

  @override
  void dispose() {
    if (_dataStream != null) {
      _dataStream!.cancel();
      _dataStream = null;
    }
    super.dispose();
  }

  late Timer countdownTimer;
  final _countSecond = 0.obs;
  handleCountdown() async {
    countdownTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      _countSecond.value = _countSecond.value + 2;
      if (_countSecond >= KampoConfig.totalExaminationTime) timer.cancel();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset("assets/images/logo.with.bg.png"),
          CarouselSlider(
            items: tipsList.map((tips) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(tips['img']),
                          const SizedBox(
                            height: 20,
                          ),
                          Stack(
                            children: [
                              Image.asset("assets/images/tips.frame.png"),
                              Positioned(
                                top: 38,
                                left: 38,
                                child: Text(tips["tips"]),
                              )
                            ],
                          )
                        ],
                      ));
                },
              );
            }).toList(),
            carouselController: _carouselcontroller,
            options: CarouselOptions(
                height: 410,
                autoPlay: false,
                enlargeCenterPage: true,
                onPageChanged: (index, reason) {
                  _currentCarouselIndex.value = index;
                }),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: tipsList.asMap().entries.map((tip) {
              return GestureDetector(
                onTap: () => _carouselcontroller.animateToPage(tip.key),
                child: Container(
                  width: 12.0,
                  height: 12.0,
                  margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: (Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black)
                          .withOpacity(_currentCarouselIndex.value == tip.key ? 0.9 : 0.4)),
                ),
              );
            }).toList(),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            child: Obx(
              () => Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _isAnalysing.value ? "系統正在讀取最新需端資料…" : "檢測中…",
                      style: const TextStyle(height: 3, fontSize: 20),
                    ),
                    Text(
                      "${_countSecond <= KampoConfig.totalExaminationTime ? (_countSecond / KampoConfig.totalExaminationTime * 100).toInt() : 100}%",
                      style: const TextStyle(height: 3, fontSize: 20),
                    )
                  ],
                ),
                _countSecond <= KampoConfig.totalExaminationTime
                    ? GFProgressBar(
                        percentage: _countSecond / KampoConfig.totalExaminationTime,
                        progressBarColor: const Color(0xFF725F7C),
                        lineHeight: 16,
                      )
                    : const SizedBox(height: 16),
                const SizedBox(
                  width: 20,
                ),
              ]),
            ),
          )
        ],
      ),
    );
  }

  Future<void> getService() async {
    List<BluetoothService> serviceList = await _headset.discoverServices();
    List<BluetoothCharacteristic> characteristicList =
        serviceList[Platform.isAndroid ? 3 : 1].characteristics;
    _mainCharacteristic = characteristicList[0];
    startDetection();
  }

  Future<void> startDetection() async {
    await _mainCharacteristic.write([
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x1D,
      0x00,
      0x0F,
      0x00,
      0x1D,
      0x00,
      0x0F
    ]);

    await _mainCharacteristic.setNotifyValue(true);
    _dataStream = _mainCharacteristic.lastValueStream.listen(
      (value) {
        if (oberonData.length >= KampoConfig.examinationDataLength && !_stopGetData) {
          setState(() {
            _stopGetData = true;
          });
          stopDetection();
          handleSendExaminationData(
            base64.encode(
              oberonData.sublist(
                0,
                KampoConfig.examinationDataLength,
              ),
            ),
          );
          if (_dataStream != null) _dataStream!.cancel();
        } else {
          oberonData.addAll(value);
        }
      },
      onError: (err) {
        print("error: $err");
        throw Exception("BT data gathering error!");
      },
    );
  }

  Future<void> stopDetection() async {
    if (_dataStream != null) {
      _dataStream!.cancel();
      _dataStream = null;
    }
    await _mainCharacteristic.setNotifyValue(false);
    await _mainCharacteristic.write([
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x01,
      0x00,
      0x02,
      0x00,
      0x01,
      0x00,
      0x02
    ]);
    await _headset.disconnect();
  }

  Future<void> handleSendExaminationData(String examinationData) async {
    for (int i = 0; i < KampoConfig.maxResendAttempts; i++) {
      print("Attempts: ${i + 1}/${KampoConfig.maxResendAttempts}");

      String? caseId;
      await OberonAPI.getCaseId().then((res) async {
        Map<String, dynamic> resJson = res.data;
        if (resJson['success']) {
          caseId = resJson['data'];
        } else {
          throw Exception("Can't get caseId!");
        }
        if (_physicalExaminationController.selectedUser.value == null) {
          KampoDialog.confirmAndOffAllNamed(context, "無法取得使用者資訊！", "", "main");
        }
      }).catchError((e) {
        KampoDialog.confirmAndOffAllNamed(context, "無法取得CaseId($i)", "", "main");
      });
      if (caseId == null) return;

      SendExaminationDataError? err = await doSendExaminationData(
        caseId!,
        _physicalExaminationController.selectedUser.value!,
        examinationData,
      );
      if (err == null) {
        // end function if success
        return;
      }
      else {
        switch (err) {
          case SendExaminationDataError.apiReturnFalse:
            KampoDialog.confirmAndOffAllNamed(context, "檢測未成功!", "", "main");
            break;
          case SendExaminationDataError.other:
            KampoDialog.confirmAndOffAllNamed(context, "傳送檢測資料未成功!", "", "main");
            break;
          case SendExaminationDataError.timeout:
            // DO NOTHING
            break;
        }
      }
    }
    // if failed after resending maxResendAttempts times
    if (mounted) {
      KampoDialog.confirmAndOffAllNamed(
        context, "分析失敗請檢查網路連線!", "", "main");
    }
  }

  Future<SendExaminationDataError?> doSendExaminationData(
    String caseId,
    UserData userProfile,
    String examinationData,
  ) async {
    SendExaminationDataError? err;
    await OberonAPI.sendExaminationData({
      "CaseId": caseId,
      "Name": userProfile.username,
      "Birthday": DateFormat("yyyyMMdd").format(userProfile.birthday!),
      "Phone": userProfile.phoneNumber,
      "Sex": genderToOberonCode[userProfile.gender]!,
      "BloodGroup": bloodTypeToOberonCode[userProfile.bloodType]!,
      "Rhesus": rhesusToOberonCode[userProfile.rh]!,
      "Reseller": "tw-00026",
      "oberonType": "BT",
      "oberonSerial": _headsetId,
      "oberonData": examinationData,
      "oberMac": _headsetId,
      "devicePlatform": "MOBILE",
    })
    .then((res) async {
      final ExaminationModel examinationData =
          ExaminationModel.fromJson(jsonDecode(res.toString()));

      if (examinationData.success!) {
        _isAnalysing.value = true;
        bool result = await Future.delayed(
          Duration(seconds: KampoConfig.examinationAnalysingTime),
          () => handleCheckExamination(caseId));
        if (result) {
          _physicalExaminationController.consumeQuota();
          Get.toNamed("/examination.report", arguments: {"caseId": caseId});
          return;
        }
        else {
          err = SendExaminationDataError.timeout;
        }
      } else {
        err = SendExaminationDataError.apiReturnFalse;
      }
    }).catchError((e) {
      err = SendExaminationDataError.other;
    });
    return err;
  }

  Future<bool> handleCheckExamination(caseId) async {
    bool success = false;
    for (
      int checkStatusAttempt = 0;
      checkStatusAttempt < KampoConfig.checkStatusMaxAttempts;
      checkStatusAttempt++
    ) {
      await OberonAPI.checkAnalysisStatus(caseId).then((res) {
        final ExaminationStatusModel resJson =
        ExaminationStatusModel.fromJson(jsonDecode(res.toString()));

        if (resJson.success!) {
          if (resJson.data == "Y") {
            success = true;
          }
        } else {
          KampoDialog.confirmAndOffAllNamed(context, "分析資料未成功！", "", "main");
        }
      })
      .catchError((error) {
        KampoDialog.confirmAndOffAllNamed(context, "分析檢測資料未成功！", "", "main");
      })
      .whenComplete(() {
        _isAnalysing.value = false;
      });
      if (success) break;
    }
    return success;
  }
}
