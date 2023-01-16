import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
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
          _selectedHeadset == null ? headsetListView() : connectedHeadsetView()
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
                  margin: EdgeInsets.all(20),
                  child: Column(
                    children: _oberonHeadsets
                        .map(
                          (headset) => Card(
                            child: ListTile(
                              minVerticalPadding: 26,
                              title: Text(
                                headset.id.toString(),
                                style: TextStyle(fontSize: 22),
                              ),
                              trailing: TextButton.icon(
                                onPressed: () {
                                  headset.connect().then((value) {
                                    setState(
                                      () {
                                        _selectedHeadset = headset;
                                      },
                                    );
                                  });

                                  // _selectedHeadset = headset;
                                  // _selectedHeadset!.connect();
                                  // setState(() {});
                                  // print(_selectedHeadset);
                                },
                                icon: Icon(
                                  Icons.headset,
                                  color: Colors.blue,
                                ),
                                label: Text(
                                  "連接",
                                  style: TextStyle(color: Colors.blue),
                                ),
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
              print("**** BluetoothDeviceState...");
              print(snapshot.data);
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
}
