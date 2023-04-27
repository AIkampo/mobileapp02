import 'package:ai_kampo_app/screens/headset.connection/headset.list/headset_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

Widget headsetListView() {
  return StreamBuilder<List<ScanResult>>(
    stream: FlutterBluePlus.instance.scanResults,
    initialData: const [],
    builder: (context, snapshot) {
      print("++++++++++  headsetListView  +++++++++++ ");

      List<BluetoothDevice> oberonHeadsets = [];
      snapshot.data?.forEach((device) {
        if (device.device.name == "OBERON-Y") {
          oberonHeadsets.add(device.device);
        }
      });

      return oberonHeadsets.isNotEmpty
          ? Container(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
              child: Column(
                children: oberonHeadsets
                    .map(
                      (headset) => headsetCard(headset),
                    )
                    .toList(),
              ),
            )
          : SizedBox(
              height: MediaQuery.of(context).size.height - 200,
              child: Center(
                child: Text(
                  "未發現智能耳機儀",
                  style: TextStyle(fontSize: 30, color: Colors.grey.shade300),
                ),
              ),
            );
    },
  );
}
