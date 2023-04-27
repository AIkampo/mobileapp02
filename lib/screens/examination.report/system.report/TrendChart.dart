import 'package:ai_kampo_app/controller/examination_report_controller.dart';
import 'package:ai_kampo_app/models/nine_system_model.dart';
import 'package:ai_kampo_app/models/nine_system_trend_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class TrendChart extends StatelessWidget {
  const TrendChart({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    NineSystemModel organData = Get.arguments['organData'];
    final examinationReportController = Get.find<ExaminationReportController>();

    print("=======================");
    print(examinationReportController.nineSystemTrendMap);

    return SliverToBoxAdapter(
      child: Center(
        child: Container(
          child: Obx(() {
            print("===========TrendChart 333============");

            return examinationReportController.isNineSystemTrendLoading.value
                ? CircularProgressIndicator()
                : SfCartesianChart(
                    // Initialize category axis
                    primaryXAxis: CategoryAxis(),
                    series: <LineSeries<SystemTrendModel, String>>[
                        LineSeries<SystemTrendModel, String>(
                            // Bind data source
                            // dataSource: <SystemTrendModel>[
                            //   SystemTrendModel('2022/03/01', 66),
                            //   SystemTrendModel('2022/04/01', 60),
                            //   SystemTrendModel('2022/05/01', 62),
                            //   SystemTrendModel('2022/06/01', 70),
                            //   SystemTrendModel('2022/07/01', 88)
                            // ],

                            dataSource: examinationReportController
                                .nineSystemTrendMap[organData.indexName],
                            xValueMapper: (SystemTrendModel trendData, _) =>
                                trendData.date,
                            yValueMapper: (SystemTrendModel trendData, _) =>
                                trendData.score)
                      ]);
          }),
        ),
      ),
    );
  }
}
