import 'package:ai_kampo_app/screens/headset.connection/connectin_tips.dart';
import 'package:ai_kampo_app/screens/headset.connection/headset_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';

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
                return const HeadsetList();
              default:
                return ConnectionTips(
                  bleState: snapshot.data!,
                );
            }
          }),
      // bottomNavigationBar: Padding(
      //   padding: const EdgeInsets.all(8.0),
      //   child: CupertinoButton.filled(
      //     child: Text("下一步"),
      //     onPressed: () => checkBleAndLocation(),
      //   ),
      // ),
    );
  }

  Future<void> checkBleAndLocation() async {
    Location location = Location();
    if (await location.serviceEnabled() == false) {
      Get.snackbar("注意！", "位置資訊尚未開啟");
    }
  }
}
