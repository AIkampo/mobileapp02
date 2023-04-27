import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ClinicsWebviewScreen extends StatefulWidget {
  const ClinicsWebviewScreen({super.key});

  @override
  State<ClinicsWebviewScreen> createState() => _ClinicsWebviewScreenState();
}

class _ClinicsWebviewScreenState extends State<ClinicsWebviewScreen> {
  WebViewController controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setBackgroundColor(const Color(0x00000000))
    ..loadRequest(Uri.parse(
        'https://www.google.com/maps/d/u/0/viewer?mid=1RWhL8T6VP6MJMDZTEcx36F4qRQyaa4w&ll=23.64490396391735%2C120.12089905&z=8'));
  @override
  Widget build(BuildContext context) {
    return WebViewWidget(controller: controller);
  }
}
