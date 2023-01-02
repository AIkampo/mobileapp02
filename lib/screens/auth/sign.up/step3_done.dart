import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class Step3Done extends StatelessWidget {
  const Step3Done({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "註冊成功",
          style: TextStyle(fontSize: 30),
        ),
        SizedBox(
          height: 20,
        ),
        SizedBox(
          width: double.infinity,
          child: CupertinoButton.filled(
            child: Text("confirm".tr),
            onPressed: () {
              Get.offAndToNamed('/sign.in');
            },
          ),
        ),
      ],
    );
  }
}
