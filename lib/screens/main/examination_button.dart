import 'package:ai_kampo_app/screens/physical.examination/confirm_points.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:ai_kampo_app/models/user_model.dart';
import 'package:ai_kampo_app/common/config.dart';
import 'package:ai_kampo_app/controller/account_controller.dart';
import 'package:ai_kampo_app/controller/physical_examination_controller.dart';
import 'package:ai_kampo_app/controller/tcm_nine_constitutions_controller.dart';

import '../../utils/utils.dart';


class ExaminationButton extends StatelessWidget {
  ExaminationButton({super.key});

  final _accountController = Get.find<AccountController>();
  final _tcmController = Get.find<TcmNineConstitutionsController>();
  final _physicalExaminationController =
    Get.find<PhysicalExaminationController>();
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
                if (_accountController.isFamilyHolder.value) {
                  _showAccountMenu(context);
                } else {
                  _physicalExaminationController.selectedUser.value =
                    _accountController.userData.value;
                  handleGoToScreen(_accountController.userId.value);
                }
              },
              child: Image.asset(
                "assets/icons/detection.png",
              ),
            ),
    );
  }

//判別是否已超過一個月沒有進行 體質表 評估
  Future<bool> shouldDoEvaluation(String uid) async {
    // TODO: currently by pass, add rating form later
    return false;

    UserData? userData = _accountController.uidToUserData(uid);
    if (userData != null) {
      if (userData.lastPhysiqueRatingDateTime == null) {
        return true;
      }
      return DateTime.now()
        .compareTo(
          userData.lastPhysiqueRatingDateTime!.add(
            Duration(days: KampoConfig.doPhysiqueRatingEveryDays)
          )
        ) == 1;
    }
    else {
      return false;
    }
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
              _physicalExaminationController.selectedUser.value =
                _accountController.userData.value!;
              _accountController.selectedUser.value =
                _accountController.userData.value!;
              _tcmController.selectUser(_accountController.userData.value!);
              handleGoToScreen(_accountController.userId.value);
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
          ..._accountController.subAccountsData.map(
            (account) => CupertinoActionSheetAction(
              onPressed: () async {
                _physicalExaminationController.selectedUser.value = account;
                _accountController.selectedUser.value = account;
                _tcmController.selectUser(account);
                handleGoToScreen(account.uid);
              },
              child: Row(
                children: [
                  account.sex == "M"
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
                  Text(account.username),
                  const Expanded(child: VerticalDivider(color: Colors.transparent)),
                  if (false == account.noPhoneUser)
                    Text(account.phoneNumber),
                  if (account.noPhoneUser)
                    Text(
                      "${UserProfile.bloodTypeList[int.parse(account.bloodType)]}型  "
                      "${account.birthday == null? "": dateTimeToYearUntilDay(account.birthday!)}  ",
                      style: const TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  if (account.noPhoneUser)
                    const Icon(Icons.phonelink_erase),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
  Future handleGoToScreen(String uid) async{
     if (await shouldDoEvaluation(uid)) {
        Get.toNamed("/tcm.nine.constitutions");
     } else {
        Get.toNamed("/confirm.points");
     }
  }
}
