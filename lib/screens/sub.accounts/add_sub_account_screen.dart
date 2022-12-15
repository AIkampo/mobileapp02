import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

class AddSubAccountScreen extends StatefulWidget {
  const AddSubAccountScreen({super.key});

  @override
  State<AddSubAccountScreen> createState() => _AddSubAccountScreenState();
}

class _AddSubAccountScreenState extends State<AddSubAccountScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("新增子帳號")),
      body: Center(
        child: Container(
          width: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                decoration: InputDecoration(
                  filled: true,
                  label: Text("手機號碼"),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              CupertinoButton.filled(
                  child: Text("新增"),
                  onPressed: (() {
                    Get.back();
                  }))
            ],
          ),
        ),
      ),
    );
  }
}
