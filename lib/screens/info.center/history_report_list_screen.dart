import 'package:ai_kampo_app/screens/examination.report/examination_report_screen.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';

class HistoryReportListScreen extends StatefulWidget {
  const HistoryReportListScreen({super.key});

  @override
  State<HistoryReportListScreen> createState() =>
      _HistoryReportListScreenState();
}

class _HistoryReportListScreenState extends State<HistoryReportListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("歷史報告"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            GFAccordion(
              showAccordion: true,
              title: "今日",
              contentChild: Card(
                child: ListTile(
                  title: Text("2022/11/22"),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Get.to(() => ExaminationReportScreen());
                  },
                ),
              ),
            ),
            GFAccordion(
              title: "過去7天",
              contentChild: Column(
                children: [
                  Card(
                    child: ListTile(
                      title: Text("2022/11/18"),
                      trailing: Icon(Icons.arrow_forward_ios),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      title: Text("2022/11/16"),
                      trailing: Icon(Icons.arrow_forward_ios),
                    ),
                  ),
                ],
              ),
            ),
            GFAccordion(
              showAccordion: true,
              title: "1個月前",
              contentChild: Column(
                children: [
                  Card(
                    child: ListTile(
                      title: Text("2022/10/18"),
                      trailing: Icon(Icons.arrow_forward_ios),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      title: Text("2022/10/16"),
                      trailing: Icon(Icons.arrow_forward_ios),
                    ),
                  ),
                ],
              ),
            ),
            GFAccordion(
              title: "3個月前",
              contentChild: Column(
                children: [
                  Card(
                    child: ListTile(
                      title: Text("2022/07/18"),
                      trailing: Icon(Icons.arrow_forward_ios),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      title: Text("2022/07/16"),
                      trailing: Icon(Icons.arrow_forward_ios),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
