import 'dart:io';

import 'package:ai_kampo_app/widgets/common/KampoTitle.dart';
import 'package:ai_kampo_app/widgets/common/kampo_number_sign.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';

class ExaminationTipsScreen extends StatelessWidget {
  ExaminationTipsScreen({super.key});

  final List checkList = ["連線耳罩應佩戴於左耳", "一米範圍內部沒有通話中的移動電話或磁干擾", "一些特殊狀況會影響檢測結果的準確度"];
  final List exampleList = [
    {"title": "懷有身孕", "img": "assets/images/testing/pregnant.png"},
    {"title": "吸烟或飲酒", "img": "assets/images/testing/drink.png"},
    {"title": "運動", "img": "assets/images/testing/exercise.png"},
    {"title": "24小時内\n重複檢測", "img": "assets/images/testing/retest.png"},
    {"title": "金屬或其他\n配飾干擾", "img": "assets/images/testing/accessories.png"},
    {"title": "吃東西", "img": "assets/images/testing/eat.png"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("注意事項"),
        centerTitle: true,
        actions: [
          TextButton(
              onPressed: () {
                Get.offAllNamed('/main');
              },
              child: Text(
                "取消",
                style: TextStyle(color: Colors.white),
              ))
        ],
      ),
      body: CustomScrollView(
        slivers: [
          KampoSliverTitle(title: "檢測前，請注意是否有以下情況"),
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              return ListTile(
                minVerticalPadding: 10,
                leading: KampoNumberSign(number: index + 1),
                title: Text(
                  "${checkList[index]}",
                  style: const TextStyle(fontSize: 20),
                ),
              );
            }, childCount: checkList.length),
          ),
          SliverPadding(
            padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate((context, index) {
                return Card(
                  child: Container(
                      padding: const EdgeInsets.all(3),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset("${exampleList[index]['img']}"),
                          const SizedBox(
                            height: 6,
                          ),
                          Text("${exampleList[index]['title']}"),
                        ],
                      )),
                );
              }, childCount: 6),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 150,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 1,
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CupertinoButton.filled(
          onPressed: checkLocation,
          child: const Text("檢測"),
        ),
      ),
    );
  }

  Future<void> checkLocation() async {
    Location location = Location();

    if (!await location.serviceEnabled()) {
      if (Platform.isIOS) {
        location.requestService();
      } else {
        location
            .requestService()
            .then((res) => res ? Get.toNamed("/headset.connection") : Get.offAllNamed("/main"));
      }
    } else {
      Get.toNamed("/headset.connection");
    }
  }
}
