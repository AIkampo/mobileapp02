import 'package:ai_kampo_app/api/user.dart';
import 'package:get/get.dart';

import 'package:ai_kampo_app/api/quota.dart';
import 'account_controller.dart';
import 'package:ai_kampo_app/models/quota.dart';
import 'package:ai_kampo_app/models/user_model.dart';


class PhysicalExaminationController extends GetxController {
  // 當前檢測者資訊
  final _accountController = Get.find<AccountController>();
  final selectedUser = Rx<UserData?>(null);
  final quotaInfo = Rx<UserQuota?>(null);

  Future<void> refreshQuota() async {
    String quotaAccountUid = _accountController.familyHolder.value.isEmpty?
      _accountController.userId.value: _accountController.familyHolder.value;
    print("refreshQuota: $quotaAccountUid");
    quotaInfo.value = await getUserQuota(quotaAccountUid);
  }

  Future<String?> consumeQuota() async {
    try {
      await consumeExaminationQuota();
    }
    catch (e) {
      return e.toString();
    }
    return null;
  }
}
