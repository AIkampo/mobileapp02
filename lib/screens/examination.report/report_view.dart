import 'package:ai_kampo_app/controller/examination_report_controller.dart';
import 'package:ai_kampo_app/screens/examination.report/allergen.dart';
import 'package:ai_kampo_app/screens/examination.report/germs_microorganism.dart';
import 'package:ai_kampo_app/screens/examination.report/nine_system.dart';
import 'package:ai_kampo_app/screens/examination.report/status_tips.dart';
import 'package:ai_kampo_app/widgets/common/KampoTitle.dart';
import 'package:ai_kampo_app/widgets/common/SliverLoading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReportView extends StatelessWidget {
  ReportView({
    Key? key,
  }) : super(key: key);

  final _examinationReportController = Get.find<ExaminationReportController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => CustomScrollView(
        slivers: [
          KampoSliverTitle(title: "您的九大組織系統檢測結果"),
          SliverToBoxAdapter(
            child: Center(
              child: Text(
                "請點選下方器官圖片擦看深入分析",
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
          _examinationReportController.isNineSystemDataLoading.value
              ? const SliverLoading()
              : NineSystem(),
          StatusTips(),
          KampoSliverTitle(title: "細菌與微生物評估"),
          _examinationReportController.isGermsDataLoading.value
              ? const SliverLoading()
              : GermsAndMicroorganism(),
          KampoSliverTitle(title: "過敏原評估"),
          _examinationReportController.isAllergenDataLoading.value
              ? const SliverLoading()
              : Allergen()
        ],
      ),
    );
  }
}
