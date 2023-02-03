import 'package:ai_kampo_app/screens/healthy.guidance/acupuncture_screen.dart';
import 'package:ai_kampo_app/screens/healthy.guidance/color_screen.dart';
import 'package:ai_kampo_app/screens/healthy.guidance/diet_screen.dart';
import 'package:ai_kampo_app/screens/healthy.guidance/gem_screen.dart';
import 'package:ai_kampo_app/screens/healthy.guidance/nutrients_screen.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

// 健康指引
class HealthyGuideScreen extends StatefulWidget {
  const HealthyGuideScreen({super.key});

  @override
  State<HealthyGuideScreen> createState() => _HealthyGuideScreenState();
}

class _HealthyGuideScreenState extends State<HealthyGuideScreen> {
  final List dataList = [
    {
      "screen": () => DietScreen(),
      "title": "健康飲食指引",
      "icon": "assets/icons/diet.png"
    },
    {
      "screen": () => NutrientsScreen(),
      "title": "微量營養素指引",
      "icon": "assets/icons/nutrients.png"
    },
    {
      "screen": () => ColorScreen(),
      "title": "正能量顔色指引",
      "icon": "assets/icons/color.png"
    },
    {
      "screen": () => AcupunctureScreen(),
      "title": "能量針灸指引",
      "icon": "assets/icons/acupuncture.png"
    },
    {
      "screen": () => GemScreen(),
      "title": "能量寶石指引",
      "icon": "assets/icons/gem.png"
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListView.separated(
          padding: EdgeInsets.all(6),
          itemBuilder: ((context, index) {
            return Card(
              child: ListTile(
                contentPadding: EdgeInsets.all(6),
                leading: Image.asset(
                  "${dataList[index]['icon']}",
                  scale: 1.6,
                ),
                title: Text("${dataList[index]['title']}"),
                dense: true,
                onTap: () {
                  Get.to(dataList[index]['screen']);
                },
                trailing: Icon(
                  Icons.arrow_forward_ios,
                ),
              ),
            );
          }),
          separatorBuilder: ((context, index) {
            return Divider();
          }),
          itemCount: dataList.length),
    );
  }
}
