import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

//檢測結果之背景色
Color getTestBgColor(int score) {
  Color _color;
  if (score >= 70)
    _color = Color.fromRGBO(192, 229, 179, 1);
  else if (score >= 50)
    _color = Color.fromRGBO(247, 231, 155, 1);
  else if (score >= 20)
    _color = Color.fromRGBO(252, 205, 155, 1);
  else
    _color = Color.fromRGBO(245, 185, 181, 1);

  return _color;
}
//檢測結果之文字顏色

Color getTestFontColor(int score) {
  Color _color;
  if (score >= 70)
    _color = Color.fromRGBO(0, 0, 0, 1);
  else if (score >= 50)
    _color = Color.fromARGB(255, 183, 153, 2);
  else if (score >= 20)
    _color = Color.fromARGB(255, 226, 122, 11);
  else
    _color = Color.fromRGBO(237, 7, 7, 1);

  return _color;
}

Future<bool> checkPhoneNumber(String phoneNumber) async {
  final usersCollection = FirebaseFirestore.instance.collection("users");

  var res =
      await usersCollection.where('phoneNumber', isEqualTo: phoneNumber).get();
  return res.docs.length == 1;
}
