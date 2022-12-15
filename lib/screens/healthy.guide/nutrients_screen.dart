//微量營養素指引 頁面
import 'package:ai_kampo_app/screens/healthy.guide/healthy_guide_controller.dart';
import 'package:ai_kampo_app/widgets/common/KampoTitle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NutrientsScreen extends StatefulWidget {
  const NutrientsScreen({super.key});

  @override
  State<NutrientsScreen> createState() => _NutrientsScreenState();
}

class _NutrientsScreenState extends State<NutrientsScreen> {
  @override
  Widget build(BuildContext context) {
    final _controller = Get.find<HealthyGuideController>();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(" 微量營養素指引"),
      ),
      body: CustomScrollView(
        slivers: [
          KampoSliverTitle(title: "建議的微量營養素"),
          SliverPadding(
            padding: EdgeInsets.all(12),
            sliver: Obx(() => SliverList(
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
                          title:
                              Text("${_controller.nutrientsList[index].name}")),
                    );
                  }), childCount: _controller.nutrientsList.length),
                )),
          ),
        ],
      ),
    );
  }
}
