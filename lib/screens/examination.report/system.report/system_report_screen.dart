import 'package:ai_kampo_app/common/function.dart';
import 'package:ai_kampo_app/controller/examination_list_controller.dart';
import 'package:ai_kampo_app/controller/examination_report_controller.dart';
import 'package:ai_kampo_app/screens/examination.report/system.report/TrendChart.dart';
import 'package:ai_kampo_app/screens/examination.report/system.report/analysis_report.dart';
import 'package:ai_kampo_app/screens/examination.report/system.report/system_report_appbar.dart';
import 'package:ai_kampo_app/widgets/common/KampoTitle.dart';
import 'package:ai_kampo_app/widgets/common/SliverLoading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SystemReportScreen extends StatefulWidget {
  const SystemReportScreen({super.key});

  @override
  State<SystemReportScreen> createState() => _SystemReportScreenState();
}

class _SystemReportScreenState extends State<SystemReportScreen> {
  final _examinationReportController = Get.find<ExaminationReportController>();

  @override
  Widget build(BuildContext context) {
    _examinationReportController.fetchNineSystemTrendData(
        Get.find<ExaminationListController>().caseIdList);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SystemReportAppBar(),
          SliverToBoxAdapter(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "檢測日期∶${caseIdToDatetime(_examinationReportController.reportCaseId.value)}",
              style: TextStyle(fontSize: 20),
            ),
          )),
          KampoSliverTitle(title: "最新檢測結果分析報告"),
          Obx(
            () => _examinationReportController.isOrganSystemDataLoading.value
                ? SliverLoading()
                : AnalysisReport(),
          ),
          KampoSliverTitle(title: "健康趨勢圖"),
          Obx(() => _examinationReportController.isNineSystemTrendLoading.value
              ? SliverLoading()
              : TrendChart()),
        ],
      ),
    );
  }
}
