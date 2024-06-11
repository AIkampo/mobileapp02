import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';

import 'package:ai_kampo_app/models/family_request.dart';
import 'package:ai_kampo_app/utils/utils.dart';
import 'package:ai_kampo_app/models/user_model.dart';
import 'family_request.dart';


enum FamilyMemberType {
  bindToPhone,
  noPhone,
}

enum AccountStatus {
  unregistered, // 尚末使用
  familyHolder, // 已註冊 - 家庭主帳號
  familyMember, // 已註冊 - 家庭成員帳號
  individuals, // 已註冊 - 無VIP和無家庭的帳號
  noPhoneUser, // 無帳號 - 供無手機的使用者使用
}
const Map<FamilyMemberType, String> familyMemberTypeString = {
  FamilyMemberType.bindToPhone: "bindToPhone",
  FamilyMemberType.noPhone: "noPhone",
};
const Map<String, String> joinFamilyErrorTranslate = {
  "invalid_type": "須提供家庭成員種類",
  "invalid_auth": "權限不足",
  "family_holder_no_phone": "家庭主成員電話號碼設置錯誤",
  "family_holder_in_other_family": "您是其他家庭的家庭成員",
  "invalid_family_holder": "無法讀取家庭主成員資訊",
  "failed_reading_family_holder": "無法讀取家庭主成員資訊",
  "invalid_arguments": "申請檔案有缺漏",
  "fail_to_get_uid": "帳號有誤",
  "member_no_phone": "申請成員帳號為無電話帳號",
  "member_in_other_family": "申請成員是其他家庭的家庭成員",
  "invalid_member": "無法讀取申請成員資訊",
  "failed_reading_member": "無法讀取申請成員資訊",
  "fail_to_request": "無法建立申請新增成員表單",
  "fail_to_create": "無法建立申請成員資料",
  "fail_to_add_member_list": "無法更新家庭成員名單",
  "failed_finding_request": "檢查申請成員家庭申請紀錄失敗",
  "pending_request": "申請表單已存在，請等候申請成員的回覆",
  "family_holder_unset": "請先完成組建家庭的步驟",
  "family_member_max_limit": "家庭成員數量過多（請刪減家庭成員後再嘗試）",
  "member_already_vip": "家庭成員不能為VIP會員",
  "duplicated_names": "不能使用與家庭主成員或其他無電話成員相同的姓名",
  "failed_checking_name": "檢查姓名是否可以使用失敗",
};
const Map<String, String> leaveFamilyErrorTranslate = {
  "invalid_arguments": "資料不齊全",
  "unauthorized_leave": "權限不足",
  "member_not_found": "查無此家庭成員",
  "family_holder_unset": "家庭成員設置錯誤",
  "family_holder_in_other_family": "家庭成員設置錯誤",
  "invalid_family_holder": "無法讀取家庭主成員資訊",
  "failed_reading_family_holder": "無法讀取家庭主成員資訊",
};

Future<AccountStatus> checkPhoneNumberStatus(String phoneNumber) async {
  AccountStatus status = AccountStatus.unregistered;
  await FirebaseFirestore.instance
  .collection("users")
  .where('phoneNumber', isEqualTo: phoneNumber)
  .where('noPhoneUser', isEqualTo: false)
  .get()
  .then((res) {
    if (res.docs.isNotEmpty) {
      Map<String, dynamic> json = res.docs[0].data();
      json["uid"] = res.docs[0].id;
      UserData targetData = UserData.fromJson(json);

      if (
        targetData.familyHolder == "" &&
        (targetData.familyMembers?? []).isEmpty
      ) {
        status = AccountStatus.individuals;
      } else {
        // family members without phone will be [phoneNumber]_[index]
        status = targetData.familyHolder == targetData.uid?
          AccountStatus.familyHolder: targetData.phoneNumber.contains("_")?
          AccountStatus.noPhoneUser: AccountStatus.familyMember;
      }
    }
  });
  return status;
}

Future<bool> checkPhoneExist(String phoneNumber) async {
  print("checkPhoneExist: $phoneNumber");
  bool valid = false;
  await FirebaseFirestore.instance
  .collection("users")
  .where('phoneNumber', isEqualTo: phoneNumber)
  .where('noPhoneUser', isEqualTo: false)
  .get()
  .then((res) {
    valid = res.docs.isNotEmpty;
  });
  return valid;
}

