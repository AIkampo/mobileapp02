import 'package:ai_kampo_app/controller/headset_list_controller.dart';
import 'package:ai_kampo_app/screens/headset.connection/headset.list/bottom_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';


Card headsetCard({
  required BluetoothDevice headset,
  required Future<void> Function() disconnectHeadset,
}) {
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
          headset.remoteId.toString(),
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
              await disconnectHeadset();
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

class HeadsetList extends StatefulWidget {
  const HeadsetList({Key? key}) : super(key: key);

  @override
  State<HeadsetList> createState() => _HeadsetListState();
}

class _HeadsetListState extends State<HeadsetList> {
  final _hlController = Get.find<HeadsetListContorller>();

  @override
  void initState() {
    super.initState();
    _sacnHeadset();
    print("HeadsetList initState");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Obx(
          () => Column(
            children: [
              StreamBuilder<List<ScanResult>>(
                stream: FlutterBluePlus.onScanResults,
                initialData: const [],
                builder: (context, snapshot) {
                  List<BluetoothDevice> oberonHeadsets = [];
                  snapshot.data?.forEach((device) {
                    // TODO: TO be tested
                    if (device.device.name == "OBERON-Y") {
                      oberonHeadsets.add(device.device);
                    }
                  });

                  return oberonHeadsets.isNotEmpty
                      ? Container(
                    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
                    child: Column(
                      children: oberonHeadsets.map(
                        (headset) => headsetCard(
                          headset: headset, disconnectHeadset: disconnectHeadset
                        ),
                      ).toList(),
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
              ),
              const SizedBox(
                height: 20,
              ),
              _hlController.isScanning.value || _hlController.isConnecting.value
                  ? const CircularProgressIndicator()
                  : TextButton.icon(
                      icon: Icon(
                        Icons.refresh,
                        color: _hlController.isConnecting.value ? Colors.black26 : Colors.blue,
                      ),
                      onPressed: _hlController.isConnecting.value
                          ? null
                          : () {
                              _sacnHeadset();
                            },
                      label: Text(
                        "重新找尋耳機裝置",
                        style: TextStyle(
                          fontSize: 26,
                          color: _hlController.isConnecting.value ? Colors.black26 : Colors.blue,
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Obx(
        () => _hlController.selectedHeadset.value == null || _hlController.isConnecting.value
            ? const SizedBox.shrink()
            : bottomView(),
      ),
    );
  }

  Future<void> _sacnHeadset() async {
    _hlController.isScanning.value = true;
    _hlController.selectedHeadset.value = null;

    //Disconnect all the connected headsets
    await disconnectHeadset();

    await FlutterBluePlus
    .startScan(
      timeout: const Duration(seconds: 10),
      androidUsesFineLocation: true,
    )
    .then((value) {})
    .whenComplete(() {
      _hlController.isScanning.value = false;
    });
  }

  static Future<void> disconnectHeadset() async {
    List<BluetoothDevice> connectedHeadsets = FlutterBluePlus.connectedDevices;
    if (connectedHeadsets.isNotEmpty) {
      for (BluetoothDevice headset in connectedHeadsets) {
        await headset.disconnect();
      }
    }
  }
}
