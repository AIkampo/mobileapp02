import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:ai_kampo_app/common/function.dart';
import 'package:ai_kampo_app/controller/examination_list_controller.dart';
import 'package:ai_kampo_app/controller/examination_report_controller.dart';
import 'package:ai_kampo_app/screens/examination.report/system.report/TrendChart.dart';
import 'package:ai_kampo_app/screens/examination.report/system.report/analysis_report.dart';
import 'package:ai_kampo_app/screens/examination.report/system.report/system_report_appbar.dart';
import 'package:ai_kampo_app/widgets/common/KampoTitle.dart';
import 'package:ai_kampo_app/widgets/common/SliverLoading.dart';
import 'package:ai_kampo_app/models/nine_system_model.dart';


class SystemReportScreen extends StatefulWidget {
  const SystemReportScreen({super.key});

  @override
  State<SystemReportScreen> createState() => _SystemReportScreenState();
}

class _SystemReportScreenState extends State<SystemReportScreen> {
  final _examinationReportController = Get.find<ExaminationReportController>();
  late NineSystemModel organData;

  @override
  void initState() {
    super.initState();
    organData = Get.arguments['organData'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SystemReportAppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "檢測日期∶${caseIdToDatetime(_examinationReportController.reportCaseId.value)}",
                style: const TextStyle(fontSize: 20),
              ),
            )
          ),
          KampoSliverTitle(title: "健康建議"),
          Obx(
            () => _examinationReportController
              .linkListState[organData.indexName]!.loadingData.value?
                const SliverLoading(): const AnalysisReport(),
          ),
          KampoSliverTitle(title: "健康趨勢圖"),
          Obx(() => _examinationReportController.isNineSystemTrendLoading.value?
            const SliverLoading():
            SliverToBoxAdapter(
              child: SizedBox(
                height: 300,
                child: TrendChart(
                  trendData: _examinationReportController
                    .nineSystemTrendMap[organData.indexName]?? []
                ),
              ),
            )
          ),
          const SliverToBoxAdapter(
            child: Divider(height: 50, color: Colors.transparent),
          ),
        ],
      ),
    );
  }
}
