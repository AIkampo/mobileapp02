import 'package:ai_kampo_app/api/firebase_api.dart';
import 'package:ai_kampo_app/common/config.dart';
import 'package:ai_kampo_app/controller/account_controller.dart';
import 'package:ai_kampo_app/controller/physical_examination_controller.dart';
import 'package:ai_kampo_app/screens/physical.examination/examination_tips_screen.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExaminationButton extends StatelessWidget {
  ExaminationButton({super.key});

  final _accountController = Get.find<AccountController>();
  final _isChecking = false.obs;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => _accountController.isLoading.value || _isChecking.value
          ? Center(
              child: Container(
                width: 16,
                height: 16,
                child: const CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            )
          : GestureDetector(
              onTap: () async {
                if (_accountController.isMainAccount.value) {
                  _showAccountMenu(context);
                } else {
                  // Get.toNamed('/payment');

                  // ☆★
                  Get.find<PhysicalExaminationController>().phoneNumber.value =
                      _accountController.userPhoneNumber.value;

                  Get.to(() => ExaminationTipsScreen());
                }
              },
              child: Image.asset(
                "assets/icons/detection.png",
              ),
            ),
    );
  }

//判別是否已超過一個月沒有進行 體質表 評估
  Future<bool> whetherDoPhysiqueRating(String phoneNumer) async {
    return await FirebaseAPI.getUserData(phoneNumer).then((data) {
      print('  ============= ============================$phoneNumer========================');

      //尚未做過
      if (data['lastPhysiqueRatingTime'] == null) {
        return true;
      }
      Timestamp lastPhysiqueRatingTimestamp = data['lastPhysiqueRatingTime'] as Timestamp;
      DateTime lastPhysiqueRatingDateTime =
          DateTime.fromMillisecondsSinceEpoch(lastPhysiqueRatingTimestamp.millisecondsSinceEpoch);

      return DateTime.now().compareTo(lastPhysiqueRatingDateTime
              .add(Duration(days: KampoConfig.doPhysiqueRatingEveryDays))) ==
          1;
    }).catchError(() {
      return false;
    });
  }

  void _showAccountMenu(context) async {
    showCupertinoModalPopup(
      context: context,
      builder: ((BuildContext context) => CupertinoActionSheet(
            title: Text(
              "請選擇檢測帳號",
              style: TextStyle(fontSize: 20, letterSpacing: 2),
            ),
            cancelButton: CupertinoActionSheetAction(
              child: Text("取消"),
              onPressed: () {
                Get.back();
              },
              isDestructiveAction: true,
            ),
            actions: <CupertinoActionSheetAction>[
              CupertinoActionSheetAction(
                onPressed: () async {
                  Get.find<PhysicalExaminationController>().phoneNumber.value =
                      _accountController.userPhoneNumber.value;

                  Get.to(() => ExaminationTipsScreen());
                },
                child: Row(
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    Text("主帳號"),
                    Expanded(child: Text('')),
                    Text(_accountController.userPhoneNumber.value)
                  ],
                ),
              ),
              ..._accountController.subAccounts.map(
                (account) => CupertinoActionSheetAction(
                  onPressed: () async {
                    Get.find<PhysicalExaminationController>().phoneNumber.value =
                        account['phoneNumber'];

                    Get.to(() => ExaminationTipsScreen());
                  },
                  child: Row(
                    children: [
                      account['sex'] == "M"
                          ? Icon(
                              Icons.male,
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
                      Text(account['username']),
                      Expanded(child: Text('')),
                      Text(account['phoneNumber'])
                    ],
                  ),
                ),
              )
            ],
          )),
    );
  }
}
