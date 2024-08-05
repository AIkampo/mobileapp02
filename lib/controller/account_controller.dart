import 'dart:async';

import 'package:ai_kampo_app/api/user.dart';
import 'package:ai_kampo_app/models/user_model.dart';
import 'package:get/get.dart';

class AccountController extends GetxController {
  final user = MobileUser().obs;
  final isLoading = true.obs;
  //使用者本人（登入者）手機號碼
  final userLoggedIn = false.obs;
  final userId = "".obs;
  final userName = "".obs;
  final membership = "".obs;
  final userPhoneNumber = "".obs;
  final familyMember = <String>[].obs;
  final familyHolder = "".obs;
  final userData = Rx<UserData?>(null);
  final isFamilyHolder = false.obs;
  final selectedUser = Rx<UserData?>(null);
  final subAccountsData = <UserData>[].obs;
  final holderAccountData = Rx<UserData?>(null);

  @override
  void onInit() {
    super.onInit();
    refreshAll();
    // on change event
    user.value.addIdTokenChangedCallback((_) async {
      print("addIdTokenChangedCallback");
      refreshAll();
    });
  }

  Future<void> refreshAll() async {
    isLoading.value = true;
    await user.value.updateCustomClaims();
    userLoggedIn.value = user.value.loggedIn;
    userId.value = user.value.userId?? "";
    userName.value = user.value.getUserName();
    membership.value = user.value.membership?? "";
    userPhoneNumber.value = user.value.phoneNumber?? "";
    familyMember.value = user.value.familyMembers == null?
      []: List.from(user.value.familyMembers!);
    familyHolder.value = user.value.familyHolder?? "";
    isFamilyHolder.value = user.value.isFamilyHolder;
    await refreshAllAccountsInfo();
    selectedUser.value ??= userData.value;
    user.refresh();
    isLoading.value = false;
  }

  UserData? uidToUserData(String uid) {
    if (uid == userId.value) {
      return userData.value;
    }
    if (uid == familyHolder.value) {
      return holderAccountData.value;
    }
    else {
      if (subAccountsData.indexWhere((e) => e.uid == uid) == -1) return null;
      return subAccountsData.firstWhere((e) => e.uid == uid);
    }
  }

  void selectWithUid(String uid) {
    if (uid == userId.value) {
      selectedUser.value = userData.value;
    }
    else if (uid == familyHolder.value) {
      selectedUser.value = holderAccountData.value;
    }
    else {
      int targetIdx = subAccountsData.indexWhere((e) => e.uid == uid);
      selectedUser.value = subAccountsData[targetIdx];
    }
  }
  resetSelection() => selectedUser.value = userData.value;

  Future<void> refreshAllAccountsInfo() async {
    List<Future> tasks = [];

    Future<UserData?> userDataTask = getUserDataByUid(MobileUser().userId?? "")
    .then((value) => userData.value = value);
    tasks.add(userDataTask);

    if (familyHolder.value.isNotEmpty) {
      Future<UserData?> holderDataTask = getUserDataByUid(familyHolder.value)
      .then((value) => holderAccountData.value = value);
      tasks.add(holderDataTask);
    }
    else {
      holderAccountData.value = null;
    }

    List<UserData> accountsInfo = [];
    for (String uid in familyMember) {
      Future<UserData?> task = getUserDataByUid(uid)
      .then((value) {
        if (value != null) accountsInfo.add(value);
        return null;
      });
      tasks.add(task);
    }
    try {
      await Future.wait(tasks).timeout(const Duration(seconds: 10));
      subAccountsData.value = accountsInfo;
      // refresh selected user
      if (selectedUser.value != null) {
        String targetUid = selectedUser.value!.uid;
        int targetIdx = subAccountsData.indexWhere((e) => e.uid == targetUid);
        selectedUser.value = targetIdx == -1?
        userData.value: subAccountsData[targetIdx];
      }
    } on TimeoutException catch (_) {
      print("refreshAllAccountsInfo timeout");
    }
  }

  Future<String?> getVerificationCode({
    required String phoneNumber,
    Duration verificationTimeout = const Duration(seconds: 60),
    Function(String)? onError,
  }) => user.value.getVerificationCode(
    phoneNumber: phoneNumber,
    verificationTimeout: verificationTimeout,
    onError: onError
  );

  Future<String?> checkVerificationCode({
    required String verificationCode,
  }) => user.value.checkVerificationCode(
    verificationCode: verificationCode);

  Future<void> logout() =>
    user.value.logout().then((_) => selectedUser.value = null);

  Future<String?> removeMember(String memberUid) async {
    try {
      await user.value.removeFamilyMember(memberUid);
      if (familyHolder.value != userId.value) {
        familyHolder.value = "";
        membership.value = "normal";
        familyMember.clear();
      }
      else {
        familyMember.removeWhere((e) => e == memberUid);
        if (selectedUser.value != null && selectedUser.value!.uid == memberUid) {
          selectedUser.value = userData.value;
        }
      }
      await refreshAllAccountsInfo();
    }
    catch (e) {
      return e.toString();
    }
    return null;
  }

  Future<String?> createFamily() async {
    try {
      await user.value.createFamily();
      isFamilyHolder.value = true;
      familyHolder.value = userId.value;
      await getUserDataByUid(familyHolder.value)
      .then((value) => holderAccountData.value = value);
    }
    catch (e) {
      return e.toString();
    }
    return null;
  }

  Future<String?> dismissFamily() async {
    try {
      await user.value.dismissFamily();
      isFamilyHolder.value = false;
      familyHolder.value = "";
      holderAccountData.value = null;
      familyMember.clear();
      subAccountsData.clear();
    }
    catch (e) {
      return e.toString();
    }
    return null;
  }

  Future<String?> updateUserData({
    required String uid,
    bool? agreeServiceAgreement,
    String? username,
    DateTime? birthday,
    Gender? gender,
    Rhesus? rh,
    BloodType? bloodType,
    DateTime? lastPhysiqueRatingDateTime,
  }) async {
    if (uid.isEmpty) {
      return "請提供正確的帳號資訊！";
    }
    if (userData.value == null) {
      return "無法讀取使用者資料！";
    }

    String? errMessage;
    if (uid == userId.value) {
      errMessage = await userData.value!.updateUserData(
        newAgreeServiceAgreement: agreeServiceAgreement,
        newUsername: username,
        newBirthday: birthday,
        newGender: gender,
        newRh: rh,
        newBloodType: bloodType,
        newLastPhysiqueRatingDateTime: lastPhysiqueRatingDateTime,
      );
      userData.refresh();
      if (
        holderAccountData.value != null &&
        uid == holderAccountData.value!.uid
      ) {
        holderAccountData.value = userData.value;
        holderAccountData.refresh();
      }
    }
    else if (subAccountsData.indexWhere((e) => e.uid == uid) != -1) {
      int targetIdx = subAccountsData.indexWhere((e) => e.uid == uid);
      errMessage = await subAccountsData[targetIdx].updateUserData(
        newAgreeServiceAgreement: agreeServiceAgreement,
        newUsername: username,
        newBirthday: birthday,
        newGender: gender,
        newRh: rh,
        newBloodType: bloodType,
        newLastPhysiqueRatingDateTime: lastPhysiqueRatingDateTime,
      );
      subAccountsData.refresh();
    }
    else {
      errMessage = "無法找到該家族成員！";
    }
    return errMessage;
  }
}
