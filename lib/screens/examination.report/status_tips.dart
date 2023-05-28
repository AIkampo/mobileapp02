import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

class StatusTips extends StatelessWidget {
  StatusTips({
    Key? key,
  }) : super(key: key);

  List statusList = [
    {
      "title": "正常(70-100分）",
      "subtitle": "請您定期檢測與健康狀況追蹤。",
      "color": Color.fromRGBO(192, 229, 179, 1)
    },
    {
      "title": "關注(50-69分)",
      "subtitle": "建議您主動詢問醫生如何改善。",
      "color": Color.fromRGBO(247, 231, 155, 1)
    },
    {
      "title": "預警(20-49分)",
      "subtitle": "建議您前往醫院做進一步的檢查。",
      "color": Color.fromRGBO(252, 205, 155, 1)
    },
    {
      "title": "重視(0-19分）",
      "subtitle": "有發病跡象，請重視並前往醫院檢查。",
      "color": Color.fromRGBO(245, 185, 181, 1)
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
        child: GFAccordion(
      titleChild: Row(
        children: const [
          Icon(Icons.info),
          SizedBox(
            width: 10,
          ),
          Text(
            "檢測狀態顏色說明",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          )
        ],
      ),
      contentChild: Column(children: [
        Text(
          "本APP系統會以不同顔、圖標、數值來表示您身體的即時動態狀況及建議",
          style: TextStyle(fontSize: 18),
        ),
        ListTile(
          leading: Container(
            margin: EdgeInsets.only(top: 10),
            padding: EdgeInsets.symmetric(horizontal: 6),
            width: 30,
            height: 30,
            decoration: BoxDecoration(
                color: Color.fromRGBO(192, 229, 179, 1), borderRadius: BorderRadius.circular(15)),
            child: Text(
              'G',
              style: TextStyle(color: Colors.black, fontSize: 26),
            ),
          ),
          title: Text("正常(70-100分）"),
          subtitle: Text("請您定期檢測與健康狀況追蹤。"),
        ),
        ListTile(
          leading: Container(
            margin: EdgeInsets.only(top: 10),
            padding: EdgeInsets.symmetric(horizontal: 7),
            width: 30,
            height: 30,
            decoration: BoxDecoration(
                color: Color.fromRGBO(247, 231, 155, 1), borderRadius: BorderRadius.circular(15)),
            child: Text(
              'Y',
              style: TextStyle(color: Colors.black, fontSize: 26),
            ),
          ),
          title: Text("關注(50-69分)"),
          subtitle: Text("建議您主動詢問醫生如何改善。"),
        ),
        ListTile(
          leading: Container(
            margin: EdgeInsets.only(top: 10),
            padding: EdgeInsets.symmetric(horizontal: 6),
            width: 30,
            height: 30,
            decoration: BoxDecoration(
                color: Color.fromRGBO(252, 205, 155, 1), borderRadius: BorderRadius.circular(15)),
            child: Text(
              'O',
              style: TextStyle(color: Colors.white, fontSize: 26),
            ),
          ),
          title: Text("預警(20-49分)"),
          subtitle: Text("建議您前往醫院做進一步的檢查。"),
        ),
        ListTile(
          leading: Container(
            margin: EdgeInsets.only(top: 10),
            padding: EdgeInsets.symmetric(horizontal: 7),
            width: 30,
            height: 30,
            decoration: BoxDecoration(
                color: Color.fromRGBO(245, 185, 181, 1), borderRadius: BorderRadius.circular(15)),
            child: Text(
              'R',
              style: TextStyle(color: Colors.white, fontSize: 26),
            ),
          ),
          title: Text("重視(0-19分）"),
          subtitle: Text("有發病跡象，請重視並前往醫院檢查。"),
        ),
      ]),
    ));
  }
}
