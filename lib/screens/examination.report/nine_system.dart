// 您的九大組織系統檢測結果

import 'package:ai_kampo_app/common/config.dart';
import 'package:ai_kampo_app/controller/examination_report_controller.dart';
import 'package:ai_kampo_app/screens/examination.report/system.report/system_report_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NineSystem extends StatelessWidget {
  NineSystem({super.key});
  final _examinationReportController = Get.find<ExaminationReportController>();

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
        padding: const EdgeInsets.all(12),
        sliver: Obx(
          () => SliverGrid(
            delegate: SliverChildBuilderDelegate((context, index) {
              return InkWell(
                  onTap: () {
                    _examinationReportController.fetchOrganSystemData(
                        _examinationReportController.nineSystemList[index].indexName!,
                        _examinationReportController.reportCaseId.value);
                    Get.to(
                      () => const SystemReportScreen(),
                      arguments: {
                        "organData": _examinationReportController.nineSystemList[index]
                      },
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(12),
                      ),
                      color: KampoColors.getScoreColor(
                          _examinationReportController.nineSystemList[index].score!),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              margin: const EdgeInsets.only(top: 2),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: const Color.fromRGBO(255, 255, 255, 0.6),
                              ),
                              child: Image(
                                  width: 42,
                                  height: 42,
                                  image: AssetImage(
                                      _examinationReportController.nineSystemList[index].img!)),
                            ),
                            Column(
                              children: [
                                Text(
                                  "${_examinationReportController.nineSystemList[index].score}",
                                  style: TextStyle(
                                    color: getFontColor(
                                        _examinationReportController.nineSystemList[index].score!),
                                    fontSize: 26,
                                  ),
                                ),
                                Text(
                                  "分",
                                  style: TextStyle(
                                    color: getFontColor(
                                        _examinationReportController.nineSystemList[index].score!),
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Text(
                          _examinationReportController.nineSystemList[index].name!,
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                              color: Colors.white),
                        )
                      ],
                    ),
                  ));
            }, childCount: _examinationReportController.nineSystemList.length),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 170.0,
              mainAxisSpacing: 8.0,
              crossAxisSpacing: 8.0,
              childAspectRatio: 1.0,
            ),
          ),
        ));
  }

  Color getBackgroundColor(int score) {
    Color bgColor;
    if (score >= 70) {
      bgColor = KampoColors.scoreGreen;
    } else if (score >= 50) {
      bgColor = KampoColors.scoreYellow;
    } else if (score >= 20) {
      bgColor = KampoColors.scoreOrange;
    } else {
      bgColor = KampoColors.scoreRed;
    }
    return bgColor;
  }

  Color getFontColor(int score) {
    Color color;
    if (score >= 70) {
      color = const Color.fromRGBO(0, 0, 0, 1);
    } else if (score >= 50) {
      color = const Color.fromARGB(255, 183, 153, 2);
    } else if (score >= 20) {
      color = const Color.fromARGB(255, 226, 122, 11);
    } else {
      color = const Color.fromRGBO(237, 7, 7, 1);
    }
    return color;
  }
}
