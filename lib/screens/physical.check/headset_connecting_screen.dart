import 'dart:developer';

import 'package:ai_kampo_app/screens/physical.check/no_device_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';

class HeadsetConnectingScreen extends StatefulWidget {
  const HeadsetConnectingScreen({super.key});

  @override
  State<HeadsetConnectingScreen> createState() =>
      _HeadsetConnectingScreenState();
}

class _HeadsetConnectingScreenState extends State<HeadsetConnectingScreen> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<BluetoothState>(
      stream: FlutterBluePlus.instance.state,
      initialData: BluetoothState.unknown,
      builder: (context, snapshot) {
        if (snapshot.data == BluetoothState.on) {
          return DeviceList();
        } else {
          return NoDeviceScreen();
        }
      },
    );
  }
}

class DeviceList extends StatelessWidget {
  const DeviceList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FlutterBluePlus.instance.startScan(
      timeout: const Duration(seconds: 4),
    );
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            FlutterBluePlus.instance.startScan(
              timeout: const Duration(seconds: 4),
            );
          },
          icon: Icon(Icons.refresh),
        ),
        title: Text("耳機連接"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Get.offAndToNamed("/sign.in");
            },
            icon: Icon(Icons.close),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Card(
          child: Column(
            children: [
              StreamBuilder<List<ScanResult>>(
                  stream: FlutterBluePlus.instance.scanResults,
                  initialData: [],
                  builder: (context, snapshot) {
                    print(snapshot.data);
                    return Column(
                      children: snapshot.data!
                          .map((result) => ListTile(
                                title: Text(result.device.id.toString()),
                                subtitle: Text(result.device.name),
                                trailing: IconButton(
                                    onPressed: () {
                                      result.device.connect();
                                    },
                                    icon: Icon(Icons.bluetooth_connected)),
                              ))
                          .toList(),
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
