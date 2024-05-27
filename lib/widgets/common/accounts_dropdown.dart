import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:ai_kampo_app/models/user_model.dart';
import 'package:ai_kampo_app/controller/account_controller.dart';
import 'package:ai_kampo_app/controller/examination_list_controller.dart';
import 'package:ai_kampo_app/controller/examination_report_controller.dart';

import '../../common/config.dart';
import '../../utils/utils.dart';


class AccountsDropdown extends StatelessWidget {
  AccountsDropdown({super.key});

  final _accountController = Get.find<AccountController>();
  final _reportController = Get.find<ExaminationReportController>();
  final _examinationListController = Get.find<ExaminationListController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (_accountController.userData.value == null) return Container();
      if (false == _accountController.isFamilyHolder.value) {
        return buildAccountMenuItem(_accountController.userData.value!);
      }
      return DropdownButton<UserData>(
        isExpanded: true,
        value: _accountController.selectedUser.value??
          _accountController.userData.value,
        itemHeight: 80,
        menuMaxHeight: 300,
        onChanged: handleChangeAccount,
        items: [
          buildAccountMenuItem(_accountController.userData.value!),
          ..._accountController.subAccountsData.map<DropdownMenuItem<UserData>>((account) {
            return buildAccountMenuItem(account);
          })
        ],
      );
    });
  }

  Future<void> handleChangeAccount(UserData? userData) async {
    UserData finalData = userData?? _accountController.userData.value!;
    _accountController.selectWithUid(finalData.uid);
    _reportController.fetchUserProfileUid(finalData.uid);
    _examinationListController.fetchExaminationList(finalData.phoneNumber);
  }

  DropdownMenuItem<UserData> buildAccountMenuItem(UserData account) {
    return DropdownMenuItem<UserData>(
      value: account,
      child: Row(
        children: [
          SizedBox(
            width: 10,
          ),
          account.sex == 'M'?
            const Icon(
              Icons.male_outlined,
              color: Colors.blue,
              size: 30,
            ):
            const Icon(
              Icons.female,
              color: Colors.red,
              size: 30,
            ),
          const SizedBox(width: 10),
          Text(
            account.username,
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(width: 20),
          if (false == account.noPhoneUser)
            Text(
              account.phoneNumber,
              style: const TextStyle(fontSize: 20),
            ),
          if (account.noPhoneUser)
            Text(
            "${UserProfile.bloodTypeList[int.parse(account.bloodType)]}型  "
            "${account.birthday == null? "": dateTimeToYearUntilDay(account.birthday!)}",
              style: const TextStyle(fontSize: 18, color: Colors.grey),
            ),
          if (account.noPhoneUser)
            const Expanded(child: VerticalDivider(color: Colors.transparent)),
          if (account.noPhoneUser)
            const Icon(Icons.phonelink_erase),
        ],
      ),
    );
  }
}
