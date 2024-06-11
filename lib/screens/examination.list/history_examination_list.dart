import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:ai_kampo_app/common/function.dart';
import 'package:ai_kampo_app/controller/account_controller.dart';
import 'package:ai_kampo_app/controller/examination_list_controller.dart';
import 'package:ai_kampo_app/screens/examination.report/examination_report_screen.dart';
import 'package:ai_kampo_app/widgets/common/KampoTitle.dart';
import 'package:ai_kampo_app/controller/examination_report_controller.dart';

class HistoryExaminationList extends StatelessWidget {
  HistoryExaminationList({
    Key? key,
  }) : super(key: key);

  final List<Widget> _tabs = [
    Tab(text: "全部"),
    Tab(text: "七日"),
    Tab(text: "一個月"),
    Tab(text: "三個月"),
  ];
  final _controller = Get.find<ExaminationListController>();
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => _controller.isExaminationDataLoading.value
          ? Container(
              margin: const EdgeInsets.symmetric(vertical: 20),
              child: const Center(child: CircularProgressIndicator()),
            )
          : DefaultTabController(
              length: _tabs.length,
              child: Column(
                children: [
                  KampoTitle(title: "歷史報告"),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 12),
                    child: TabBar(
                      labelColor: Colors.blue,
                      tabs: _tabs,
                      labelStyle: TextStyle(fontSize: 16),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 12),
                    height: MediaQuery.of(context).size.height -
                      (Get.find<AccountController>().isFamilyHolder.value ? 490 : 410),
                    child: TabBarView(children: [
                      BuildHistoryListView(dataList: _controller.caseIdList),
                      BuildHistoryListView(dataList: _controller.weeklyCaseIdList),
                      BuildHistoryListView(dataList: _controller.monthlyCaseIdList),
                      BuildHistoryListView(dataList: _controller.threeMonthCaseIdList),
                    ])
                  ),
                ],
              ),
            ),
    );
  }
}

class BuildHistoryListView extends StatelessWidget {
  BuildHistoryListView({
    Key? key,
    required this.dataList,
  }) : super(key: key);

  final List dataList;
  final _examinationListController = Get.find<ExaminationListController>();
  final _accountController = Get.find<AccountController>();

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

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: handleGetData,
      child: ListView.builder(
          itemCount: dataList.length,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                title: Text(
                  caseIdToDatetime(dataList[index]),
                  style: TextStyle(fontSize: 20),
                ),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Get.to(() => ExaminationReportScreen(), arguments: {"caseId": dataList[index]});
                },
              ),
            );
          }),
    );
  }
}
