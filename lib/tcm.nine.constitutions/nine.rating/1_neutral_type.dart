// 1. 平和型
import 'package:flutter/material.dart';

class NeutralType extends StatelessWidget {
  const NeutralType({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('平和型')),
      body: SingleChildScrollView(
        child: Stepper(physics: const ClampingScrollPhysics(), steps: buildStep()),
      ),
    );
  }

  List<Step> buildStep() {
    return [Step(title: Text("111"), content: Text("133"))];
  }
}
