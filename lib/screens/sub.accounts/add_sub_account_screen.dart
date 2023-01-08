import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import 'package:get/get.dart';

class AddSubAccountScreen extends StatefulWidget {
  const AddSubAccountScreen({super.key});

  @override
  State<AddSubAccountScreen> createState() => _AddSubAccountScreenState();
}

class _AddSubAccountScreenState extends State<AddSubAccountScreen> {
  final _subAccountFormkey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("新增子帳號"),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          width: 300,
          child: FormBuilder(
            key: _subAccountFormkey,
            initialValue: {
              "username": "",
              "phoneNumber": "",
              "sex": "",
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FormBuilderTextField(
                  name: 'username',
                  validator: FormBuilderValidators.required(),
                  decoration: InputDecoration(
                    labelText: "姓名",
                    filled: true,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                FormBuilderTextField(
                  name: "phoneNumber",
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                    FormBuilderValidators.equalLength(10),
                    FormBuilderValidators.maxLength(10)
                  ]),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    filled: true,
                    labelText: "手機號碼",
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                FormBuilderRadioGroup<String>(
                  name: "sex",
                  validator: FormBuilderValidators.required(),
                  initialValue: null,
                  options: ['male', 'female']
                      .map((sex) => FormBuilderFieldOption(
                            value: sex,
                            child:
                                Text(sex == 'male' ? 'male'.tr : 'female'.tr),
                          ))
                      .toList(),
                  decoration: InputDecoration(labelText: '性別'),
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: double.infinity,
                  child: CupertinoButton.filled(
                    child: Text("新增"),
                    onPressed: (() {
                      handleAddSubAccount();
                    }),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> handleAddSubAccount() async {
    if (_subAccountFormkey.currentState?.validate() ?? true) {
      Get.snackbar("新增子帳號", "成功");
    }
  }
}
