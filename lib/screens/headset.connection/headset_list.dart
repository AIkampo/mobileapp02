import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_blue_plus/gen/flutterblueplus.pbjson.dart';
import 'package:get/get.dart';

class HeadsetList extends StatefulWidget {
  const HeadsetList({super.key});

  @override
  State<HeadsetList> createState() => _HeadsetListState();
}

class _HeadsetListState extends State<HeadsetList> {
  List<BluetoothDevice> _oberonHeadsets = [];
  late BluetoothDevice? _selectedHeadset = null;

  @override
  Widget build(BuildContext context) {
    FlutterBluePlus.instance.startScan(timeout: Duration(seconds: 4));

    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton.icon(
                  icon: Icon(
                    Icons.refresh,
                    color: Colors.blue,
                  ),
                  onPressed: () {
                    _sacnHeadset();
                  },
                  label: Text(
                    "重新找尋耳機裝置",
                    style: TextStyle(fontSize: 26, color: Colors.blue),
                  ))
            ],
          ),
          headsetListView()
        ],
      ),
    );
  }

  Future<void> _sacnHeadset() async {
    FlutterBluePlus.instance.startScan(timeout: const Duration(seconds: 4));
  }

  Widget headsetListView() {
    return StreamBuilder<List<ScanResult>>(
        stream: FlutterBluePlus.instance.scanResults,
        initialData: const [],
        builder: (context, snapshot) {
          _oberonHeadsets = [];
          snapshot.data?.forEach((device) {
            if (device.device.name == "OBERON-Y") {
              _oberonHeadsets.add(device.device);
            }
          });
          return _oberonHeadsets.isNotEmpty
              ? Container(
                  margin: EdgeInsets.all(12),
                  child: Column(
                    children: _oberonHeadsets
                        .map(
                          (headset) => Card(
                            child: ListTile(
                              minVerticalPadding: 20,
                              title: Text(
                                  _selectedHeadset?.id == headset.id
                                      ? "已連接"
                                      : "尚未連接",
                                  style: TextStyle(
                                      fontSize: 24,
                                      color: _selectedHeadset?.id == headset.id
                                          ? Colors.blue
                                          : Colors.grey.shade300)),
                              subtitle: Text(
                                headset.id.toString(),
                                style: const TextStyle(fontSize: 20),
                              ),
                              trailing: TextButton(
                                onPressed: () {
                                  if (_selectedHeadset?.id == headset.id) {
                                    // headset.disconnect().then((value) {
                                    // setState(
                                    //   () {
                                    //     _selectedHeadset = null;
                                    //   },
                                    // );
                                    // Get.offAllNamed("/loading");

                                    // });
                                    getService();
                                  } else {
                                    headset.connect().then((value) {
                                      setState(
                                        () {
                                          _selectedHeadset = headset;
                                        },
                                      );
                                    });
                                  }
                                },
                                child: Text(
                                  _selectedHeadset?.id == headset.id
                                      ? "檢測"
                                      : "連線",
                                  style: TextStyle(
                                    fontSize: 22,
                                    color: _selectedHeadset?.id == headset.id
                                        ? Colors.red
                                        : Colors.blue,
                                  ),
                                ),
                                // icon: Icon(
                                //   _selectedHeadset?.id == headset.id
                                //       ? Icons.link_off
                                //       : Icons.link,
                                //   color: Colors.blue,
                                // ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                )
              : Container(
                  height: MediaQuery.of(context).size.height - 300,
                  child: Center(
                    child: Text(
                      "未發現智能耳機儀",
                      style:
                          TextStyle(fontSize: 30, color: Colors.grey.shade300),
                    ),
                  ),
                );
        });
  }

  Widget connectedHeadsetView() {
    return Column(
      children: [
        StreamBuilder<BluetoothDeviceState>(
            stream: _selectedHeadset!.state,
            initialData: BluetoothDeviceState.connecting,
            builder: (context, snapshot) {
              switch (snapshot.data) {
                case BluetoothDeviceState.connected:
                  return Column(
                    children: [
                      Text("已連線"),
                      CupertinoButton.filled(
                          child: Text("disconnect"),
                          onPressed: () {
                            _selectedHeadset!.disconnect().then((value) {
                              setState(() {
                                _selectedHeadset = null;
                              });
                            });
                          })
                    ],
                  );
                case BluetoothDeviceState.disconnected:
                  setState(() {
                    _selectedHeadset = null;
                  });
                  return Text("尚未連線 ");

                default:
                  return Text("尚未連線 ");
              }
            })
      ],
    );
  }

  Future<void> getService() async {
    List<BluetoothService> serviceList =
        await _selectedHeadset!.discoverServices();
    // serviceList.forEach((service) {
    //   print(service);
    // });
    print("======= serviceList =======");
    print(serviceList[1]);

    print("======= characteristicList =======");
    List<BluetoothCharacteristic> characteristicList =
        serviceList[1].characteristics;
    print(characteristicList);

    print("======= descriptorList =======");
    List<BluetoothDescriptor> descriptorList =
        characteristicList[0].descriptors;
    print(descriptorList);
    print(descriptorList[1]);

    try {
      print("***** write ******");

      await characteristicList[0].write([
        0x00,
        0x00,
        0x00,
        0x00,
        0x00,
        0x00,
        0x00,
        0x00,
        0x00,
        0x1D,
        0x00,
        0x0F,
        0x00,
        0x1D,
        0x00,
        0x0F
      ]);
      print("***** setNotify ******");

      await characteristicList[0].setNotifyValue(true);
      print("***** read ******");

      await characteristicList[0].read().then((value) {
        print(" res read:");
        print(value);
      });
    } catch (e) {
      print("error  \n");
      print(e);
    }
  }
}
