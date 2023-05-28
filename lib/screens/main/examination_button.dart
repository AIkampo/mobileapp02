import 'package:ai_kampo_app/api/firebase_api.dart';
import 'package:ai_kampo_app/common/config.dart';
import 'package:ai_kampo_app/controller/account_controller.dart';
import 'package:ai_kampo_app/controller/physical_examination_controller.dart';
import 'package:ai_kampo_app/controller/tcm_nine_constitutions_controller.dart';
import 'package:ai_kampo_app/screens/physical.examination/examination_tips_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
                  Get.find<PhysicalExaminationController>().phoneNumber.value =
                      _accountController.userPhoneNumber.value;
                
                  handleGoToScreen(_accountController.userPhoneNumber.value);
                }
              },
              child: Image.asset(
                "assets/icons/detection.png",
              ),
            ),
    );
  }

//判別是否已超過一個月沒有進行 體質表 評估
  Future<bool> shoudDoEvaluation(String phoneNumer) async {
    return await FirebaseAPI.getUserData(phoneNumer).then((data) {
      //尚未做過
      if (data['lastPhysiqueRatingDateTime'] == null) {
        return true;
      }
      Timestamp lastPhysiqueRatingDateTimestamp = data['lastPhysiqueRatingDateTime'] as Timestamp;
      DateTime lastPhysiqueRatingDateTime = DateTime.fromMillisecondsSinceEpoch(
          lastPhysiqueRatingDateTimestamp.millisecondsSinceEpoch);

      return DateTime.now().compareTo(lastPhysiqueRatingDateTime
              .add(Duration(days: KampoConfig.doPhysiqueRatingEveryDays))) ==
          1;
    }).catchError((error) {
      return false;
    });
  }

  void _showAccountMenu(context) async {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title:  Text(
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
          // for main account
          CupertinoActionSheetAction(
            onPressed: () async {
              Get.find<PhysicalExaminationController>().phoneNumber.value =
                  _accountController.userPhoneNumber.value;

              final prefs = await SharedPreferences.getInstance();
              Get.find<TcmNineConstitutionsController>().currentUserPhoneNumber.value =
                  _accountController.userPhoneNumber.value;

              Get.find<TcmNineConstitutionsController>().currentUserSex.value =
                  prefs.getString('userSex')!;
              
              handleGoToScreen(_accountController.userPhoneNumber.value);
            },
            child: Row(
              children: [
               const SizedBox(
                  width: 10,
                ),
                Text("主帳號"),
               const Expanded(child: Text('')),
                Text(_accountController.userPhoneNumber.value)
              ],
            ),
          ),
          //for sub accounts
          ..._accountController.subAccounts.map(
            (account) => CupertinoActionSheetAction(
              onPressed: () async {
                Get.find<PhysicalExaminationController>().phoneNumber.value =
                    account['phoneNumber'];
                Get.find<TcmNineConstitutionsController>().currentUserPhoneNumber.value =
                    account['phoneNumber'];

                Get.find<TcmNineConstitutionsController>().currentUserSex.value = account['sex'];
                handleGoToScreen(account['phoneNumber']);
              },
              child: Row(
                children: [
                  account['sex'] == "M"
                      ? const Icon(
                          Icons.male,
                          color: Colors.blue,
                          size: 30,
                        )
                      : const Icon(
                          Icons.female,
                          color: Colors.red,
                          size: 30,
                        ),
                 const  SizedBox(
                    width: 10,
                  ),
                  Text(account['username']),
                  const Expanded(child: Text('')),
                  Text(account['phoneNumber'])
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
  Future handleGoToScreen(String phoneNumber) async{
     if (await shoudDoEvaluation(phoneNumber)) {
        Get.toNamed("/tcm.nine.constitutions");
     } else {
        Get.to(() => ExaminationTipsScreen());
     }

  }
}
