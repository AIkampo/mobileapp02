// 您的九大組織系統檢測結果

import 'package:ai_kampo_app/common/config.dart';
import 'package:ai_kampo_app/controller/examination_report_controller.dart';
import 'package:ai_kampo_app/models/nine_system_model.dart';
import 'package:ai_kampo_app/screens/examination.report/system.report/system_report_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NineSystem extends StatelessWidget {
  NineSystem({super.key});
  final _examinationReportController = Get.find<ExaminationReportController>();

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Obx(() {
        List<NineSystemModel> nineSystemData =
          _examinationReportController.nineSystemList;
        return GridView.count(
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(10),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          crossAxisCount: 3,
          children: nineSystemData.map(
            (data) => InkWell(
              onTap: () {
                Get.to(
                  () => const SystemReportScreen(),
                  arguments: {"organData": data},
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(12),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      KampoColors.getScoreColor(data.score!),
                      KampoColors.getLightModeScoreColor(data.score!)
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade400,
                      blurRadius: 3,
                      offset: const Offset(6, 6),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: Image(
                            fit: BoxFit.fitHeight,
                            image: AssetImage(data.img?? ""),
                          ),
                        ),
                        const VerticalDivider(color: Colors.transparent),
                        Center(
                            child: Text(
                              "${data.score}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 26,
                              ),
                            )
                        ),
                        const VerticalDivider(color: Colors.transparent),
                      ],
                    ),
                    Positioned(
                      bottom: 10,
                      right: 10,
                      child: Text(
                        data.meridianName?? "",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ).toList(),
        );
      }),
    );
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
