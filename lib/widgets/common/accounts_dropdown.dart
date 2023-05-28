import 'package:ai_kampo_app/controller/account_controller.dart';
import 'package:ai_kampo_app/controller/examination_list_controller.dart';
import 'package:ai_kampo_app/controller/examination_report_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AccountsDropdown extends StatelessWidget {
  AccountsDropdown({super.key});

  final _accountController = Get.find<AccountController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => DropdownButton(
          isExpanded: true,
          value: _accountController.selectedPhoneNumber.value == ""
              ? _accountController.userPhoneNumber.value
              : _accountController.selectedPhoneNumber.value,
          itemHeight: 80,
          onChanged: handleChangeAccount,
          items: [
            buildAccountMenuItem(
                {"username": "主帳號", "phoneNumber": _accountController.userPhoneNumber.value}),
            ..._accountController.subAccounts.map<DropdownMenuItem>((account) {
              return buildAccountMenuItem(account);
            })
          ],
        ));
  }

  Future<void> handleChangeAccount(phoneNumber) async {
    final examinationListController = Get.find<ExaminationListController>();
    _accountController.selectedPhoneNumber.value = phoneNumber;

    // examinationListController.fetchUserProfile(phoneNumber);
    Get.find<ExaminationReportController>().fetchUserProfile(phoneNumber);

    examinationListController.fetchExaminationList(phoneNumber);
  }

  DropdownMenuItem<dynamic> buildAccountMenuItem(account) {
    return DropdownMenuItem(
      value: account['phoneNumber'],
      child: Row(
        children: [
          SizedBox(
            width: 10,
          ),
          account['sex'] == null
              ? SizedBox(
                  width: 30,
                )
              : account['sex'] == 'M'
                  ? Icon(
                      Icons.male_outlined,
                      color: Colors.blue,
                      size: 30,
                    )
                  : Icon(
                      Icons.female,
                      color: Colors.red,
                      size: 30,
                    ),
          SizedBox(
            width: 10,
          ),
          Text(
            account['username'],
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(
            width: 20,
          ),
          Text(
            account['phoneNumber'],
            style: TextStyle(fontSize: 20),
          )
        ],
      ),
    );
  }
}
