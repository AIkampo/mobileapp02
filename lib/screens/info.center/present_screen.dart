//點數贈送 頁面
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';

class PresentScreen extends StatefulWidget {
  const PresentScreen({super.key});

  @override
  State<PresentScreen> createState() => _PresentScreenState();
}

class _PresentScreenState extends State<PresentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("點數贈送"),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              width: 330,
              child: Column(
                children: [
                  Container(
                    height: 120,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/icons/p.png",
                          width: 30,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "1,888",
                          style: TextStyle(fontSize: 28),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Image.asset(
                      "assets/images/present.points.png",
                      width: 60,
                    ),
                  ),
                  FormBuilderTextField(
                    name: "",
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), labelText: "贈送點數"),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  FormBuilderTextField(
                    name: "",
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), labelText: "贈送對象手機號碼"),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  FormBuilderTextField(
                    name: "",
                    maxLines: 3,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), labelText: "備註"),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  CupertinoButton.filled(
                      child: Text("送出"),
                      onPressed: () {
                        _showConfirmAndCloseDialog(context);
                      })
                ],
              ),
            ),
          ),
        ));
  }
}

void _showConfirmAndCloseDialog(BuildContext context) {
  showCupertinoModalPopup(
      context: context,
      builder: ((BuildContext context) => CupertinoAlertDialog(
            title: Text("送出成功"),
            actions: [
              CupertinoDialogAction(
                child: Text("OK"),
                isDefaultAction: true,
                onPressed: (() {
                  Get.back();
                  Get.back();
                }),
              )
            ],
          )));
}
