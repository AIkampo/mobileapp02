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
    print(
        '(((((((((( NineSystem   data length:${_examinationReportController.nineSystemList.length}  ))))))))))');
    return SliverPadding(
        padding: EdgeInsets.all(12),
        sliver: Obx(
              () => SliverGrid(
            delegate: SliverChildBuilderDelegate((context, index) {
              return InkWell(
                  onTap: () {
                    _examinationReportController.fetchOrganSystemData(
                        _examinationReportController.nineSystemList[index].indexName!,
                        _examinationReportController.reportCaseId.value);
                    Get.to(
                          () => SystemReportScreen(),
                      arguments: {
                        "organData": _examinationReportController.nineSystemList[index] ?? ""
                      },
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(12),
                      ),
                      color: KampoColors.getScoreColor(
                          _examinationReportController.nineSystemList[index].score!),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: AspectRatio(
                                      aspectRatio: 1,
                                      child: Container(
                                        padding: EdgeInsets.all(12),
                                        margin: EdgeInsets.only(top: 2),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Color.fromRGBO(255, 255, 255, 0.6),
                                        ),
                                        child: Image(
                                            width: 42,
                                            height: 42,
                                            image: AssetImage(
                                                _examinationReportController.nineSystemList[index].img!)),
                                      ),
                                    ),
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "${_examinationReportController.nineSystemList[index].score}",
                                      style: TextStyle(
                                        color: getFontColor(
                                            _examinationReportController.nineSystemList[index].score!),
                                        fontSize: 48,
                                      ),
                                    ),
                                    Text(
                                      "分",
                                      style: TextStyle(
                                        color: getFontColor(
                                            _examinationReportController.nineSystemList[index].score!),
                                        fontSize: 24,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Text(
                            _examinationReportController.nineSystemList[index].name!,
                            style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                                color: Colors.white),
                          )
                        ],
                      ),
                    ),
                  ));
            }, childCount: _examinationReportController.nineSystemList.length),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
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
    Color _color;
    if (score >= 70)
      _color = Color.fromRGBO(0, 0, 0, 1);
    else if (score >= 50)
      _color = Color.fromARGB(255, 183, 153, 2);
    else if (score >= 20)
      _color = Color.fromARGB(255, 226, 122, 11);
    else
      _color = Color.fromRGBO(237, 7, 7, 1);

    return _color;
  }
}
