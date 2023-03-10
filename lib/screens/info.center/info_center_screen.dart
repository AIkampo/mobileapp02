//資訊中心 主頁
import 'package:ai_kampo_app/screens/healthy.guide/color_screen.dart';
import 'package:ai_kampo_app/screens/info.center/history_report_list_screen.dart';
import 'package:ai_kampo_app/screens/info.center/my.points/my_points_screen.dart';
import 'package:ai_kampo_app/screens/subscribe/subscribe_screen.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

// 健康指引
class InfoCenterScreen extends StatefulWidget {
  const InfoCenterScreen({super.key});

  @override
  State<InfoCenterScreen> createState() => _InfoCenterScreenState();
}

class _InfoCenterScreenState extends State<InfoCenterScreen> {
  final List dataList = [
    {
      "screen": () => HistoryReportListScreen(),
      "title": "歷史報告",
      "icon": "assets/icons/history.report.png"
    },
    {
      "screen": () => MyPointsScreen(),
      "title": "我的點數",
      "icon": "assets/icons/point.png"
    },
    {
      "screen": () => SubscribeScreen(),
      "title": "Premium會員",
      "icon": "assets/icons/premium.png"
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView.builder(
          padding: EdgeInsets.all(10),
          itemBuilder: ((context, index) {
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  leading: Image.asset("${dataList[index]['icon']}"),
                  title: Text("${dataList[index]['title']}"),
                  dense: true,
                  onTap: () {
                    Get.to(dataList[index]['screen']);
                  },
                  trailing: Icon(
                    Icons.keyboard_arrow_right,
                  ),
                ),
              ),
            );
          }),
          itemCount: dataList.length),
    );
  }
}
