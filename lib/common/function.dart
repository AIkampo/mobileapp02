import 'package:ai_kampo_app/api/firebase_api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

//檢測結果之背景色
Color getTestBgColor(int score) {
  Color color;
  if (score >= 70) {
    color = Color.fromRGBO(192, 229, 179, 1);
  } else if (score >= 50) {
    color = Color.fromRGBO(247, 231, 155, 1);
  } else if (score >= 20) {
    color = Color.fromRGBO(252, 205, 155, 1);
  } else {
    color = Color.fromRGBO(245, 185, 181, 1);
  }
  return color;
}
//檢測結果之文字顏色

Color getTestFontColor(int score) {
  Color color;
  if (score >= 70) {
    color = Color.fromRGBO(0, 0, 0, 1);
  } else if (score >= 50) {
    color = Color.fromARGB(255, 183, 153, 2);
  } else if (score >= 20) {
    color = Color.fromARGB(255, 226, 122, 11);
  } else {
    color = Color.fromRGBO(237, 7, 7, 1);
  }
  return color;
}

Future<bool> checkPhoneNumber(String phoneNumber) async {
  final usersCollection = FirebaseFirestore.instance.collection("users");

  var res = await usersCollection.where('phoneNumber', isEqualTo: phoneNumber).get();
  return res.docs.length == 1;
}

Future<int> checkPhoneNumberStatus(String phoneNumber) async {
  // 0 => 尚末使用
  // 1 => 已註冊 - 主帳號
  // 2 => 已註冊 - 子帳號
  // 3 => 已註冊 - 未被加入子帳號

  int status = 0;
  await FirebaseFirestore.instance
      .collection("users")
      .where('phoneNumber', isEqualTo: phoneNumber)
      .get()
      .then((res) {
    if (res.docs.isNotEmpty) {
      if (res.docs[0]['isPremium']) {
        status = 1;
      } else if (res.docs[0]['mainAccountPhoneNumber'] != null) {
        status = 2;
      } else {
        status = 3;
      }
    }
  }).then((value) => status);

  return status;
}

String caseIdToDatetime(String caseId) {
  return DateFormat('yyyy/MM/dd').format(
    DateTime.fromMillisecondsSinceEpoch(
      int.parse(caseId),
    ),
  );
}

Future<void> doSignIn(lastSignInDatetime, phoneNumber, userDocId, isMainAccount, userSex) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('phoneNumber', phoneNumber);
  await prefs.setString('userDocId', userDocId);
  await prefs.setBool('isMainAccount', isMainAccount);
  await prefs.setString('userSex', userSex);
  Get.offAndToNamed(lastSignInDatetime ? "/main" : "/service.agreement");
  //Update SignIn datetime.
  await FirebaseAPI.updateUserData(userDocId, {'lastSignInDatetime': DateTime.now()})
      .catchError((error) => debugPrint("Failed to update lastSignInDatetime"));
}