Future<UserData?> getUserDataByPhone(String phoneNumber) async {
  if (phoneNumber.isEmpty) return null;
  UserData? targetData;
  await FirebaseFirestore.instance
  .collection("users")
  .where('phoneNumber', isEqualTo: phoneNumber)
  .where('noPhoneUser', isEqualTo: false)
  .get()
  .then((res) {
    if (res.docs.isNotEmpty) {
      Map<String, dynamic> json = res.docs[0].data();
      json["uid"] = res.docs[0].id;
      targetData = UserData.fromJson(json);
    }
  });
  return targetData;
}

Future<UserData?> getUserDataByUid(String uid) async {
  if (uid.isEmpty) return null;
  UserData? targetData;
  await FirebaseFirestore.instance
  .collection("users")
  .doc(uid)
  .get()
  .then((snapshot) {
    if (snapshot.exists) {
      Map<String, dynamic> json = snapshot.data() as Map<String, dynamic>;
      json["uid"] = snapshot.id;
      targetData = UserData.fromJson(json);
    }
  });
  return targetData;
}

Future<void> registerMobileUser({
  required String phoneNumber,
  required String username,
  required DateTime birthday,
  required String sex,
  required String rh,
  required String bloodType,
}) async {
  try {
    HttpsCallable callable = FirebaseFunctions
      .instanceFor(region: "asia-east1")
      .httpsCallable("registerMobileUser");
    HttpsCallableResult result = await callable.call({
      "countryCode": "+886",
      "phoneNumber": phoneNumber,
      "username": username,
      "birthday": dateTimeToYearUntilDay(birthday),
      "sex": sex,
      "rh": rh,
      "bloodType": bloodType,
    })
    .timeout(const Duration(seconds: 15));
    print("registerMobileUser Result: ${result.data}");
    if (false == result.data["success"]) {
      throw Exception(result.data["reason"]);
    }
    else {
      await MobileUser().updateCustomClaims();
    }
  }
  catch(e) {
    print(e.toString());
    rethrow;
  }
}


class SmsVerification {
  final String phoneNumber;
  SmsVerification({required this.phoneNumber});

  String? _verificationId;
  String get verificationId => _verificationId?? "";

  Future<void> getVerificationCode({
    Function(String)? onError,
    Duration verificationTimeout = const Duration(seconds: 60),
  }) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    await auth.verifyPhoneNumber(
      phoneNumber: fullPhoneRepresentation("+886", phoneNumber),
      timeout: verificationTimeout,
      codeSent: (String verificationId, int? _) {
        print("codeSent: $verificationId");
        _verificationId = verificationId;
      },
      verificationFailed: (FirebaseAuthException exception) {
        print("verificationFailed: ${exception.message}");
        if (onError != null) onError(exception.message?? "");
      },
      verificationCompleted: ((PhoneAuthCredential credential) {
        print("** verificationCompleted");
      }),
      codeAutoRetrievalTimeout: ((String verificationId) {
        print("** codeAutoRetrievalTimeout");
      }),
    );
  }

  Future<PhoneAuthCredential?> checkVerificationCode({
    required String verificationCode,
  }) async {
    if (_verificationId == null) {
      throw Exception("請稍後驗證碼尚未發送或重新發送新的驗證碼！");
    }
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!, smsCode: verificationCode);
      // Always need to sign in for sms verification
      await FirebaseAuth.instance.signInWithCredential(credential);
      _verificationId = null;
      return credential;
    } catch (e) {
      throw Exception("驗證碼不符！");
    }
  }

  Future<void> logout() async {
    return FirebaseAuth.instance.signOut();
  }
}


class MobileUser {
  static MobileUser? _instance;
  factory MobileUser() => _instance?? MobileUser._internal();
  MobileUser._internal() {
    _instance = this;
    _firebaseUser = FirebaseAuth.instance.currentUser;
    _loginCheck();
  }

  static final Map<String, StreamSubscription<User?>> _subscriptions = {};
  static final Map<String, User?> _previousAuthList = {};
  User? _firebaseUser;
  final Uuid _uuid = const Uuid();
  String? _membership;
  List<String>? _familyMembers;
  String? _familyHolder;
  SmsVerification? _smsVerification;

  User? get firebaseUser => _firebaseUser;
  bool get loggedIn => _firebaseUser != null;
  String? get userId => _firebaseUser == null? null: _firebaseUser!.uid;
  String? get phoneNumber => _firebaseUser == null?
    null: removeCountryCode(_firebaseUser!.phoneNumber?? "");
  String? get membership => _membership;
  List<String>? get familyMembers => _familyMembers;
  String? get familyHolder => _familyHolder;
  bool get isFamilyHolder => _familyHolder == userId;

  void addIdTokenChangedCallback(Function(User? auth) callback) {
    FirebaseAuth.instance
    .idTokenChanges().listen((User? auth) async {
      await updateCustomClaims();
      callback(auth);
    });
  }

