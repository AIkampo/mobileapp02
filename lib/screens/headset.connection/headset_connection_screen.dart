import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';

import 'package:ai_kampo_app/screens/headset.connection/connection_tips.dart';
import 'package:ai_kampo_app/screens/headset.connection/headset.list/headset_list.dart';


class HeadsetConnectionScreen extends StatefulWidget {
  const HeadsetConnectionScreen({super.key});

  @override
  State<HeadsetConnectionScreen> createState() => _HeadsetConnectionScreenState();
}

class _HeadsetConnectionScreenState extends State<HeadsetConnectionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("連接智能耳脈儀"),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          TextButton(
            onPressed: () {
              Get.offNamed("/main");
            },
            child: const Text(
              "取消",
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
      body: StreamBuilder<BluetoothAdapterState>(
          stream: FlutterBluePlus.adapterState,
          initialData: BluetoothAdapterState.unknown,
          builder: (context, snapshot) {
            switch (snapshot.data) {
              case BluetoothAdapterState.turningOn:
                return Container(
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                );

              case (BluetoothAdapterState.on):
                return const HeadsetList();
              default:
                return ConnectionTips();
            }
          }),
    );
  }
}
