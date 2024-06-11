import 'package:ai_kampo_app/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import 'package:ai_kampo_app/api/user.dart';
import 'package:ai_kampo_app/models/family_request.dart';
import 'package:ai_kampo_app/api/family_request.dart';
import 'account_controller.dart';


enum SignUpSteps {
  phoneVerification,
  personalInfo,
  done,
}

enum AddSubAccountSteps {
  chooseType,
  fillInfo,
  done,
}

class RegisterAccountController extends GetxController {
  SmsVerification? _smsVerification;
  final currentStep = SignUpSteps.phoneVerification.obs;

  String get signUpPhone => _smsVerification == null?
    "": _smsVerification!.phoneNumber;

  void setPhoneNumber(String phoneNumber) {
    _smsVerification = SmsVerification(phoneNumber: phoneNumber);
    currentStep.value = SignUpSteps.phoneVerification;
  }

  Future<bool> checkPhone() {
    assert(_smsVerification != null);
    return checkPhoneExist(_smsVerification!.phoneNumber);
  }

  Future<void> getVerificationCode({
    Duration verificationTimeout = const Duration(seconds: 60),
    Function(String)? onError,
  }) async {
    assert(_smsVerification != null);
    await _smsVerification!.getVerificationCode(
      verificationTimeout: verificationTimeout,
      onError: onError);
  }

  Future<String?> checkVerificationCode({
    required String verificationCode,
  }) async {
    assert(_smsVerification != null);
    try {
      PhoneAuthCredential? credential = await _smsVerification!
      .checkVerificationCode(
        verificationCode: verificationCode,
      );
      if (credential == null) {
        return "驗證失敗！";
      }
      else {
        currentStep.value = SignUpSteps.personalInfo;
      }
    }
    catch (e) {
      return e.toString();
    }
    return null;
  }

  Future<String?> registerAccount({
    required String username,
    required DateTime birthday,
    required String sex,
    required String rh,
    required String bloodType,
    String? familyHolder,
  }) async {
    assert(_smsVerification != null);
    if (currentStep.value != SignUpSteps.personalInfo) {
      return "註冊順序有誤！";
    }
    try {
      await registerMobileUser(
        phoneNumber: _smsVerification!.phoneNumber,
        username: username,
        birthday: birthday,
        sex: sex,
        rh: rh,
        bloodType: bloodType,
      );
      await Get.find<AccountController>().refreshAllAccountsInfo();
      currentStep.value = SignUpSteps.done;
    }
    catch (e) {
      return e.toString();
    }
    return null;
  }

  Future<void> logoutWhenUnregistered() async {
    if (_smsVerification == null) return;
    return _smsVerification!.logout();
  }
}


// TODO: cannot use SMS verification
class SubAccountController extends GetxController {
  FamilyRequestSearch requestSearch =
    FamilyRequestSearch(showPendingOnly: false);
  final familyRequests = <FamilyRequest>[].obs;
  final searching = false.obs;
  final showPendingOnly = false.obs;

  void reverseShowPendingOnly() async {
    showPendingOnly.value = !showPendingOnly.value;
    requestSearch = FamilyRequestSearch(showPendingOnly: showPendingOnly.value);
  }

  Future<void> refreshFamilyRequests() async {
    searching.value = true;
    requestSearch.resetSearch();
    List<FamilyRequest> results = await requestSearch.searchNext();
    familyRequests.value = results;
    searching.value = false;
  }

  Future<void> moreFamilyRequests() async {
    searching.value = true;
    List<FamilyRequest> results = await requestSearch.searchNext();
    familyRequests.addAll(results);
    searching.value = false;
  }

  Future<String?> checkPhoneStatus(String phoneNumber) async {
    if (phoneNumber == MobileUser().phoneNumber) {
      return "不能將自己加入！";
    }
    AccountStatus status = await checkPhoneNumberStatus(phoneNumber);
    switch (status) {
      case AccountStatus.familyHolder:
        return "此手機號碼已註冊為家庭主帳號！";
      case AccountStatus.familyMember:
        return "此手機號碼已經是家庭成員！";
      case AccountStatus.noPhoneUser:
        return "該帳號電話號碼為空！";
      case AccountStatus.unregistered:
        return "該帳號電話號碼尚未註冊（請先註冊後才能使用）！";
      case AccountStatus.individuals:
      default:
        return null;
    }
  }

  Future<String?> addExistedSubAccount(String phoneNumber) async {
    String? errMessage = await checkPhoneStatus(phoneNumber);
    if (errMessage != null) {
      return errMessage;
    }
    try {
      FamilyRequest? request = await MobileUser().addPhoneFamilyMember(
        phoneNumber: phoneNumber,
      );
      if (request != null) familyRequests.insert(0, request);
    }
    catch (e) {
      return e.toString();
    }
    return null;
  }

  Future<String?> addNoPhoneAccount({
    String? username,
    DateTime? birthday,
    String? sex,
    String? rh,
    String? bloodType,
  }) async {
    try {
      UserData? memberData = await MobileUser().addNoPhoneFamilyMember(
        username: username,
        birthday: birthday,
        sex: sex,
        rh: rh,
        bloodType: bloodType,
      );
      if (memberData != null) {
        Get.find<AccountController>().familyMember.insert(0, memberData.uid);
        Get.find<AccountController>().subAccountsData.insert(0, memberData);
      }
    }
    catch (e) {
      print(e);
      return e.toString();
    }
    return null;
  }

  Future<String?> updateRequest(String requestId, RegisterState state) async {
    int targetId = familyRequests.indexWhere((e) => e.requestId == requestId);
    if (targetId == -1) return "查無此邀請紀錄！";
    try {
      await updateFamilyRequest(requestId: requestId, newState: state);
      familyRequests[targetId].state = state;
      familyRequests.refresh();
      if (state == RegisterState.accepted) {
        // family member accepts family invitation
        AccountController accountController = Get.find<AccountController>();
        await accountController.refreshAllAccountsInfo();
        // some fields does not change instantly
        accountController.familyHolder.value =
          familyRequests[targetId].familyHolder;
        accountController.familyMember.value =
          accountController.holderAccountData.value == null? []:
            accountController.holderAccountData.value!.familyMembers?? [];
        accountController.membership.value =
          accountController.holderAccountData.value == null?
            accountController.membership.value:
            accountController.holderAccountData.value!.isVip? "": "";
      }
    }
    catch (e) {
      print(e);
      return e.toString();
    }
    return null;
  }
}
