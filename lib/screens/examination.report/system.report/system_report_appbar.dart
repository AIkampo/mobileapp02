import 'package:ai_kampo_app/common/config.dart';
import 'package:ai_kampo_app/models/nine_system_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SystemReportAppBar extends StatelessWidget {
  const SystemReportAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    NineSystemModel organData = Get.arguments['organData'];

    return SliverAppBar(
      toolbarHeight: 82,
      floating: true,
      pinned: true,
      snap: true,
      expandedHeight: 200,
      backgroundColor: KampoColors.getScoreColor(organData.score!),
      actions: [
        Card(
          child: Container(
            padding: EdgeInsets.all(5),
            child: Column(
              children: [
                Text(
                  "參考分數",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                Text(
                  "${organData.score} 分",
                  style: TextStyle(
                    color: Colors.red[500],
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // Container(
                //     alignment: Alignment.center,
                //     width: 50,
                //     decoration: BoxDecoration(
                //         color: Colors.green[50],
                //         borderRadius: BorderRadius.circular(3)),
                //     child: Text("+4"))
              ],
            ),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Image.asset(organData.img!),
        title: Text(organData.name!),
        centerTitle: true,
      ),
    );
  }
}
