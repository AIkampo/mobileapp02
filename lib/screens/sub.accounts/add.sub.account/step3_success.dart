import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class Step3Success extends StatelessWidget {
  const Step3Success({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height - 270,
          child: Center(
            child: Text(
              "已加入子帳號",
              style: TextStyle(fontSize: 36, letterSpacing: 3),
            ),
          ),
        ),
        SizedBox(
          width: double.infinity,
          child: CupertinoButton.filled(
            child: Text("confirm".tr),
            onPressed: () {
              Get.offAndToNamed('/sub.accounts');
            },
          ),
        ),
      ],
    );
  }
}
