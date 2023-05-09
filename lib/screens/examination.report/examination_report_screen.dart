import 'package:ai_kampo_app/controller/examination_report_controller.dart';
import 'package:ai_kampo_app/screens/examination.report/healthy_guidance_view.dart';
import 'package:ai_kampo_app/screens/examination.report/report_profile.dart';
import 'package:ai_kampo_app/screens/examination.report/report_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExaminationReportScreen extends StatefulWidget {
  const ExaminationReportScreen({Key? key}) : super(key: key);

  @override
  State<ExaminationReportScreen> createState() => _ExaminationReportScreenState();
}

class _ExaminationReportScreenState extends State<ExaminationReportScreen> {
  final _examinationReportController = Get.find<ExaminationReportController>();

  @override
  void initState() {
    super.initState();
    print(
      "*******ExaminationReportScreen caseId:${Get.arguments['caseId']}*****");
    final String caseId = Get.arguments['caseId'];
    _examinationReportController.setCaseId(caseId);
    _examinationReportController.fetchNineSystemData(caseId);
    _examinationReportController.fetchGermsData(caseId);
    _examinationReportController.fetchAllergenData(caseId);
    handleGetPhoneNumber();
  }

  Future<void> handleGetPhoneNumber() async {
    final prefs = await SharedPreferences.getInstance();
    final phoneNumber = prefs.getString('phoneNumber');
    _examinationReportController.setPhoneNumber(phoneNumber?? "");
  }

  @override
  Widget build(BuildContext context) {
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
            Get.offNamed("/main");
          },
          child: Icon(Icons.close),
          backgroundColor: Colors.red.shade300,
        ),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniCenterFloat,
        floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      ),
    );
  }
}
