//細菌與微生物評估
import 'package:ai_kampo_app/controller/examination_report_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GermsAndMicroorganism extends StatelessWidget {
  GermsAndMicroorganism({super.key});
  final _controller = Get.find<ExaminationReportController>();

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      sliver: Obx(() => SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              return Card(
                child: ListTile(
                  title: Text(
                    "${_controller.germsList[index].name}",
                    style: const TextStyle(fontSize: 22),
                  ),
                  trailing: Text(
                    "${_controller.germsList[index].d}%",
                    style: const TextStyle(fontSize: 22),
                  ),
                ),
              );
            }, childCount: _controller.germsList.length),
          )),
    );
  }
}
