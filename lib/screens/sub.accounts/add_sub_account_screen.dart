import 'package:ai_kampo_app/api/firebase_api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
          margin: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
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
    if (!(_subAccountFormkey.currentState?.validate() ?? false)) {
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final userPhoneNumber = prefs.getString('phoneNumber') ?? '0970483255';
    final subAccountPhoneNumber =
        _subAccountFormkey.currentState!.fields['phoneNumber']?.value;

    if (userPhoneNumber == subAccountPhoneNumber) {
      Get.snackbar("失敗", "不能將自己加入！");
      return;
    }

    if (await FirebaseAPI.checkPhoneNumberStatus(subAccountPhoneNumber)) {
      FirebaseAPI.addUser({
        'username': _subAccountFormkey.currentState!.fields['username']?.value,
        'phoneNumber': subAccountPhoneNumber,
        'sex': _subAccountFormkey.currentState!.fields['sex']?.value,
        'mainAccount': userPhoneNumber
      }).then((value) {
        Get.back();
        Get.snackbar("新增子帳號", "成功");
        setState(() {});
      });
    } else {
      Get.snackbar("失敗", "此帳號已註冊");
    }
  }
}
