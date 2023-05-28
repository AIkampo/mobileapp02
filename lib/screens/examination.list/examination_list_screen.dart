import 'package:ai_kampo_app/controller/account_controller.dart';
import 'package:ai_kampo_app/controller/examination_list_controller.dart';
import 'package:ai_kampo_app/controller/examination_report_controller.dart';
import 'package:ai_kampo_app/screens/examination.list/history_examination_list.dart';
import 'package:ai_kampo_app/screens/examination.list/the_last_examination_report_button.dart';
import 'package:ai_kampo_app/widgets/common/accounts_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExaminationListScreen extends StatelessWidget {
  ExaminationListScreen({super.key});

  final _examinationListController = Get.find<ExaminationListController>();
  final _accountController = Get.find<AccountController>();

  @override
  Widget build(BuildContext context) {
    handleGetData();
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Obx(() => _accountController.isLoading.value
                ? Center(
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 27),
                      width: 26,
                      height: 26,
                      child: const CircularProgressIndicator(),
                    ),
                  )
                : _accountController.isMainAccount.value
                    ? AccountsDropdown()
                    : const SizedBox.shrink()),
            Obx(() {
              if (_examinationListController.isExaminationDataLoading.value) {
                return Container(
                  height: MediaQuery.of(context).size.height - 300,
                  child: const Center(child: CircularProgressIndicator()),
                );
              } else if (_examinationListController.caseIdList.isEmpty) {
                return Container(
                  height: MediaQuery.of(context).size.height - 300,
                  child: const Center(
                      child: Text(
                    "尚無檢測資料",
                    style: TextStyle(fontSize: 22),
                  )),
                );
              } else {
                return Column(
                  children: [
                    TheLastExaminationReportButton(),
                    _examinationListController.caseIdList.length > 1
                        ? HistoryExaminationList()
                        : const SizedBox.shrink(),
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
    final prefs = await SharedPreferences.getInstance();
    final phoneNumber = prefs.getString('phoneNumber')!;
    await Get.find<ExaminationReportController>().fetchUserProfile(phoneNumber);
    await _examinationListController.fetchExaminationList(phoneNumber);
  }
}
