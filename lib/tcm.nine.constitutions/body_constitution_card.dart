import 'package:ai_kampo_app/common/nbc.in.tcm.dart';
import 'package:ai_kampo_app/controller/tcm_nine_constitutions_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:screenshot/screenshot.dart';

class BodyConstitutionCard extends StatelessWidget {
  BodyConstitutionCard({super.key, this.userConsitutionType = 0});

  final ScreenshotController _screenshotController = ScreenshotController();
  final int userConsitutionType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CupertinoButton.filled(
            child: Text("開啟檢測"),
            onPressed: () {
              Get.offAllNamed('/examination.tips');
            }),
      ),
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              downloadConstitutionCard(context);
            },
            icon: Icon(Icons.file_download_outlined)),
        actions: [
          TextButton(
              onPressed: (() {
                Get.offAllNamed("/main");
              }),
              child: Text(
                "取消",
                style: TextStyle(color: Colors.white),
              ))
        ],
      ),
      body: Screenshot(
        controller: _screenshotController,
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Column(
              children: [
                Image.asset("assets/images/header.bg.png"),
                Container(
                  height: 10,
                  color: Color(0xffD9D9D9),
                ),
                SizedBox(
                  height: 30,
                ),
                Image.asset(
                  "assets/images/constitution/${Get.find<TcmNineConstitutionsController>().currentUserSex.value == 'M' ? 'man' : 'woman'}/${NBCinTCM.images[userConsitutionType]}",
                  scale: 1.8,
                ),
                SizedBox(
                  height: 20,
                ),
                Text("查詢結果顯示，您是屬於"),
                SizedBox(
                  height: 18,
                ),
                Text(
                  NBCinTCM.types[userConsitutionType],
                  style: TextStyle(fontSize: 32),
                ),
                Container(
                  padding: EdgeInsets.all(30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        textAlign: TextAlign.left,
                        "特質:",
                        style: TextStyle(color: Colors.red),
                      ),
                      Text("${NBCinTCM.featureList[userConsitutionType]}")
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  downloadConstitutionCard(context) async {
    _screenshotController.capture().then((capturedImage) async {
      final result = await ImageGallerySaver.saveImage(capturedImage!, quality: 90, name: "");
      if (result["isSuccess"]) _dialogBuilder(context);
    }).catchError((onError) {
      debugPrint(onError);
    });
  }

  Future<void> _dialogBuilder(BuildContext context) {
    return showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text("圖片已下載"),
        actions: [
          TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text("OK"))
        ],
      ),
    );
  }
}
