import 'package:flutter/material.dart';

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
    );
  }
}
