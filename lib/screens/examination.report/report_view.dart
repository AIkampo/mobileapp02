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
      () => SingleChildScrollView(
        child: Column(
          children: [
            const KampoTitle(title: "您的九大系統檢測結果"),
            const Center(
              child: Text(
                "請點選下方圖片查看深入分析",
                style: TextStyle(fontSize: 20),
              ),
            ),
            _examinationReportController.isNineSystemDataLoading.value?
              const Center(child: CircularProgressIndicator()): NineSystem(),
            const Divider(color: Colors.transparent),
            const StatusTips(),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