  void _loginCheck() {
    String id = _uuid.v4();
    _previousAuthList[id] = null;
    StreamSubscription<User?> updateUserSubscription = FirebaseAuth.instance
    .idTokenChanges().listen((User? auth) async {
      print("$id idTokenChanges");
      _previousAuthList[id] = _firebaseUser;
      _firebaseUser = auth;
      updateCustomClaims();
      print("logged in uid: ${auth == null? "None": auth.uid}");
    });
    _subscriptions[id] = updateUserSubscription;
  }

  StreamSubscription addLogoutSubscription(Function() callback) {
    // each callback has its own previous auth to make sure there correctness of
    // previous auth state, since it is multi threaded
    String id = _uuid.v4();
    _previousAuthList[id] = null;
    StreamSubscription<User?> subscription = FirebaseAuth.instance
    .authStateChanges().listen((User? auth) async {
      // assign null if value of successfullyLoggedIn is false
      _previousAuthList[id] = _firebaseUser;
      _firebaseUser = auth;
      // consider logout when previous auth is valid and current auth is invalid
      if (_previousAuthList[id] != null && _firebaseUser == null) callback();
    });
    _subscriptions[id] = subscription;
    return subscription;
  }

  void removeLogoutSubscription(StreamSubscription subscription) {
    // remove both subscription and previousAuthList
    assert(_subscriptions.containsValue(subscription) &&
      subscription is StreamSubscription<User?>);
    subscription.cancel();
    String id = _subscriptions.keys.firstWhere(
      (k) => _subscriptions[k] == subscription as StreamSubscription<User?>);
    _previousAuthList.remove(id);
    _subscriptions.remove(id);
  }

  Future<Map<String, dynamic>> updateCustomClaims() async {
    if (FirebaseAuth.instance.currentUser == null) return {};
    User? user = FirebaseAuth.instance.currentUser;
    Map<String, dynamic>? customClaims;
    if (user == null) {
      _membership = "normal";
      _familyMembers = [];
      _familyHolder = "";
    }
    else {
      await user.getIdTokenResult(true)
      .then((tokenResult) {
        Map<String, dynamic> customClaims =
        tokenResult.claims as Map<String, dynamic>;
        _membership = customClaims["membership"];
        _familyMembers = customClaims["familyMembers"] == null?
          []: List.from(customClaims["familyMembers"].cast<String>());
        _familyHolder = customClaims["familyHolder"];
        print("customClaims: $customClaims");
      });
    }
    return customClaims?? {};
  }

  Future<String?> getVerificationCode({
    required String phoneNumber,
    Duration verificationTimeout = const Duration(seconds: 60),
    Function(String)? onError,
  }) async {
    // check phone exist
    bool exist = await checkPhoneExist(phoneNumber);
    if (false == exist) {
      return "手機號碼尚未註冊！";
    }

    if (
      _smsVerification == null ||
      _smsVerification!.phoneNumber != phoneNumber
    ) {
      _smsVerification = SmsVerification(phoneNumber: phoneNumber);
    }
    await _smsVerification!.getVerificationCode(
      onError: onError,
      verificationTimeout: verificationTimeout
    );
    return null;
  }

  Future<String?> checkVerificationCode({
    required String verificationCode,
  }) async {
    if (_smsVerification == null) {
      return "驗證流程錯誤！";
    }
    try {
      PhoneAuthCredential? credential = await _smsVerification!
      .checkVerificationCode(
        verificationCode: verificationCode,
      );
      if (credential == null) "驗證失敗！";
      _addSignInRecord();
    }
    catch (e) {
      return e.toString();
    }
    return null;
  }

  Future<void> _addSignInRecord() async {
    assert(_firebaseUser != null);
    //Update SignIn datetime.
    await FirebaseFirestore.instance.collection('/users')
    .doc(_firebaseUser!.uid)
    .update({"lastSignInDatetime": dateTimeToJson(DateTime.now())})
    .catchError((error) => debugPrint("Failed to update lastSignInDatetime"));
  }

  Future<void> logout() async {
    return FirebaseAuth.instance.signOut();
  }

  String getUserName() {
    return _firebaseUser == null? "Unknown": _firebaseUser!.displayName?? "";
  }

  Future<void> createFamily() async {
    print("familyHolder: $familyHolder");
    if (isFamilyHolder) throw Exception("您已建立家庭！");
    if (familyHolder != "") throw Exception("您必須離家庭後才能建立新的家庭！");
    try {
      HttpsCallable callable = FirebaseFunctions
        .instanceFor(region: "asia-east1")
        .httpsCallable("createFamily");
      HttpsCallableResult result = await callable.call()
        .timeout(const Duration(seconds: 15));
      print("createFamily Result: ${result.data}");
      if (false == result.data["success"]) {
        throw Exception(result.data["status"]?? "");
      }
      else {
        _familyHolder = userId;
      }
    }
    catch(err) {
      rethrow;
    }
  }

