import 'package:ai_kampo_app/screens/headset.connection/connection_tips.dart';
import 'package:ai_kampo_app/screens/headset.connection/headset.list/headset_list.dart';
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
    print(" ======= HeadsetConnectionScreen");

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
            child: Text(
              "取消",
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
      body: StreamBuilder<BluetoothState>(
          stream: FlutterBluePlus.instance.state,
          initialData: BluetoothState.unknown,
          builder: (context, snapshot) {
            switch (snapshot.data) {
              case BluetoothState.turningOn:
                return Container(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );

              case (BluetoothState.on):
                return HeadsetList();
              default:
                return ConnectionTips(
                  bleState: snapshot.data!,
                );
            }
          }),
    );
  }
}
