import 'package:ai_kampo_app/controller/headset_list_controller.dart';
import 'package:ai_kampo_app/screens/headset.connection/headset.list/headset_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';

Card headsetCard(BluetoothDevice headset) {
  final hlController = Get.find<HeadsetListContorller>();
  return Card(
    child: Obx(
      () => ListTile(
        minVerticalPadding: 20,
        subtitle: Text(
            hlController.selectedHeadset.value?.id == headset.id
                ? "已連接"
                : "尚未連接",
            style: TextStyle(
                fontSize: 22,
                color: hlController.selectedHeadset.value?.id == headset.id
                    ? Colors.blue
                    : Colors.grey.shade300)),
        title: Text(
          headset.id.toString(),
          style: const TextStyle(fontSize: 20),
        ),
        trailing: TextButton(
          onPressed: hlController.isConnecting.value
              ? null
              : () async {
                  if (hlController.selectedHeadset.value?.id == headset.id) {
                    await headset.disconnect().then((value) {
                      hlController.selectedHeadset.value = null;
                    });
                  } else {
                    hlController.isConnecting.value = true;
                    //Disconnect all headset
                    await HeadsetList.disconnectHeadset();
                    //then connect selected headset
                    await headset.connect().then((value) async {
                      hlController.selectedHeadset.value = headset;
                    }).whenComplete(
                        () => hlController.isConnecting.value = false);
                  }
                },
          child: Icon(
            hlController.selectedHeadset.value?.id == headset.id
                ? Icons.link_off
                : Icons.link,
            color:
                hlController.isConnecting.value ? Colors.black26 : Colors.blue,
          ),
        ),
      ),
    ),
  );
}
