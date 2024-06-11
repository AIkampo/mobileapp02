import 'package:flutter/material.dart';

import 'package:ai_kampo_app/common/config.dart';


class StatusTips extends StatefulWidget {
  const StatusTips({super.key});

  @override
  State<StatusTips> createState() => _StatusTipsState();
}

class _StatusTipsState extends State<StatusTips> {
  bool isExpanded = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: ExpansionPanelList(
        expandedHeaderPadding: const EdgeInsets.all(0),
        animationDuration: const Duration(milliseconds: 100),
        children: [
          ExpansionPanel(
            headerBuilder: (BuildContext context, bool isExpanded) {
              return const ListTile(
                title: Row(
                  children: [
                    Icon(Icons.info),
                    SizedBox(width: 10),
                    Text(
                      "檢測狀態顏色說明",
                      style: TextStyle(fontSize: 20),
                    )
                  ],
                ),
              );
            },
            body: Column(children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  "本APP系統會以不同顔、圖標、數值來表示您身體的即時動態狀況及建議",
                  style: TextStyle(fontSize: 16),
                ),
              ),
              ListTile(
                leading: Container(
                  margin: const EdgeInsets.only(top: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: KampoColors.scoreGreen,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Align(
                    alignment: Alignment.center,
                    child: Text(
                      "G",
                      style: TextStyle(
                        color: Color.fromRGBO(255, 255, 255, 0.75),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                title: const Text("正常(70-100分）"),
                // subtitle: const Text("請您定期檢測與健康狀況追蹤。"),
              ),
              ListTile(
                leading: Container(
                  margin: const EdgeInsets.only(top: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 7),
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: KampoColors.scoreYellow,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Y",
                      style: TextStyle(
                        color: Color.fromRGBO(255, 255, 255, 0.75),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                title: const Text("關注(50-69分)"),
                // subtitle: const Text("建議您主動詢問醫生如何改善。"),
              ),
              ListTile(
                leading: Container(
                  margin: const EdgeInsets.only(top: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: KampoColors.scoreOrange,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Align(
                    alignment: Alignment.center,
                    child: Text(
                      "O",
                      style: TextStyle(
                        color: Color.fromRGBO(255, 255, 255, 0.75),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                title: const Text("預警(20-49分)"),
                // subtitle: const Text("建議您前往醫院做進一步的檢查。"),
              ),
              ListTile(
                leading: Container(
                  margin: const EdgeInsets.only(top: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 7),
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: KampoColors.scoreRed,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Align(
                    alignment: Alignment.center,
                    child: Text(
                      "R",
                      style: TextStyle(
                        color: Color.fromRGBO(255, 255, 255, 0.75),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                title: const Text("重視(0-19分）"),
                // subtitle: const Text("有發病跡象，請重視並前往醫院檢查。"),
              ),
            ]),
            isExpanded: isExpanded,
            canTapOnHeader: true,
          ),
        ],
        expansionCallback: (_, __) {
          isExpanded = !isExpanded;
          setState(() {});
        },
      ),
    );
  }
}