  Future<void> dismissFamily() async {
    if (isFamilyHolder == false) throw Exception("您並不是家庭主成員！");
    try {
      HttpsCallable callable = FirebaseFunctions
        .instanceFor(region: "asia-east1")
        .httpsCallable("dismissFamily");
      HttpsCallableResult result = await callable.call()
        .timeout(const Duration(seconds: 15));
      print("dismissFamily Result: ${result.data}");
      if (false == result.data["success"]) {
        throw Exception(result.data["status"]?? "");
      }
      else {
        _familyHolder = "";
        _familyMembers = [];
      }
    }
    catch(err) {
      rethrow;
    }
  }

  Future<FamilyRequest?> addPhoneFamilyMember({String? phoneNumber}) async {
    if (isFamilyHolder == false) throw Exception("請先建立家庭！");
    if (_familyMembers == null) throw Exception("初始化失敗！");
    if (_familyHolder != userId) throw Exception("權限不足！");
    if (phoneNumber == null) {
      throw Exception("資料不齊全（電話綁定）！");
    }
    else {
      try {
        HttpsCallable callable = FirebaseFunctions
          .instanceFor(region: "asia-east1")
          .httpsCallable("joinFamily");
        HttpsCallableResult result = await callable.call({
          "memberType": familyMemberTypeString[FamilyMemberType.bindToPhone],
          "familyHolder": familyHolder?? "",
          "countryCode": "+886",
          "phoneNumber": phoneNumber,
        })
        .timeout(const Duration(seconds: 15));
        print("joinFamily Result: ${result.data}");
        if (false == result.data["success"]) {
          throw Exception(
            joinFamilyErrorTranslate[result.data["status"]]?? ""
          );
        }
        else {
          String requestId = result.data["requestId"];
          return await getFamilyRequestWithId(requestId);
        }
      }
      catch(err) {
        print(err);
        rethrow;
      }
    }
  }

  Future<UserData?> addNoPhoneFamilyMember({
    String? username,
    DateTime? birthday,
    String? sex,
    String? rh,
    String? bloodType,
  }) async {
    if (
      username == null ||
      birthday == null ||
      sex == null ||
      rh == null ||
      bloodType == null
    ) {
      throw Exception("資料不齊全（無電話號碼）！");
    }
    else {
      try {
        HttpsCallable callable = FirebaseFunctions
        .instanceFor(region: "asia-east1")
        .httpsCallable("joinFamily");
        HttpsCallableResult result = await callable.call({
          "memberType": familyMemberTypeString[FamilyMemberType.noPhone],
          "familyHolder": familyHolder?? "",
          "username": username,
          "birthday": dateTimeToYearUntilDay(birthday),
          "sex": sex,
          "rh": rh,
          "bloodType": bloodType,
        })
        .timeout(const Duration(seconds: 15));
        print("joinFamily Result: ${result.data}");
        if (false == result.data["success"]) {
          throw Exception(
            joinFamilyErrorTranslate[result.data["status"]]?? ""
          );
        }
        else {
          String memberUid = result.data["memberUid"];
          _familyMembers?.add(memberUid);
          return await getUserDataByUid(memberUid);
        }
      }
      catch(err) {
        print(err);
        rethrow;
      }
    }
  }

  Future<void> removeFamilyMember(String memberUid) async {
    if (_familyMembers == null) throw Exception("初始化失敗");
    if (_familyHolder != userId && userId != memberUid) throw Exception("權限不足");
    if (false == (familyMembers?? []).contains(memberUid)) {
      throw Exception("該成員不存在");
    }

    try {
      HttpsCallable callable = FirebaseFunctions
        .instanceFor(region: "asia-east1")
        .httpsCallable("leaveFamily");
      HttpsCallableResult result = await callable.call({
        "familyHolder": _familyHolder?? "",
        "requestUser": userId,
        "memberToLeave": memberUid,
      })
      .timeout(const Duration(seconds: 15));
      print("leaveFamily Result: ${result.data}");
      if (false == result.data["success"]) {
        throw Exception(
          leaveFamilyErrorTranslate[result.data["status"]]?? ""
        );
      }
      else {
        if (isFamilyHolder) {
          _familyMembers?.removeWhere((e) => e == memberUid);
        }
        else {
          _familyHolder = "";
          _membership = "normal";
          _familyMembers?.clear();
        }
      }
    }
    catch(err) {
      rethrow;
    }
  }
}
