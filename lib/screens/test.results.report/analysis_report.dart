import 'package:ai_kampo_app/common/function.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class AnalysisReport extends StatefulWidget {
  const AnalysisReport({super.key});

  @override
  State<AnalysisReport> createState() => _AnalysisReportState();
}

class _AnalysisReportState extends State<AnalysisReport> {
  final List dataList = [
    {
      "score": 18,
      "title": "循環系統功能不良",
    },
    {
      "score": 36,
      "title": "焦慮 心肌 缺氧 受損",
    },
    {
      "score": 58,
      "title": "血管阻塞傾向",
    },
    {
      "score": 77,
      "title": "個性情緒等所產生現象居多",
    },
    {
      "score": 80,
      "title": "血管老化/長期不運動/精神壓力大",
    },
    {
      "score": 82,
      "title": "長期壓力/疲勞",
    },
    {
      "score": 85,
      "title": "類風濕-免疫系統...發炎",
    },
    {
      "score": 88,
      "title": "情緒壓力造成内臟過度反應而造成身體造成不適",
    },
    {
      "score": 92,
      "title": "精神狀態異常",
    },
    {
      "score": 92,
      "title": "精神失調",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 12),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(((context, index) {
          return Card(
            child: ListTile(
              title: Text("${dataList[index]["title"]}"),
              trailing: Container(
                width: 30,
                height: 30,
                color: getTestBgColor(dataList[index]['score']),
              ),
            ),
          );
        }), childCount: dataList.length),
      ),
    );
  }
}
