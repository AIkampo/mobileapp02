import 'package:ai_kampo_app/common/config.dart';
import 'package:ai_kampo_app/controller/examination_report_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AnalysisReport extends StatefulWidget {
  const AnalysisReport({super.key});

  @override
  State<AnalysisReport> createState() => _AnalysisReportState();
}

class _AnalysisReportState extends State<AnalysisReport> {
  final _examinationReportController = Get.find<ExaminationReportController>();
  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(((context, index) {
          return Card(
            child: ListTile(
              title: Text("${_examinationReportController.organSystemList[index].name}"),
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: KampoColors.getOrganSystemScoreColor(
                      _examinationReportController.organSystemList[index].d!),
                ),
                width: 30,
                height: 30,
                child: Text(
                  Examination.getScoreText(_examinationReportController.organSystemList[index].d!),
                  style: TextStyle(
                      fontSize: 25,
                      color: Examination.getScoreTextColor(
                          _examinationReportController.organSystemList[index].d!)),
                ),
              ),
            ),
          );
        }), childCount: _examinationReportController.organSystemList.length),
      ),
    );
  }
}
