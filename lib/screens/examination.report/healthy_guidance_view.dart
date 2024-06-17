import 'package:ai_kampo_app/controller/healthy_guidance_controller.dart';
import 'package:ai_kampo_app/screens/healthy.guidance/acupuncture_screen.dart';
import 'package:ai_kampo_app/screens/healthy.guidance/color_screen.dart';
import 'package:ai_kampo_app/screens/healthy.guidance/diet_screen.dart';
import 'package:ai_kampo_app/screens/healthy.guidance/gem_screen.dart';
import 'package:ai_kampo_app/screens/healthy.guidance/nutrients_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class HealthyGuidanceView extends StatefulWidget {
  const HealthyGuidanceView({super.key});

  @override
  State<HealthyGuidanceView> createState() => _HealthyGuidanceViewState();
}

class _HealthyGuidanceViewState extends State<HealthyGuidanceView> {
  final List dataList = [
    {
      "screen": () => DietScreen(),
      "title": "健康飲食",
      "icon": "assets/icons/diet.png"
    },
    {
      "screen": () => NutrientsScreen(),
      "title": "微量營養素",
      "icon": "assets/icons/nutrients.png"
    },
    {
      "screen": () => ColorScreen(),
      "title": "正能量顔色",
      "icon": "assets/icons/color.png"
    },
    {
      "screen": () => AcupunctureScreen(),
      "title": "能量針灸",
      "icon": "assets/icons/acupuncture.png"
    },
    {
      "screen": () => GemScreen(),
      "title": "能量寶石",
      "icon": "assets/icons/gem.png"
    },
  ];
  final _healthyGuidanceController = Get.find<HealthyGuidanceController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _healthyGuidanceController.initHealthyGuidanceData(Get.arguments['caseId']);
    });
  }

  @override
  Widget build(BuildContext context) {

    return CustomScrollView(
      slivers: [
        SliverPadding(
            padding: const EdgeInsets.all(12),
            sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate((context, index) {
                  return InkWell(
                    onTap: () {
                      Get.to(dataList[index]['screen']);
                    },
                    child: Card(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Image.asset(dataList[index]['icon']),
                          ),
                          Text(dataList[index]['title'])
                        ],
                      ),
                    ),
                  );
                }, childCount: dataList.length),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 170,
                    mainAxisSpacing: 6,
                    crossAxisSpacing: 6,
                    childAspectRatio: 1)))
      ],
    );
  }
}
