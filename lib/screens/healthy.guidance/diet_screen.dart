//健康飲食指引 頁面

import 'package:ai_kampo_app/controller/healthy_guidance_controller.dart';
import 'package:ai_kampo_app/widgets/common/KampoTitle.dart';
import 'package:ai_kampo_app/widgets/common/SliverLoading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class DietScreen extends StatelessWidget {
  DietScreen({super.key});

  final _controller = Get.find<HealthyGuidanceController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("健康飲食指引"),
        centerTitle: true,
      ),
      body: Obx(
        () => CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    const Text("以上中醫食物屬性飲食指導, 取材自高雄醫學大學附設中和紀念醫院。來源："),
                    TextButton(
                      onPressed: () async {
                        final Uri url = Uri.parse("https://www.kmuh.org.tw/www/kmcj/data/11009/20.htm");
                        if (!await launchUrl(url)) {
                          Get.snackbar("失敗", "無法開啟網址連結");
                          throw Exception(
                            "https://www.kmuh.org.tw/www/kmcj/data/11009/20.htm");
                        }
                      },
                      child: const Text(
                        "https://www.kmuh.org.tw/www/kmcj/data/11009/20.htm"
                      ),
                    )
                  ],
                ),
              )
            ),
            KampoSliverTitle(title: "建議的飲食"),
            _controller.isDietDataLoading.value
                ? const SliverLoading()
                : SliverPadding(
                    padding: const EdgeInsets.all(12),
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
                                child: Text("${index + 1}"),
                              ),
                              title: Text(
                                  "${_controller.recommendFoods[index].name}")),
                        );
                      }), childCount: _controller.recommendFoods.length),
                    )),
            KampoSliverTitle(title: "不建議的飲食"),
            _controller.isDietDataLoading.value
                ? const SliverLoading()
                : SliverPadding(
                    padding: const EdgeInsets.all(12),
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
                                child: Text("${index + 1}"),
                              ),
                              title: Text(
                                  "${_controller.disrecommendFoods[index].name}")),
                        );
                      }), childCount: _controller.disrecommendFoods.length),
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
