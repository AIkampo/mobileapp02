import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';


class IntelligentCustomerServiceScreen extends StatefulWidget {
  const IntelligentCustomerServiceScreen({super.key});

  @override
  State<IntelligentCustomerServiceScreen> createState() =>
      _IntelligentCustomerServiceScreenState();
}

class _IntelligentCustomerServiceScreenState
    extends State<IntelligentCustomerServiceScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("文字客服"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            const Expanded(child: Divider(color: Colors.transparent)),
            Container(
              width: 300,
              height: 300,
              padding: const EdgeInsets.all(15),
              child: const Image(
                fit: BoxFit.contain,
                image: AssetImage(
                  "assets/images/customer_service.png",
                ),
              ),
            ),
            const Text("官方LINE: @aikampo"),
            const Divider(color: Colors.transparent),
            TextButton(
              onPressed: () async {
                final Uri url = Uri.parse("https://lin.ee/Me1CtTYw");
                if (!await launchUrl(url)) {
                  Get.snackbar("失敗", "無法開啟網址連結");
                  throw Exception(
                  "Could not launch https://lin.ee/Me1CtTYw");
                }
              },
              child: const Text("開啟連結", style: TextStyle(fontSize: 20)),
            ),
            const Expanded(child: Divider(color: Colors.transparent)),
          ],
        ),
      ),
    );
  }
}
