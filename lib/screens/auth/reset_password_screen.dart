import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
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
              Text("resetPasswordTitle".tr),
              SizedBox(
                height: 20,
              ),
              FormBuilderTextField(
                name: "",
                obscureText: true,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.password),
                  border: OutlineInputBorder(),
                  labelText: "newPassword".tr,
                  helperText: "newPasswordHelper".tr,
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
                    labelText: "confirmPassword".tr),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 20),
                width: double.infinity,
                child: CupertinoButton.filled(
                  child: Text("confrim".tr),
                  onPressed: () {
                    Get.offAllNamed("/sign.in");
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
