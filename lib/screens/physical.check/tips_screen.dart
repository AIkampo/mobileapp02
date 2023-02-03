import 'package:ai_kampo_app/widgets/common/KampoTitle.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class TipsScreen extends StatefulWidget {
  const TipsScreen({super.key});

  @override
  State<TipsScreen> createState() => _TipsScreenState();
}

class _TipsScreenState extends State<TipsScreen> {
  List checkList = ["連線耳罩應佩戴於左耳", "一米範圍內部沒有通話中的移動電話或磁干擾", "一些特殊狀況會影響檢測結果的準確度"];
  List exampleList = [
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
          title: Text("注意事項"),
          centerTitle: true,
        ),
        body: CustomScrollView(
          slivers: [
            KampoSliverTitle(title: "檢測前，請注意是否有以下情況"),
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                return ListTile(
                  leading: Container(
                    alignment: Alignment.center,
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text("${index + 1}"),
                  ),
                  title: Text("${checkList[index]}"),
                );
              }, childCount: checkList.length),
            ),
            SliverPadding(
              padding: EdgeInsets.all(12),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate((context, index) {
                  return Card(
                    child: Container(
                        padding: EdgeInsets.all(3),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset("${exampleList[index]['img']}"),
                            SizedBox(
                              height: 6,
                            ),
                            Text("${exampleList[index]['title']}"),
                          ],
                        )),
                  );
                }, childCount: 6),
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 150,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio: 1),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: Icon(Icons.next_plan_outlined),
                        label: Text("略過"),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Get.offAndToNamed("/loading");
                        },
                        icon: Icon(Icons.person_search_outlined),
                        label: Text("檢測"),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ));
  }
}
