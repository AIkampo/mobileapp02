// 中醫九大體質  Nine constitutions in traditional Chinese medicine
import 'package:ai_kampo_app/screens/physical.examination/examination_tips_screen.dart';
import 'package:ai_kampo_app/tcm.nine.constitutions/evaluation_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TcmNineConstitutionsScreen extends StatelessWidget {
  const TcmNineConstitutionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '九大體質檢測',
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              Get.to(() => ExaminationTipsScreen());
            },
            child: const Text(
              '略過評估',
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
      body: Column(
        children: [
         const Expanded(child: Text("")),
         const Padding(
            padding: EdgeInsets.all(22.0),
            child: Text(
              "爲了可以跟瞭解您的身體狀況，本系統每個月會跳出“體質表”供您填寫，以便提供您更正確的檢測報告。",
              style: TextStyle(color: Colors.red, fontSize: 26),
            ),
          ),
         const Expanded(child: Text("")),
          SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CupertinoButton.filled(
                child: Text("開始檢測"),
                onPressed: () {
                  Get.to(() => EvaluationScreen());
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
