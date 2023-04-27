import 'package:ai_kampo_app/controller/headset_list_controller.dart';
import 'package:ai_kampo_app/screens/headset.connection/headset.list/bottom_view.dart';
import 'package:ai_kampo_app/screens/headset.connection/headset.list/headset_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';

class HeadsetList extends StatelessWidget {
  HeadsetList({super.key});
  final _hlController = Get.find<HeadsetListContorller>();

  @override
  Widget build(BuildContext context) {
    print(" ※ ※ ※ ※ ※ ※ ※ HeadsetList build ※ ※ ※ ※ ※ ※ ※");
    _sacnHeadset();

    return Scaffold(
      body: SingleChildScrollView(
        child: Obx(
          () => Column(
            children: [
              headsetListView(),
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

    await FlutterBluePlus.instance
        .startScan(timeout: const Duration(seconds: 10))
        .then((value) {})
        .whenComplete(() {
      _hlController.isScanning.value = false;
    });
  }

  static Future<void> disconnectHeadset() async {
    print("++++ ----- ++++++  disconnectHeadset  ++++++ ---- +++++ ");
    List<BluetoothDevice> connectedHeadsets = await FlutterBluePlus.instance.connectedDevices;
    if (connectedHeadsets.isNotEmpty) {
      for (BluetoothDevice headset in connectedHeadsets) {
        await headset.disconnect();
      }
    }
  }
}
