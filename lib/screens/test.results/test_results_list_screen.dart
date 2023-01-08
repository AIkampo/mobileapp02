import 'package:ai_kampo_app/screens/testing.report/testing_report_screen.dart';
import 'package:ai_kampo_app/widgets/common/KampoTitle.dart';
import 'package:ai_kampo_app/widgets/common/accounts_dropdown.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';

class TestResultListScreen extends StatefulWidget {
  const TestResultListScreen({super.key});

  @override
  State<TestResultListScreen> createState() => _TestResultListScreenState();
}

class _TestResultListScreenState extends State<TestResultListScreen> {
  bool _isMainAccount = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _isMainAccount ? AccountsDropdown() : SizedBox.shrink(),
            InkWell(
              onTap: () {
                Get.to(() => TestingReportScreen());
              },
              child: Container(
                margin: EdgeInsets.all(30),
                padding: EdgeInsets.all(8),
                height: 160,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF9AB8D9),
                      Color(0xFFE3D7E2),
                    ],
                  ),
                ),
                child: Card(
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          CupertinoIcons.doc_text,
                          size: 118,
                          color: Color(0xFF7890C8),
                        ),
                        Text(
                          "最新報告",
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 6,
                            color: Color(0xFF7890C8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            KampoTitle(title: "歷史報告"),
            // GFAccordion(
            //   showAccordion: true,
            //   title: "今日",
            //   contentChild: Card(
            //     child: ListTile(
            //       title: Text("2022/11/22"),
            //       trailing: Icon(Icons.arrow_forward_ios),
            //       onTap: () {
            //         Get.to(() => TestingReportScreen());
            //       },
            //     ),
            //   ),
            // ),
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
