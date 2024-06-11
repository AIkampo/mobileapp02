import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'package:ai_kampo_app/models/nine_system_trend_model.dart';


class TrendChart extends StatefulWidget {
  final List<SystemTrendModel> trendData;
  final double? minWidth;
  const TrendChart({
    Key? key,
    required this.trendData,
    this.minWidth,
  }) : super(key: key);

  @override
  _TrendChartState createState() => _TrendChartState();
}

class _TrendChartState extends State<TrendChart> {
  final ScrollController _chartScroll = ScrollController();
  final int maxScore = 100;
  late List<String> dateLabels;
  late List<int> score;

  @override
  void initState() {
    super.initState();
    List<SystemTrendModel> trendData = widget.trendData;
    dateLabels = [for(SystemTrendModel trend in trendData) trend.date];
    score = [for(SystemTrendModel trend in trendData) trend.score];
    assert(dateLabels.length == score.length);
  }

  List<LineChartBarData> _generateChartBarData() {
    List<FlSpot> coordinates = [];
    for (int i = 0; i < score.length; i++) {
      coordinates.add(FlSpot(i.toDouble(), score[i].toDouble()));
    }

    return <LineChartBarData> [
      LineChartBarData(
        isCurved: false,
        barWidth: 2,
        isStrokeCapRound: false,
        dotData: const FlDotData(show: true),
        belowBarData: BarAreaData(show: false),
        spots: coordinates,
      )
    ];
  }

  Widget _bottomTitleWidget(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.black,
      fontSize: 14,
    );

    if (value >= 0 && value <= dateLabels.length - 1) {
      return Transform(
        alignment: Alignment.center,
        transform: Matrix4.translationValues(25, 10, 0) * Matrix4.rotationZ(-0.4 * pi),
        child: SizedBox(
          width: 80,
          height: 100,
          child: Text(
              dateLabels[value.toInt()],
              style: style,
              textAlign: TextAlign.center
          ),
        ),
      );
    }
    else {
      return Container();
    }
  }

  String _prettyPrintNum(int number) {
    if(number >= 10e9) {
      return "${(number / 10e9).toStringAsFixed(2)}G";
    }
    else if(number >= 10e6) {
      return "${(number / 10e6).toStringAsFixed(2)}M";
    }
    else if(number >= 10e3) {
      return "${(number / 10e3).toStringAsFixed(2)}K";
    }
    else {
      return number.toString();
    }
  }

  Widget _rightTitleWidget(double value, TitleMeta meta) {
    if (value % 25 != 0) return Container();
    const style = TextStyle(
      color: Colors.black,
      fontSize: 16,
    );
    String text = _prettyPrintNum(value.toInt());
    return Text(text, style: style, textAlign: TextAlign.center);
  }

  @override
  Widget build(BuildContext context) {
    LineChartData chartData = LineChartData(
      gridData: const FlGridData(
        show: true,
        drawHorizontalLine: true,
        drawVerticalLine: false,
      ),
      titlesData: FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 100,
            interval: 1,
            getTitlesWidget: _bottomTitleWidget,
          ),
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(
            getTitlesWidget: _rightTitleWidget,
            showTitles: true,
            interval: 25,
            reservedSize: 30,
          ),
        ),
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: const Border(
          bottom: BorderSide(color: Color(0xff4e4965), width: 4),
          left: BorderSide(color: Colors.transparent),
          right: BorderSide(color: Colors.transparent),
          top: BorderSide(color: Colors.transparent),
        ),
      ),
      lineBarsData: _generateChartBarData(),
      minX: -0.05,
      maxX: score.length + 0.05,
      maxY: maxScore * 1.05,
      minY: 0,
    );

    return Scrollbar(
      controller: _chartScroll,
      child: SingleChildScrollView(
        controller: _chartScroll,
        scrollDirection: Axis.horizontal,
        child: Container(
          width: 60 * score.length.toDouble(),
          constraints: BoxConstraints(
            minWidth: widget.minWidth?? 0.9 * MediaQuery.of(context).size.width,
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(40, 40, 0, 0),
            child: LineChart(
              chartData,
              duration: Duration.zero,
            ),
          ),
        ),
      ),
    );
  }
}
