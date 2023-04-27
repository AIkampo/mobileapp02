import 'package:ai_kampo_app/controller/headset_list_controller.dart';
import 'package:ai_kampo_app/screens/physical.examination/physical_examination_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget bottomView() {
  final hlController = Get.find<HeadsetListContorller>();

  return Container(
    height: 200,
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16), topRight: Radius.circular(16)),
      color: Colors.blue.shade50,
    ),
    child: Column(
      children: [
        ListTile(
          title: const Text(
            "已選擇耳機裝置",
            style: TextStyle(fontSize: 22),
          ),
          subtitle: Text(
            hlController.selectedHeadset.value!.id.toString(),
            style: const TextStyle(fontSize: 16),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          width: double.infinity,
          child: CupertinoButton.filled(
              child: const Text("檢測"),
              onPressed: () {
                // doDetection();
                Get.to(() => const PhysicalExaminationScreen(),
                    arguments: {"headset": hlController.selectedHeadset.value});
              }),
        ),
      ],
    ),
  );
}
