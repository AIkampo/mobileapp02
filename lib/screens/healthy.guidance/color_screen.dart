//正能量顏色指引 頁面
import 'package:ai_kampo_app/widgets/common/KampoTitle.dart';
import 'package:flutter/material.dart';

class ColorScreen extends StatefulWidget {
  const ColorScreen({super.key});

  @override
  State<ColorScreen> createState() => _ColorScreenState();
}

class _ColorScreenState extends State<ColorScreen> {
  List dataList = [
    {"title": "碧綠", "color": const Color.fromRGBO(71, 165, 140, 1)},
    {"title": "碧綠的湖水", "color": const Color.fromRGBO(53, 154, 159, 1)},
    {"title": "淺橙色", "color": const Color.fromRGBO(247, 204, 143, 1)},
    {"title": "巧克力色", "color": const Color.fromRGBO(95, 73, 56, 1)},
    {"title": "香蕉黃色", "color": const Color.fromRGBO(221, 161, 9, 1)},
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(" 微量營養素指引"),
      ),
      body: CustomScrollView(
        slivers: [
          KampoSliverTitle(title: "建議的正能量顔色"),
          SliverPadding(
            padding: const EdgeInsets.all(12),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(((context, index) {
                return Card(
                  child: ListTile(
                    leading: Container(
                      alignment: Alignment.center,
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text("${index + 1}"),
                    ),
                    title: Text("${dataList[index]['title']}"),
                    trailing: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                          color: dataList[index]['color'],
                          borderRadius: BorderRadius.circular(15)),
                    ),
                  ),
                );
              }), childCount: dataList.length),
            ),
          ),
        ],
      ),
    );
  }
}
