import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  List dataList = [
    {"title": "信用卡", "icon": "assets/icons/payment/credit.card.png", "screen": ""},
    {"title": "金融卡", "icon": "assets/icons/payment/visa.png", "screen": ""},
    {"title": "Apple Pay", "icon": "assets/icons/payment/apple.pay.png", "screen": ""},
    {"title": "Google Pay", "icon": "assets/icons/payment/google.pay.png", "screen": ""},
    {"title": "Line Pay", "icon": "assets/icons/payment/line.pay.png", "screen": ""},
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text("付款方式")),
      body: ListView.builder(
        itemCount: dataList.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              onTap: () {
                Get.offAndToNamed("/main");
              },
              contentPadding: EdgeInsets.all(8),
              leading: Image.asset("${dataList[index]['icon']}"),
              title: Text("${dataList[index]['title']}"),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
          );
        },
      ),
    );
  }
}
