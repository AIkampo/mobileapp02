// 您的九大組織系統檢測結果

import 'package:ai_kampo_app/common/config.dart';
import 'package:ai_kampo_app/screens/test.results.report/report_screen.dart';
import 'package:ai_kampo_app/screens/test.results/test_results_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NineSystemButtons extends StatefulWidget {
  const NineSystemButtons({super.key});

  @override
  State<NineSystemButtons> createState() => _NineSystemButtonsState();
}

class _NineSystemButtonsState extends State<NineSystemButtons> {
  @override
  Widget build(BuildContext context) {
    final _controller = Get.find<TestResultsController>();
    return SliverPadding(
        padding: EdgeInsets.all(12),
        sliver: Obx(
          () => SliverGrid(
            delegate: SliverChildBuilderDelegate((context, index) {
              return InkWell(
                  onTap: () {
                    Get.to(() => ReportScreen());
                  },
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(12),
                      ),
                      color: KampoColors.getScoreColor(
                          _controller.nineSystemList[index].score!),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              padding: EdgeInsets.all(12),
                              margin: EdgeInsets.only(top: 2),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Color.fromRGBO(255, 255, 255, 0.6),
                              ),
                              child: Image(
                                  width: 42,
                                  height: 42,
                                  image: AssetImage(
                                      _controller.nineSystemList[index].img!)),
                            ),
                            Column(
                              children: [
                                Text(
                                  "${_controller.nineSystemList[index].score}",
                                  style: TextStyle(
                                    color: getFontColor(_controller
                                        .nineSystemList[index].score!),
                                    fontSize: 26,
                                  ),
                                ),
                                Text(
                                  "分",
                                  style: TextStyle(
                                    color: getFontColor(_controller
                                        .nineSystemList[index].score!),
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Text(
                          _controller.nineSystemList[index].name!,
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                              color: Colors.white),
                        )
                      ],
                    ),
                  ));
            }, childCount: _controller.nineSystemList.length),
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
