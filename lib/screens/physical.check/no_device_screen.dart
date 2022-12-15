import 'package:ai_kampo_app/widgets/common/KampoTitle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';

class NoDeviceScreen extends StatefulWidget {
  const NoDeviceScreen({super.key});

  @override
  State<NoDeviceScreen> createState() => _NoDeviceScreenState();
}

class _NoDeviceScreenState extends State<NoDeviceScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("未能檢測到智能耳脈儀設備"),
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
        child: Column(
          children: [
            KampoTitle(title: "請您確認一下動作"),
            Container(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: Container(
                      alignment: Alignment.center,
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text("1"),
                    ),
                    title: Text(
                      "智能耳脈儀電源是否已開啟",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  ListTile(
                      leading: Container(
                          alignment: Alignment.center,
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text("2")),
                      title: Text(
                        "藍芽是否已打開",
                        style: TextStyle(fontSize: 18),
                      ),
                      subtitle: Text("尚未開啟"),
                      trailing: CupertinoButton(
                          onPressed: () => FlutterBluePlus.instance.turnOn(),
                          child: Text("開啟"))),
                  SizedBox(
                    height: 12,
                  ),
                  Text("※若以上動作仍然未能檢測到畫面，請重新打開「智能耳脈儀」、「藍牙」及「APP」。"),
                  SizedBox(
                    height: 20,
                  ),
                  Image.asset("assets/images/testing/bluetooth.connecting.png"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
