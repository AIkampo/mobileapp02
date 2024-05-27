import 'dart:async';
import 'package:ai_kampo_app/api/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';

import 'package:ai_kampo_app/models/family_request.dart';


const Map<String, String> updateRequestErrorTranslate = {
  "invalid_arguments": "資料不齊全",
  "invalid_state": "未定義的邀請狀態",
  "invalid_request_state": "邀請紀錄已過期",
  "unauthorized_accept": "您的權限不適用",
  "unauthorized_auth": "您的權限不足",
  "already_in_other_family": "該成員已進入其他家庭",
  "invalid_request": "邀請紀錄有誤",
  "failed_reading_request": "無法讀取該邀請紀錄",
  "failed_updating_request": "無法讀更新邀請紀錄",
  "vip_no_allowed": "VIP會員無法加入家庭",
};

Future<FamilyRequest?> getFamilyRequestWithId(String requestId) async {
  FamilyRequest? result;
  await FirebaseFirestore.instance
  .collection("familyRequest")
  .doc(requestId)
  .get()
  .then((snapshot) {
    if (snapshot.exists) {
      Map<String, dynamic> json = snapshot.data() as Map<String, dynamic>;
      json["requestId"] = snapshot.id;
      result = FamilyRequest.fromJson(json);
    }
  });
  return result;
}

Future<void> updateFamilyRequest({
  required String requestId,
  required RegisterState newState,
}) async {
  try {
    HttpsCallable callable = FirebaseFunctions
      .instanceFor(region: "asia-east1")
      .httpsCallable("updateRequest");
    HttpsCallableResult result = await callable.call({
      "requestId": requestId,
      "newState": newState == RegisterState.accepted? "accepted": "rejected",
    })
    .timeout(const Duration(seconds: 15));
    print("updateRequest Result: ${result.data}");
    if (false == result.data["success"]) {
      throw Exception(updateRequestErrorTranslate[result.data["status"]]?? "");
    }
    else {
      await MobileUser().updateCustomClaims();
    }
  }
  catch(e) {
    print(e.toString());
    throw Exception("HTTP 請求失敗！");
  }
}

class FamilyRequestSearch {
  final bool showPendingOnly;
  QueryDocumentSnapshot? _previousSnapshot;
  FamilyRequestSearch({this.showPendingOnly = false});

  void resetSearch() => _previousSnapshot = null;

  Future<List<FamilyRequest>> searchNext({int maxSearch = 15}) async {
    dynamic targetQuery = FirebaseFirestore.instance
      .collection("familyRequest")
      .orderBy("registerDate", descending: true);

    if (showPendingOnly) {
      targetQuery = targetQuery.where("state", isEqualTo: "pending");
    }

    // search differ depends on family role
    targetQuery = MobileUser().isFamilyHolder?
      targetQuery.where("familyHolder", isEqualTo: MobileUser().userId):
      targetQuery.where("familyMember", isEqualTo: MobileUser().userId);

    targetQuery = targetQuery.limit(maxSearch);
    if (null != _previousSnapshot) {
      targetQuery = targetQuery.startAfterDocument(
        _previousSnapshot as QueryDocumentSnapshot);
    }

    List<FamilyRequest> searchResults = [];
    await targetQuery.get().then((QuerySnapshot snapshot) {
      if (snapshot.docs.isNotEmpty) {
        _previousSnapshot = snapshot.docs.last;
        for (QueryDocumentSnapshot doc in snapshot.docs) {
          Map<String, dynamic> rawData = doc.data() as Map<String, dynamic>;
          rawData["requestId"] = doc.id;
          searchResults.add(FamilyRequest.fromJson(rawData));
        }
      }
    })
    .catchError((err) {
      print("FamilyRequestSearch(searchNext):\n$err");
    });

    return searchResults;
  }
}
