import 'package:ai_kampo_app/screens/info.center/my.points/invitation_screen.dart';
import 'package:ai_kampo_app/screens/info.center/present_screen.dart';
import 'package:ai_kampo_app/screens/info.center/my.points/record_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';

class MyPointsScreen extends StatefulWidget {
  const MyPointsScreen({super.key});

  @override
  State<MyPointsScreen> createState() => _MyPointsScreenState();
}

class _MyPointsScreenState extends State<MyPointsScreen> {
  final List dataList = [
    {
      "screen": () => RecordScreen(),
      "title": "點數記錄",
      "icon": Icons.history,
    },
    {
      "screen": null,
      "title": "點數兌換",
      "icon": Icons.currency_exchange,
    },
    {"screen": null, "title": "兌換記錄", "icon": CupertinoIcons.list_number},
    {
      "screen": () => PresentScreen(),
      "title": "點數贈送",
      "icon": CupertinoIcons.gift
    },
    {"screen": null, "title": "商城", "icon": Icons.storefront},
    {
      "screen": () => InvitationScreen(),
      "title": "邀請朋友",
      "icon": CupertinoIcons.mail
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("我的點數"),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 50),
              height: 260,
              width: 260,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.amber, width: 12)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "目前累責點數",
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "1,888",
                        style: TextStyle(fontSize: 50),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Image.asset(
                        "assets/icons/p.png",
                        width: 30,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 16,
                    width: 160,
                    child: Divider(
                      thickness: 2,
                    ),
                  ),
                  Text(
                    "Total 1,888 P",
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: GFAccordion(
              titleChild: Text("點數使用期限"),
              contentChild: Column(
                children: [
                  ListTile(
                    title: Text("2022/12/13 到期"),
                    subtitle: Text("888 P"),
                  ),
                  ListTile(
                    title: Text("2023/12/13 到期"),
                    subtitle: Text("1000 P"),
                  )
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.all(12),
            sliver: SliverList(
                delegate: SliverChildBuilderDelegate(((context, index) {
              return Card(
                child: ListTile(
                  contentPadding: EdgeInsets.all(6),
                  leading: Icon(dataList[index]['icon']),
                  title: Text("${dataList[index]['title']}"),
                  trailing: dataList[index]['screen'] == null
                      ? FittedBox(
                          fit: BoxFit.fill,
                          child: Row(
                            children: [Icon(Icons.construction), Text(" 建置中…")],
                          ),
                        )
                      : Icon(Icons.keyboard_arrow_right),
                  onTap: () {
                    Get.to(dataList[index]['screen']);
                  },
                ),
              );
            }), childCount: dataList.length)),
          )
        ],
      ),
    );
  }
}
