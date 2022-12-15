import 'package:ai_kampo_app/screens/testing.report/testing_report_screen.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';

class TestResultListScreen extends StatefulWidget {
  const TestResultListScreen({super.key});

  @override
  State<TestResultListScreen> createState() => _TestResultListScreenState();
}

class _TestResultListScreenState extends State<TestResultListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    Get.to(() => TestingReportScreen());
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
