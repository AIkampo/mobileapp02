import 'package:ai_kampo_app/widgets/common/KampoTitle.dart';
import 'package:ai_kampo_app/widgets/common/kampo_number_sign.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';

class ConnectionTips extends StatelessWidget {
  ConnectionTips({super.key, required this.bleState});

  final BluetoothState bleState;
  final Location _location = Location();
  final _isLocationEnable = false.obs;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          KampoTitle(title: "請您確認一下動作"),
          Container(
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: KampoNumberSign(
                    number: 1,
                  ),
                  title: Text(
                    "智能耳脈儀電源是否已開啟",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                ListTile(
                  leading: KampoNumberSign(
                    number: 2,
                  ),
                  title: Text(
                    "藍芽是否已打開",
                    style: TextStyle(fontSize: 20),
                  ),
                  // subtitle: bleState == BluetoothState.on
                  //     ? Text("已開啟")
                  //     : Text(
                  //         "尚未開啟",
                  //         style: TextStyle(color: Colors.red),
                  //       ),
                  // trailing: Platform.isAndroid
                  //     ? CupertinoButton(
                  //         onPressed: () => FlutterBluePlus.instance.turnOn(),
                  //         child: Text("開啟藍芽"),
                  //       )
                  //     : null,
                ),
                SizedBox(
                  height: 38,
                ),
                Padding(
                  padding: EdgeInsets.all(4),
                  child: Column(
                    children: [
                      ListTile(
                        minLeadingWidth: 12,
                        leading: Icon(
                          Icons.error,
                          color: Colors.red,
                        ),
                        title: Text(
                          "若以上動作仍然未能檢測到畫面，請重新打開「智能耳脈儀」、「藍牙」及「APP」。",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Image.asset(
                          "assets/images/testing/bluetooth.connecting.png"),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
