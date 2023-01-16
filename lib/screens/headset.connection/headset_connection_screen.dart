import 'package:ai_kampo_app/screens/headset.connection/connectin_tips.dart';
import 'package:ai_kampo_app/screens/headset.connection/headset_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';

class HeadsetConnectionScreen extends StatefulWidget {
  const HeadsetConnectionScreen({super.key});

  @override
  State<HeadsetConnectionScreen> createState() =>
      _HeadsetConnectionScreenState();
}

class _HeadsetConnectionScreenState extends State<HeadsetConnectionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("連接智能耳脈儀"),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              Get.offAndToNamed("/main");
            },
            child: Text(
              "取消",
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
      body: StreamBuilder<BluetoothState>(
          stream: FlutterBluePlus.instance.state,
          builder: (context, snapshot) {
            if (snapshot.data == BluetoothState.on) {
              return HeadsetList();
            } else {
              return ConnectionTips();
            }
          }),
    );
  }
}
