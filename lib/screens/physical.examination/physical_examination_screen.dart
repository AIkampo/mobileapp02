import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:ai_kampo_app/api/firebase_api.dart';
import 'package:ai_kampo_app/api/orberon_api.dart';
import 'package:ai_kampo_app/controller/examination_list_controller.dart';
import 'package:ai_kampo_app/models/examination_model.dart';
import 'package:ai_kampo_app/models/examination_status_model.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PhysicalExaminationScreen extends StatefulWidget {
  const PhysicalExaminationScreen({super.key});

  @override
  State<PhysicalExaminationScreen> createState() =>
      _PhysicalExaminationScreenState();
}

class _PhysicalExaminationScreenState extends State<PhysicalExaminationScreen> {
  int _current = 1;
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

  bool isAnalysing = false;
  bool _stopGetData = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _headset = Get.arguments['headset'];
    _headsetId = _headset.id.toString();
    print("========  _headsetId :$_headsetId");
  }

  @override
  Widget build(BuildContext context) {
    getService();

    // startDetection();
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
                      margin: EdgeInsets.symmetric(horizontal: 5.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(tips['img']),
                          SizedBox(
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
                  setState(() {
                    _current = index;
                  });
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
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: (Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black)
                          .withOpacity(_current == tip.key ? 0.9 : 0.4)),
                ),
              );
            }).toList(),
          ),
          Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Text(
                //       "系統正在讀取最新需端資料…",
                //       style: TextStyle(height: 3),
                //     ),
                //     Text("80%")
                //   ],
                // ),
                // GFProgressBar(
                //   percentage: 0.8,
                //   progressBarColor: Color(0xFF725F7C),
                //   lineHeight: 16,
                // ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(
                      width: 20,
                    ),
                    Text(
                      isAnalysing ? "分析中…" : "檢測中…",
                      style: TextStyle(fontSize: 26),
                    )
                  ],
                )
              ],
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
    _mainCharacteristic.write([
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

    _mainCharacteristic.setNotifyValue(true);
    _mainCharacteristic.value.listen((value) {
      if (_oberonData.length >= 12800 && !_stopGetData) {
        print("===========  _stopGetData:$_stopGetData");
        setState(() {
          _stopGetData = true;
        });
        stopDetection();
        handleSendExaminationData(base64.encode(_oberonData.sublist(0, 12800)));
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

    final String caseId = DateTime.now().millisecondsSinceEpoch.toString();

    final prefs = await SharedPreferences.getInstance();
    final String userDocId = prefs.getString('userDocId')!;

    final examinationListController = Get.find<ExaminationListController>();

    await FirebaseAPI.getUserDataWithDocId(userDocId)
        .then((res) => examinationListController.setUserProfile(res));

    await OrberonAPI.sendExaminationData({
      "CaseId": caseId,
      "Name": examinationListController.userProfile['username'],
      "Birthday": DateFormat("yyyyMMdd")
          .format(examinationListController.userProfile['birthday'].toDate()),
      "Phone": examinationListController.userProfile['phoneNumber'],
      "Sex": examinationListController.userProfile['sex'],
      "BloodGroup": examinationListController.userProfile['bloodType'],
      "Rhesus": examinationListController.userProfile['rh'],
      "Reseller": "tw-00026",
      "oberonSerial": _headsetId,
      "oberonData": examinationData,
      "oberMac": _headsetId
    }).then((res) {
      final ExaminationModel examinationData =
          ExaminationModel.fromJson(jsonDecode(res.toString()));

      if (examinationData.success!) {
        setState(() {
          isAnalysing = true;
        });
        Future.delayed(
            Duration(seconds: 100), () => handleCheckExamination(caseId));
      } else {
        Get.snackbar("注意！", "檢測未成功");
        throw Exception("Failed to examination!");
      }
    }).catchError((e) {
      Get.snackbar("注意！", "傳送檢測資料未成功");
    });
  }

  Future<void> handleCheckExamination(caseId) async {
    print("********* handleCheckExamination *************");
    Timer.periodic(const Duration(seconds: 10), (timer) async {
      await OrberonAPI.checkAnalysisStatus(caseId).then((res) {
        final ExaminationStatusModel resJson =
            ExaminationStatusModel.fromJson(jsonDecode(res.toString()));

        if (resJson.success!) {
          if (resJson.data == "Y") {
            timer.cancel();
            setState(() {
              isAnalysing = false;
            });
            Get.offAndToNamed("/main");
            Get.toNamed("/examination.report", arguments: {"caseId": caseId});
          }
        } else {
          throw Exception("Failed to examinate");
        }
      }).catchError((
        error,
      ) {
        Get.snackbar("檢測結果", "無法解析資料");
        timer.cancel();
        setState(() {
          isAnalysing = false;
        });
      });
    });
  }
}
