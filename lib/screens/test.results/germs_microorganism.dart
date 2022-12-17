//細菌與微生物評估
import 'package:ai_kampo_app/screens/test.results/test_results_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GermsAndMicroorganism extends StatefulWidget {
  const GermsAndMicroorganism({super.key});

  @override
  State<GermsAndMicroorganism> createState() => _GermsAndMicroorganismState();
}

class _GermsAndMicroorganismState extends State<GermsAndMicroorganism> {
  @override
  Widget build(BuildContext context) {
    List dataList = [
      {"title": "細菌與微生物評估", "percent": 88},
      {"title": "大腸桿菌", "percent": 85},
      {"title": "產氣乳桿菌", "percent": 83},
      {"title": "綠農桿菌", "percent": 77},
      {"title": "綠農桿菌", "percent": 66},
    ];

    final _controller = Get.find<TestResultsController>();
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 12),
      sliver: Obx(() => SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              return Card(
                child: ListTile(
                  title: Text(
                    "${_controller.germsList[index].name}",
                    style: TextStyle(fontSize: 22),
                  ),
                  trailing: Text(
                    "${_controller.germsList[index].d}%",
                    style: TextStyle(fontSize: 22),
                  ),
                ),
              );
            }, childCount: _controller.germsList.length),
          )),
    );
  }
}
