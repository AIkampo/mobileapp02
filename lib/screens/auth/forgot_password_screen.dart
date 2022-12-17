import 'package:ai_kampo_app/screens/auth/reset_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("forgotPassword".tr),
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
              Text("forgotPasswordTitle".tr),
              SizedBox(
                height: 20,
              ),
              FormBuilderTextField(
                name: "",
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.phone_android_sharp),
                    suffixIcon: TextButton(
                        onPressed: () {},
                        child: Text("getVerificationCode".tr)),
                    border: OutlineInputBorder(),
                    labelText: "phone".tr),
              ),
              SizedBox(
                height: 20,
              ),
              FormBuilderTextField(
                name: "",
                decoration: InputDecoration(
                    suffixIcon: TextButton(
                        onPressed: () {
                          Get.to(() => ResetPasswordScreen());
                        },
                        child: Text(
                          "verify".tr,
                          style: TextStyle(color: Colors.red),
                        )),
                    border: OutlineInputBorder(),
                    labelText: "verificationCode".tr),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
