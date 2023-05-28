import 'package:ai_kampo_app/controller/examination_report_controller.dart';
import 'package:ai_kampo_app/screens/examination.report/healthy_guidance_view.dart';
import 'package:ai_kampo_app/screens/examination.report/report_profile.dart';
import 'package:ai_kampo_app/screens/examination.report/report_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExaminationReportScreen extends StatelessWidget {
  ExaminationReportScreen({super.key});

  final _examinationReportController = Get.find<ExaminationReportController>();
  @override
  Widget build(BuildContext context) {
    final String caseId = Get.arguments['caseId'];
    _examinationReportController.setCaseId(caseId);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 77,
          automaticallyImplyLeading: false,
          title: ReportProfile(),
          bottom: const TabBar(tabs: [
            Tab(
              child: Text(
                "檢測結果",
                style: TextStyle(fontSize: 22),
              ),
            ),
            Tab(
              child: Text(
                "健康指引",
                style: TextStyle(fontSize: 22),
              ),
            )
          ]),
        ),
        body: TabBarView(
          children: [
            ReportView(),
            HealthyGuidanceView(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Get.offNamed("/main");
          },
          backgroundColor: Colors.red.shade300,
          child: const Icon(Icons.close),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterFloat,
        floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      ),
    );
  }
}
