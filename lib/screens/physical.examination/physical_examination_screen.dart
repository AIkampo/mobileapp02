import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:ai_kampo_app/api/firebase_api.dart';
import 'package:ai_kampo_app/api/oberon_api.dart';
import 'package:ai_kampo_app/common/config.dart';
import 'package:ai_kampo_app/controller/examination_report_controller.dart';
import 'package:ai_kampo_app/controller/physical_examination_controller.dart';
import 'package:ai_kampo_app/models/examination_model.dart';
import 'package:ai_kampo_app/models/examination_status_model.dart';
import 'package:ai_kampo_app/widgets/kampo_dialog.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:intl/intl.dart';

class PhysicalExaminationScreen extends StatefulWidget {
  const PhysicalExaminationScreen({super.key});

  @override
  State<PhysicalExaminationScreen> createState() => _PhysicalExaminationScreenState();
}

class _PhysicalExaminationScreenState extends State<PhysicalExaminationScreen> {
  final _currentCarouselIndex = 1.obs;
  final CarouselController _carouselcontroller = CarouselController();
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
  List<int> _oberonData = [];

  final _isAnalysing = false.obs;
  bool _stopGetData = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _headset = Get.arguments['headset'];
    _headsetId = _headset.id.toString();
    getService();
    handleCountdown();
  }

  late Timer _countdownTimer;
  final _countSecond = 0.obs;
  handleCountdown() async {
    print(" ====== PES - handleCountdown() ======== ");
    _countdownTimer = Timer.periodic(Duration(seconds: 2), (timer) {
      _countSecond.value = _countSecond.value + 2;
      if (_countSecond >= KampoConfig.totalExaminationTime) timer.cancel();
    });
  }

  @override
  Widget build(BuildContext context) {
    print(" ====== PES - build() ======== ");

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
                                child: Text(tips["tips"]),
                                top: 38,
                                left: 38,
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
    print("=========== PES - getService()");
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
    _mainCharacteristic.value.listen((value) {
      if (_oberonData.length >= KampoConfig.examinationDataLength && !_stopGetData) {
        setState(() {
          _stopGetData = true;
        });
        stopDetection();
        handleSendExaminationData(
          base64.encode(
            _oberonData.sublist(
              0,
              KampoConfig.examinationDataLength,
            ),
          ),
        );
      } else {
        _oberonData.addAll(value);
      }
    });
  }

  Future<void> stopDetection() async {
    print("======== stopDetection()");
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
    print("========== handleSendExaminationData");
    print(
        "  === current Phonenumber:${Get.find<PhysicalExaminationController>().phoneNumber.value}");

    await OberonAPI.getCaseId().then((res) async {
      print(" -------- getCaseId()   jsonDecode ~~");
      print(" -------- getCaseId()   res:");
      print(res);
      print(" -------- getCaseId()   res.data:");
      print(res.data);
      Map<String, dynamic> resJson = res.data;
      String caseId;
      print(" -------- getCaseId()   resJson:");
      print(resJson);
      print(" -------- getCaseId()    resJson['data']:");
      print(resJson['data']);
      if (resJson['success']) {
        caseId = resJson['data'];
      } else {
        throw Exception("Can't get caseId!");
      }

      // final examinationListController = Get.find<ExaminationListController>();

      await FirebaseAPI.getUserData(Get.find<PhysicalExaminationController>().phoneNumber.value)
          .then((userProfile) {
        print("==== getUserData()  -  userProfile======");
        print(userProfile);

        // examinationListController.setUserProfile(res);
        Get.find<ExaminationReportController>().setUserProfile(userProfile);

        // examinationListController.setUserData(res);

        doSendExaminationData(caseId, userProfile, examinationData);
      }).catchError((e) {
        KampoDialog.confirmAndOffAllNamed(context, "無法取得使用者資訊！", "", "main");
        print(e);
      });
    }).catchError((e) {
      print(e);
      KampoDialog.confirmAndOffAllNamed(context, "無法取得CaseId", "", "main");
    });
  }

  Future<void> doSendExaminationData(String caseId, userProfile, examinationData) async {
    print("======= doSendExaminationData");
    print(userProfile);

    // final String caseId = DateTime.now().millisecondsSinceEpoch.toString();

    await OberonAPI.sendExaminationData({
      "CaseId": caseId,
      "Name": userProfile['username'],
      "Birthday": DateFormat("yyyyMMdd")
          .format(DateTime.fromMillisecondsSinceEpoch(userProfile['birthday'])),
      "Phone": userProfile['phoneNumber'],
      "Sex": userProfile['sex'],
      "BloodGroup": userProfile['bloodType'],
      "Rhesus": userProfile['rh'],
      "Reseller": "tw-00026",
      "oberonSerial": _headsetId,
      "oberonData": examinationData,
      "oberMac": _headsetId
    }).then((res) {
      print("傳送檢測 then()");

      final ExaminationModel examinationData =
          ExaminationModel.fromJson(jsonDecode(res.toString()));

      if (examinationData.success!) {
        print(" =====  success to analys");
        _isAnalysing.value = true;
        Future.delayed(Duration(seconds: KampoConfig.examinationAnalysingTime),
            () => handleCheckExamination(caseId));
      } else {
        if (!_isAnalysing.value) {
          KampoDialog.confirmAndOffAllNamed(context, "檢測未成功!", "", "main");
          throw Exception("檢測未成功");
        }
      }
    }).catchError((e) {
      KampoDialog.confirmAndOffAllNamed(context, "傳送檢測資料未成功!", "", "main");
    });
  }

  Future<void> handleCheckExamination(caseId) async {
    print("********* handleCheckExamination *************");
    Timer.periodic(const Duration(seconds: 10), (timer) async {
      print("*********  Timer.periodic() *************");

      await OberonAPI.checkAnalysisStatus(caseId).then((res) {
        print(res);
        final ExaminationStatusModel resJson =
            ExaminationStatusModel.fromJson(jsonDecode(res.toString()));

        if (resJson.success!) {
          if (resJson.data == "Y") {
            timer.cancel();

            // Get.offAllNamed("/main");
            Get.toNamed("/examination.report", arguments: {"caseId": caseId});
          } else if (resJson.data == "R") {
            // _alertDialog("注意", "檢測資料未成功！");

            print("==== 檢測資料尚未成功！");
            // throw Exception("檢測資料未成功！");
          }
        } else {
          KampoDialog.confirmAndOffAllNamed(context, "分析資料未成功！", "", "main");
          timer.cancel();
        }
      }).catchError((
        error,
      ) {
        KampoDialog.confirmAndOffAllNamed(context, "分析檢測資料未成功！", "", "main");
        timer.cancel();

        print(error);
      }).whenComplete(() {
        _isAnalysing.value = false;
      });
    });
  }
}
