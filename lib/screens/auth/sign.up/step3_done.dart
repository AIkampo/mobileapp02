import 'package:ai_kampo_app/common/function.dart';
import 'package:ai_kampo_app/controller/auth.controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class Step3Done extends StatelessWidget {
  Step3Done({super.key});

  final _authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height - 270,
          child: Center(
            child: Text(
              "註冊成功",
              style: TextStyle(fontSize: 36, letterSpacing: 3),
            ),
          ),
        ),
        SizedBox(
          width: double.infinity,
          child: CupertinoButton.filled(
            child: Text("confirm".tr),
            onPressed: () {
              doSignIn(false, _authController.signUpPhoneNumber.value, _authController.docId.value,
                  true, _authController.sex.value);
              Get.find<AuthController>().initData();
            },
          ),
        ),
      ],
    );
  }
}
