import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:ai_kampo_app/widgets/common/KampoTitle.dart';
import 'package:ai_kampo_app/controller/account_controller.dart';
import 'package:ai_kampo_app/models/user_model.dart';
import 'package:ai_kampo_app/common/config.dart';
import 'package:ai_kampo_app/controller/physical_examination_controller.dart';
import 'package:ai_kampo_app/widgets/kampo_dialog.dart';
import 'package:ai_kampo_app/models/quota.dart';
import 'package:ai_kampo_app/utils/utils.dart';


class ConfirmPointScreen extends StatefulWidget {
  const ConfirmPointScreen({super.key});

  @override
  State<ConfirmPointScreen> createState() => _ConfirmPointScreenState();
}

class _ConfirmPointScreenState extends State<ConfirmPointScreen> {
  final AccountController _accountController = Get.find<AccountController>();
  final _physicalExaminationController =
    Get.find<PhysicalExaminationController>();
  final checkingQuota = false.obs;
  final loadingQuota = true.obs;

  @override
  void initState() {
    super.initState();
    onRefresh();
  }

  Future<void> onRefresh() async {
    loadingQuota.value = true;
    await _physicalExaminationController.refreshQuota();
    loadingQuota.value = false;
  }

  Future<void> onNext() async {
    checkingQuota.value = true;
    await _physicalExaminationController.refreshQuota();
    UserQuota? quotaInfo = _physicalExaminationController.quotaInfo.value;
    checkingQuota.value = false;
    if (quotaInfo == null) {
      if (mounted) {
        KampoDialog.confirmToPop(context, "點數資訊有誤", "無法讀取點數資訊");
      }
    }
    else if (quotaInfo.remainingMonthlyQuota > 0 || quotaInfo.oneTimeQuota > 0) {
      Get.toNamed("/examination.tips");
    }
    else {
      if (mounted) {
        KampoDialog.confirmToPop(context, "點數不足", "請確認點數或加值後再量測");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("確認點數"),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () => Get.offAllNamed('/main'),
            child: const Text("取消", style: TextStyle(color: Colors.white)),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Obx(() {
          if (checkingQuota.value) {
            return const Center(child: CircularProgressIndicator());
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const KampoTitle(title: "點數資訊"),
              Obx(() {
                UserQuota? quotaInfo =
                  _physicalExaminationController.quotaInfo.value;
                if (loadingQuota.value) {
                  return const SizedBox(
                    height: 150,
                    child: Center(child: CircularProgressIndicator())
                  );
                }
                else if (quotaInfo == null) {
                  return SizedBox(
                    width: double.infinity,
                    height: 150,
                    child: Column(
                      children: [
                        const Text("無法讀取點數資訊！", style: TextStyle(fontSize: 20)),
                        const Divider(color: Colors.transparent),
                        TextButton(
                          onPressed: onRefresh,
                          child: const Text("刷新點數資訊")
                        ),
                      ],
                    ),
                  );
                }
                else {
                  return SizedBox(
                    width: double.infinity,
                    height: 150,
                    child: Column(
                      children: [
                        Text(
                          "扣點帳號：${_accountController.familyHolder.isEmpty?
                            _accountController.userPhoneNumber:
                            _accountController.holderAccountData.value!.phoneNumber}",
                          style: const TextStyle(fontSize: 20),
                        ),
                        Text(
                          "每月剩餘點數：${quotaInfo.remainingMonthlyQuota}",
                          style: const TextStyle(fontSize: 20),
                        ),
                        Text(
                          "加購點數：${quotaInfo.oneTimeQuota}",
                          style: const TextStyle(fontSize: 20),
                        ),
                        TextButton(
                          onPressed: () => _physicalExaminationController.refreshQuota(),
                          child: const Text("刷新點數資訊")
                        ),
                      ],
                    ),
                  );
                }
              }),
              const KampoTitle(title: "帳號資訊"),
              Obx(() {
                UserData? data = _physicalExaminationController.selectedUser.value;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "姓名：${data == null? "": data.username}",
                    style: const TextStyle(fontSize: 20),
                  ),
                );
              }),
              Obx(() {
                UserData? data = _physicalExaminationController.selectedUser.value;
                String birthStr = data == null? "": data.birthday == null? "":
                dateTimeToYearUntilDay(data.birthday!);
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "生日：$birthStr",
                    style: const TextStyle(fontSize: 20),
                  ),
                );
              }),
              Obx(() {
                UserData? data = _physicalExaminationController.selectedUser.value;
                String genderStr = data == null? "": data.gender == Gender.male? "男": "女";
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "性別：$genderStr",
                    style: const TextStyle(fontSize: 20),
                  ),
                );
              }),
              Obx(() {
                UserData? data = _physicalExaminationController.selectedUser.value;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "血型：${data == null? "": bloodTypeToText[data.bloodType]}",
                    style: const TextStyle(fontSize: 20),
                  ),
                );
              }),
              Obx(() {
                UserData? data = _physicalExaminationController.selectedUser.value;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "RH：${data == null? "": rhesusToText[data.rh]}",
                    style: const TextStyle(fontSize: 20),
                  ),
                );
              }),
            ],
          );
        }),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Obx(() {
          return CupertinoButton.filled(
            onPressed: _physicalExaminationController.quotaInfo.value == null?
              null: onNext,
            child: const Text("下一步"),
          );
        }),
      ),
    );
  }
}
