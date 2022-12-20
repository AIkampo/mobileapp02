import 'package:ai_kampo_app/common/config.dart';
import 'package:ai_kampo_app/screens/test.results/test_results_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AnalysisReport extends StatefulWidget {
  const AnalysisReport({super.key});

  @override
  State<AnalysisReport> createState() => _AnalysisReportState();
}

class _AnalysisReportState extends State<AnalysisReport> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TestResultsController>();
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 12),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          ((context, index) {
            return Card(
              child: ListTile(
                title: Text("${controller.organSystemList[index].name}"),
                trailing: Container(
                  width: 30,
                  height: 30,
                  color: KampoColors.getOrganSystemScoreColor(
                      controller.organSystemList[index].d!),
                ),
              ),
            );
          }),
          childCount: controller.organSystemList.length,
        ),
      ),
    );
  }
}
