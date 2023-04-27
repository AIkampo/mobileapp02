import 'package:ai_kampo_app/controller/auth.controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class Step3Done extends StatelessWidget {
  const Step3Done({super.key});

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
              Get.find<AuthController>().initData();
              Get.offAndToNamed('/sign.in');
            },
          ),
        ),
      ],
    );
  }
}
