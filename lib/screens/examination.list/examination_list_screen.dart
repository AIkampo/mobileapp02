import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:ai_kampo_app/controller/account_controller.dart';
import 'package:ai_kampo_app/controller/examination_list_controller.dart';
import 'package:ai_kampo_app/controller/examination_report_controller.dart';
import 'package:ai_kampo_app/screens/examination.list/history_examination_list.dart';
import 'package:ai_kampo_app/screens/examination.list/the_last_examination_report_button.dart';
import 'package:ai_kampo_app/widgets/common/accounts_dropdown.dart';

class ExaminationListScreen extends StatefulWidget {
  const ExaminationListScreen({super.key});

  @override
  State<ExaminationListScreen> createState() => _ExaminationListScreenState();
}

class _ExaminationListScreenState extends State<ExaminationListScreen> {
  final _examinationListController = Get.find<ExaminationListController>();
  final _accountController = Get.find<AccountController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      handleGetData();
    });
    print("isFamilyHolder: ${_accountController.isFamilyHolder.value}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Obx(() => _accountController.isLoading.value?
              Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 27),
                  width: 26,
                  height: 26,
                  child: const CircularProgressIndicator(),
                ),
              ): AccountsDropdown()
            ),
            Obx(() {
              if (_examinationListController.isExaminationDataLoading.value) {
                return Container(
                  height: MediaQuery.of(context).size.height - 300,
                  child: const Center(child: CircularProgressIndicator()),
                );
              } else if (_examinationListController.caseIdList.isEmpty) {
                return Container(
                  height: MediaQuery.of(context).size.height - 300,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "尚無檢測資料",
                        style: TextStyle(fontSize: 22),
                      ),
                      const Divider(),
                      TextButton(
                        onPressed: handleGetData,
                        child: const Text(
                          "重新整理", style: TextStyle(fontSize: 20),
                        ),
                      )
                    ],
                  ),
                );
              } else {
                return Column(
                  children: [
                    TheLastExaminationReportButton(),
                    HistoryExaminationList(),
                  ],
                );
              }
            }),
          ],
        ),
      ),
    );
  }

  Future<void> handleGetData() async {
    String targetPhone = _accountController.selectedUser.value != null?
      _accountController.selectedUser.value!.phoneNumber:
      _accountController.userPhoneNumber.value;
    String? targetName = _accountController.selectedUser.value == null?
      null: _accountController.selectedUser.value!.noPhoneUser?
        _accountController.selectedUser.value!.username: null;
    await _examinationListController.fetchExaminationList(
      phoneNumber: targetPhone, name: targetName);
  }
}
