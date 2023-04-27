import 'package:ai_kampo_app/controller/account_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SubAccountsButton extends StatelessWidget {
  SubAccountsButton({
    Key? key,
  }) : super(key: key);

  final _accountController = Get.find<AccountController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => _accountController.isLoading.value
        ? Center(
            child: Container(
              margin: EdgeInsets.only(right: 16),
              width: 16,
              height: 16,
              child: const CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
          )
        : _accountController.isMainAccount.value
            ? IconButton(
                onPressed: () {
                  Get.toNamed("/sub.accounts");
                },
                icon: Icon(
                  CupertinoIcons.person_3_fill,
                  color: Colors.white,
                ),
              )
            : SizedBox.shrink());
  }
}
