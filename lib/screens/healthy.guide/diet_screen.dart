//健康飲食指引 頁面

import 'package:ai_kampo_app/screens/healthy.guide/healthy_guide_controller.dart';
import 'package:ai_kampo_app/widgets/common/KampoTitle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DietScreen extends StatefulWidget {
  const DietScreen({super.key});

  @override
  State<DietScreen> createState() => _DietScreenState();
}

class _DietScreenState extends State<DietScreen> {
  List preventList = ['鴨肉', '豬肉', '雷鳥肉', '鵝肉'];
  @override
  Widget build(BuildContext context) {
    final _controller = Get.find<HealthyGuideController>();

    return Scaffold(
      appBar: AppBar(
        title: Text("健康飲食指引"),
      ),
      body: CustomScrollView(
        slivers: [
          KampoSliverTitle(title: "建議的飲食"),
          SliverPadding(
            padding: EdgeInsets.all(12),
            sliver: Obx(() => SliverList(
                  delegate: SliverChildBuilderDelegate(((context, index) {
                    return Card(
                      child: ListTile(
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
                          title: Text("${_controller.dietList[index].name}")),
                    );
                  }),
                      childCount: _controller.dietList.length >= 20
                          ? 20
                          : _controller.dietList.length),
                )),
          ),
          KampoSliverTitle(title: "不建議的飲食"),
          SliverPadding(
            padding: EdgeInsets.all(12),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(((context, index) {
                return Card(
                  child: ListTile(
                      leading: Container(
                        alignment: Alignment.center,
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text("${index + 21}"),
                      ),
                      title: Text("${_controller.dietList[index + 21].name}")),
                );
              }), childCount: 20),
            ),
          )
        ],
      ),
    );
  }
}
