import 'package:ai_kampo_app/controller/examination_report_controller.dart';
import 'package:ai_kampo_app/controller/healthy_guidance_controller.dart';
import 'package:ai_kampo_app/screens/examination.report/healthy_guidance_view.dart';
import 'package:ai_kampo_app/screens/examination.report/report_profile.dart';
import 'package:ai_kampo_app/screens/examination.report/report_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExaminationReportScreen extends StatelessWidget {
  ExaminationReportScreen({super.key});

  final _examinationReportController = Get.find<ExaminationReportController>();
  final _healthyGuidanceController = Get.find<HealthyGuidanceController>();
  @override
  Widget build(BuildContext context) {
    print(
        "*******ExaminationReportScreen caseId:${Get.arguments['caseId']}*****");
    // if (Get.arguments['caseId'] == null) {
    //   Get.toNamed("/main");
    // }

    final String caseId = Get.arguments['caseId'];
    _examinationReportController.setCaseId(caseId);
    _examinationReportController.fetchNineSystemData(caseId);
    _examinationReportController.fetchGermsData(caseId);
    _examinationReportController.fetchAllergenData(caseId);
    _healthyGuidanceController.fetchDietData(caseId);
    _healthyGuidanceController.fetchNutrientsData(caseId);
    _healthyGuidanceController.fetchAcupunctureData(caseId);
    _healthyGuidanceController.fetchGemData(caseId);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 77,
          automaticallyImplyLeading: false,
          title: ReportProfile(),
          bottom: TabBar(tabs: [
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
            Get.offAndToNamed("/main");
          },
          child: Icon(Icons.close),
          backgroundColor: Colors.red.shade300,
        ),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniCenterFloat,
        floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
        // bottomNavigationBar: Container(
        //     padding: EdgeInsets.all(16),
        //     child: CupertinoButton.filled(
        //         child: Text("關閉"),
        //         onPressed: () {
        //           Get.offAndToNamed("/main");
        //         })),
      ),
    );
  }
}
