import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';

class ModifyPasswordScreen extends StatefulWidget {
  const ModifyPasswordScreen({super.key});

  @override
  State<ModifyPasswordScreen> createState() => _ModifyPasswordScreenState();
}

class _ModifyPasswordScreenState extends State<ModifyPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("resetPassword".tr),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20),
          width: 320,
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              FormBuilderTextField(
                name: "",
                obscureText: true,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.password),
                    border: OutlineInputBorder(),
                    labelText: "舊密碼"),
              ),
              SizedBox(
                height: 20,
              ),
              FormBuilderTextField(
                name: "",
                obscureText: true,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.password),
                  border: OutlineInputBorder(),
                  labelText: "新密碼",
                  helperText: "密碼包含英文字母和數字，有分大小寫",
                  helperStyle: TextStyle(color: Colors.red),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              FormBuilderTextField(
                name: "",
                obscureText: true,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.password),
                    border: OutlineInputBorder(),
                    labelText: "確認密碼"),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 20),
                width: double.infinity,
                child: CupertinoButton.filled(
                  child: Text("確認"),
                  onPressed: () {
                    _showAlertDialog(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAlertDialog(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: ((context) => CupertinoAlertDialog(
            title: Text("修改密碼成功！"),
            actions: [
              CupertinoDialogAction(
                child: Text("OK"),
                isDefaultAction: true,
                onPressed: () {
                  Get.back();
                  Get.back();
                },
              )
            ],
          )),
    );
  }
}
