import 'package:ai_kampo_app/common/function.dart';
import 'package:ai_kampo_app/controller/account_controller.dart';
import 'package:ai_kampo_app/controller/add_sub_account_controller.dart';
import 'package:ai_kampo_app/widgets/kampo_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Step1CheckPhoneNumber extends StatelessWidget {
  Step1CheckPhoneNumber({super.key});

  final _controllerASA = Get.find<AddSubAccountController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            keyboardType: TextInputType.phone,
            onChanged: (value) {
              _controllerASA.phoneNumber.value = value;
            },
            decoration: InputDecoration(
              filled: true,
              labelText: "phone".tr,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            width: double.infinity,
            child: CupertinoButton.filled(
              onPressed: _controllerASA.phoneNumber.value.length == 10
                  ? () => handleCheckPhoneNumber(context)
                  : null,
              child: Text("confirm".tr),
            ),
          )
        ],
      ),
    );
  }

  Future handleCheckPhoneNumber(BuildContext context) async {
    // final prefs = await SharedPreferences.getInstance();
    // final userPhoneNumber = prefs.getString('phoneNumber');
    if (Get.find<AccountController>().userPhoneNumber.value == _controllerASA.phoneNumber.value) {
      // Get.snackbar("注意", "不能將自己加入！");
      KampoDialog.confirmToPop(context, "", "不能將自己加入");

      return;
    }
    switch (await checkPhoneNumberStatus(_controllerASA.phoneNumber.value)) {
      // 0 => 尚末使用 或 已註冊 未被加入子帳號
      // 1 => 已註冊 - 主帳號 (Premium)
      // 2 => 已註冊 - 子帳號
      // 3 => 已註冊 - 未被加入子帳號

      case 1:
        // Get.snackbar("注意", "此手機號碼已註冊為主帳號");
        KampoDialog.confirmToPop(context, "", "此手機號碼已註冊為主帳號");

        break;
      case 2:
        // Get.snackbar("注意", "此手機號碼已註冊為子帳號");
        KampoDialog.confirmToPop(context, "", "此手機號碼已註冊為子帳號");

        break;
      case 3:
        // Get.snackbar("注意", "此手機號碼已註冊");
        KampoDialog.confirmToPop(context, "", "此手機號碼已註冊");

        break;
      case 0:
      default:
        _controllerASA.currentStep.value = 1;
        break;
    }
  }
}
