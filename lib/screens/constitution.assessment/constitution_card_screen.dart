import 'package:ai_kampo_app/screens/physical.check/tips_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:screenshot/screenshot.dart';

class ConstitutionCardScreen extends StatefulWidget {
  const ConstitutionCardScreen({super.key});

  @override
  State<ConstitutionCardScreen> createState() => _ConstitutionCardScreenState();
}

class _ConstitutionCardScreenState extends State<ConstitutionCardScreen> {
  ScreenshotController _screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Get.to(() => TipsScreen());
          },
          child: Image.asset(
            "assets/icons/detection.png",
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                DownloadConstitutionCard();
              },
              icon: Icon(Icons.file_download_outlined)),
        ],
      ),
      body: Screenshot(
        controller: _screenshotController,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset("assets/images/header.bg.png"),
              Container(
                height: 10,
                color: Color(0xffD9D9D9),
              ),
              SizedBox(
                height: 20,
              ),
              Image.asset(
                "assets/images/constitution/m.peaceful.png",
                scale: 1.3,
              ),
              SizedBox(
                height: 18,
              ),
              Text("查詢結果顯示，您是屬於"),
              SizedBox(
                height: 18,
              ),
              Text(
                "平和體質",
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
                    Text(
                        "體形勻稱健壯，目光有神，唇色紅潤，膚色潤澤，頭髮稠密有光澤，不易疲勞，睡眠良好，精力充沛，耐受寒熱，食欲好，大小便正常，舌色淡紅，苔薄白，脈和緩有力，性格隨和開朗。")
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  DownloadConstitutionCard() async {
    _screenshotController.capture().then((capturedImage) async {
      final result = await ImageGallerySaver.saveImage(capturedImage!,
          quality: 90, name: "");
      if (result["isSuccess"]) _dialogBuilder(context);
    }).catchError((onError) {
      print(onError);
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
