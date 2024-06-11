import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

String caseIdToDatetime(String caseId) {
  return DateFormat('yyyy/MM/dd HH:mm').format(
    DateTime.fromMillisecondsSinceEpoch(
      int.parse(caseId),
    ),
  );
}
