import 'package:ai_kampo_app/common/config.dart';
import 'package:ai_kampo_app/screens/test.results.report/analysis_report.dart';
import 'package:ai_kampo_app/screens/test.results/test_results_controller.dart';
import 'package:ai_kampo_app/widgets/common/KampoTitle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          ReportAppBar(),
          SliverToBoxAdapter(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("最新檢測日期 2022年11月11日"),
          )),
          KampoSliverTitle(title: "最新檢測結果分析報告"),
          AnalysisReport(),
          KampoSliverTitle(title: "健康趨勢圖"),
          SliverToBoxAdapter(
            child: Center(
              child: Container(
                child: SfCartesianChart(
                    // Initialize category axis
                    primaryXAxis: CategoryAxis(),
                    series: <LineSeries<AnalysisData, String>>[
                      LineSeries<AnalysisData, String>(
                          // Bind data source
                          dataSource: <AnalysisData>[
                            // AnalysisData('2022/03/01', 66),
                            // AnalysisData('2022/04/01', 60),
                            // AnalysisData('2022/05/01', 62),
                            // AnalysisData('2022/06/01', 70),
                            // AnalysisData('2022/07/01', 88)
                          ],
                          xValueMapper: (AnalysisData sales, _) => sales.date,
                          yValueMapper: (AnalysisData sales, _) => sales.score)
                    ]),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class AnalysisData {
  AnalysisData(this.date, this.score);
  final String date;
  final double score;
}

class ReportAppBar extends StatelessWidget {
  const ReportAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var reportArguments = Get.arguments;
    print("reportArguments:$reportArguments['score']");
    final controller = Get.find<TestResultsController>();

    return SliverAppBar(
      toolbarHeight: 92,
      floating: true,
      pinned: true,
      snap: true,
      expandedHeight: 200,
      backgroundColor: KampoColors.getScoreColor(reportArguments['score']),
      actions: [
        Card(
          child: Container(
            padding: EdgeInsets.all(5),
            child: Column(
              children: [
                Text(
                  "參考分數",
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
                Text(
                  "18分",
                  style: TextStyle(
                    color: Colors.red[500],
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                    alignment: Alignment.center,
                    width: 50,
                    decoration: BoxDecoration(
                        color: Colors.green[50],
                        borderRadius: BorderRadius.circular(3)),
                    child: Text("+4"))
              ],
            ),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Image.asset(controller.nineSystemList[0].img!),
        title: Text("循環系統"),
        centerTitle: true,
      ),
    );
  }
}
