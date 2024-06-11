import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:ai_kampo_app/models/quota.dart';
import 'package:cloud_functions/cloud_functions.dart';


const Map<String, String> consumeExaminationQuotaErrorTranslate = {
  "user_data_unmatched": "家庭資訊有誤",
  "invalid_family_holder": "家庭主帳號資訊有誤",
  "failed_reading_family_holder": "無法讀取家庭主帳號資訊",
  "insufficient_quota": "點數不足",
  "failed_reading_quota": "無法讀取點數資訊",
  "failed_updating_quota": "更新點數資訊失敗",
};

Future<UserQuota> getUserQuota(String uid) async {
  UserQuota result = UserQuota(
    monthlyQuota: 0,
    remainingMonthlyQuota: 0,
    oneTimeQuota: 0
  );
  await FirebaseFirestore.instance.collection("quota").doc(uid)
  .get()
  .then((snapshot) {
    if (snapshot.exists) {
      Map<String, dynamic> json = snapshot.data() as Map<String, dynamic>;
      result = UserQuota.fromJson(json);
    }
  })
  .catchError((err) {
    print("getUserQuota:\n$err");
  });
  return result;
}


Future<void> consumeExaminationQuota() async {
  try {
    HttpsCallable callable = FirebaseFunctions
      .instanceFor(region: "asia-east1")
      .httpsCallable("consumeExaminationQuota");
    HttpsCallableResult result = await callable.call()
      .timeout(const Duration(seconds: 15));
    print("consumeExaminationQuota Result: ${result.data}");
    if (false == result.data["success"]) {
      throw Exception(
        consumeExaminationQuotaErrorTranslate[result.data["status"]]?? ""
      );
    }
  }
  catch(e) {
    print(e.toString());
    throw Exception("HTTP 請求失敗！");
  }
}
