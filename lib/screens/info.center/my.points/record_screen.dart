//點數記錄 頁面

import 'package:flutter/material.dart';

class RecordScreen extends StatefulWidget {
  const RecordScreen({super.key});

  @override
  State<RecordScreen> createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen> {
  List dataList = [
    {"title": "八段錦練習點數", "date": "2022/11/11", "point": 5},
    {"title": "點數兌換", "date": "2022/11/01", "point": -5},
    {"title": "邀請朋友", "date": "2022/10/28", "point": 10}
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("點數記錄"),
        centerTitle: true,
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              height: 150,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/icons/p.png",
                      width: 30,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "1,888",
                      style: TextStyle(fontSize: 28),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.all(12),
            sliver: SliverList(
                delegate: SliverChildBuilderDelegate(((context, index) {
              return Card(
                child: ListTile(
                  title: Text("${dataList[index]['title']}"),
                  subtitle: Text("${dataList[index]['date']}"),
                  trailing: Container(
                    child: FittedBox(
                      fit: BoxFit.fill,
                      child: Row(
                        children: [
                          Image.asset(
                            "assets/icons/p.png",
                            width: 14,
                          ),
                          SizedBox(
                            width: 3,
                          ),
                          Text("${dataList[index]['point']}"),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }), childCount: 3)),
          )
        ],
      ),
    );
  }
}
