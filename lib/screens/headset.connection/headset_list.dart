import 'package:ai_kampo_app/screens/physical.examination/physical_examination_screen.dart';
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
  late BluetoothDevice? _selectedHeadset = null;
  bool _isScanning = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _sacnHeadset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            headsetListView(),
            const SizedBox(
              height: 20,
            ),
            _isScanning
                ? const CircularProgressIndicator()
                : TextButton.icon(
                    icon: const Icon(
                      Icons.refresh,
                      color: Colors.blue,
                    ),
                    onPressed: () {
                      _sacnHeadset();
                    },
                    label: const Text(
                      "重新找尋耳機裝置",
                      style: TextStyle(fontSize: 26, color: Colors.blue),
                    ),
                  ),
          ],
        ),
      ),
      bottomNavigationBar: _selectedHeadset != null ? bottomButton() : null,
    );
  }

  Future<void> _sacnHeadset() async {
    setState(() {
      _isScanning = true;
      _selectedHeadset = null;
    });

    //Disconnect all the connected headsets
    List<BluetoothDevice> connectedHeadsets =
        await FlutterBluePlus.instance.connectedDevices;
    print(
        "---------------- 1 connectedHeadsets.length:${connectedHeadsets.length}");
    if (connectedHeadsets.isNotEmpty) {
      print(
          "---------------- 2 connectedHeadsets.length:${connectedHeadsets.length}");
      connectedHeadsets.forEach((BluetoothDevice headset) {
        print("---------------- 3 connectedHeadsets do disconnect()");

        headset.disconnect().catchError((e) => print(e));
      });
    }

    FlutterBluePlus.instance
        .startScan(timeout: const Duration(seconds: 4))
        .then((value) {
      setState(() {
        _isScanning = false;
      });
    });
  }

  Widget headsetListView() {
    return StreamBuilder<List<ScanResult>>(
        stream: FlutterBluePlus.instance.scanResults,
        initialData: const [],
        builder: (context, snapshot) {
          print("++++++++++  headsetListView  +++++++++++ ");
          print(snapshot.data);
          List<BluetoothDevice> oberonHeadsets = [];
          snapshot.data?.forEach((device) {
            if (device.device.name == "OBERON-Y") {
              oberonHeadsets.add(device.device);
            }
          });

          // checkConnectedHeadset();
          print("++++++++++  oberonHeadsets  +++++++++++ ");
          print(oberonHeadsets);

          return oberonHeadsets.isNotEmpty
              ? Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
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
                      style:
                          TextStyle(fontSize: 30, color: Colors.grey.shade300),
                    ),
                  ),
                );
        });
  }

  Card headsetCard(BluetoothDevice headset) {
    return Card(
      child: ListTile(
        minVerticalPadding: 20,
        subtitle: Text(_selectedHeadset?.id == headset.id ? "已連接" : "尚未連接",
            style: TextStyle(
                fontSize: 22,
                color: _selectedHeadset?.id == headset.id
                    ? Colors.blue
                    : Colors.grey.shade300)),
        title: Text(
          headset.id.toString(),
          style: const TextStyle(fontSize: 20),
        ),
        trailing: TextButton(
          onPressed: () {
            if (_selectedHeadset?.id == headset.id) {
              headset.disconnect().then((value) {
                setState(
                  () {
                    _selectedHeadset = null;
                  },
                );
              });
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
          // child: Text(
          //   _selectedHeadset?.id == headset.id
          //       ? "斷開"
          //       : "連線",
          //   style: TextStyle(
          //     fontSize: 22,
          //     color: _selectedHeadset?.id == headset.id
          //         ? Colors.red
          //         : Colors.blue,
          //   ),
          // ),
          child: Icon(
            _selectedHeadset?.id == headset.id ? Icons.link_off : Icons.link,
            color: Colors.blue,
          ),
        ),
      ),
    );
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

  Widget bottomButton() {
    return Container(
      height: 200,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16), topRight: Radius.circular(16)),
        color: Colors.blue.shade50,
      ),
      child: Column(
        children: [
          ListTile(
            title: Text(
              "已選擇耳機裝置",
              style: TextStyle(fontSize: 22),
            ),
            subtitle: Text(
              _selectedHeadset!.id.toString(),
              style: TextStyle(fontSize: 16),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          SizedBox(
            width: double.infinity,
            child: CupertinoButton.filled(
                child: Text("檢測"),
                onPressed: () {
                  // doDetection();
                  Get.to(() => PhysicalExaminationScreen(),
                      arguments: {"headset": _selectedHeadset});
                }),
          ),
        ],
      ),
    );
  }

  Future<void> checkConnectedHeadset() async {
    print("++++++++++  checkConnectedHeadset  +++++++++++ ");
    print(FlutterBluePlus.instance.connectedDevices);
    List<BluetoothDevice> connectedHeadsets =
        await FlutterBluePlus.instance.connectedDevices;
    print(connectedHeadsets.length);
    connectedHeadsets
        .forEach((BluetoothDevice headset) => headset.disconnect());
  }
}
