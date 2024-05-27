import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';

import 'package:ai_kampo_app/common/config.dart';
import 'package:ai_kampo_app/widgets/common/user_avatar.dart';
import 'package:ai_kampo_app/widgets/kampo_dialog.dart';
import 'package:ai_kampo_app/controller/register_account_controller.dart';


class Step2UserInfo extends StatefulWidget {
  final RegisterAccountController registerController;
  const Step2UserInfo({
    super.key,
    required this.registerController,
  });

  @override
  State<Step2UserInfo> createState() => _Step2UserInfoState();
}

class _Step2UserInfoState extends State<Step2UserInfo> {
  late RegisterAccountController registerController;
  final _signUpFormKey = GlobalKey<FormBuilderState>();
  final isLoading = false.obs;

  @override
  void initState() {
    super.initState();
    registerController = widget.registerController;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 12),
          child: FormBuilder(
              key: _signUpFormKey,
              initialValue: const {
                "username": "",
                "birthday": "",
                "sex": "",
                "bloodType": "",
                "rh": ""
              },
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  UserAvatar(phoneNumber: registerController.signUpPhone),
                  const SizedBox(
                    height: 38,
                  ),
                  FormBuilderTextField(
                    name: "username",
                    validator: FormBuilderValidators.required(),
                    decoration: InputDecoration(labelText: "name".tr, filled: true),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  FormBuilderDateTimePicker(
                    name: 'birthday',
                    initialEntryMode: DatePickerEntryMode.calendar,
                    initialValue: DateTime.now(),
                    inputType: InputType.date,
                    decoration: InputDecoration(
                      filled: true,
                      labelText: 'birthday'.tr,
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          _signUpFormKey.currentState!.fields['birthday']?.didChange(null);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  FormBuilderRadioGroup<String>(
                    validator: FormBuilderValidators.required(),
                    decoration: InputDecoration(
                      labelText: 'sex'.tr,
                    ),
                    initialValue: null,
                    name: 'sex',
                    options: ['M', 'F']
                        .map((sex) => FormBuilderFieldOption(
                              value: sex,
                              child: Text(sex == 'M' ? 'male'.tr : 'female'.tr),
                            ))
                        .toList(growable: false),
                    controlAffinity: ControlAffinity.trailing,
                  ),
                  FormBuilderRadioGroup<String>(
                    decoration: InputDecoration(
                      labelText: 'bloodType'.tr,
                    ),
                    initialValue: null,
                    name: 'bloodType',
                    validator: FormBuilderValidators.required(),
                    options: [
                      "0",
                      "1",
                      "2",
                      "3",
                      "4",
                    ]
                        .map((type) => FormBuilderFieldOption(
                              value: type,
                              child: Text(UserProfile.bloodTypeList[int.parse(type)]),
                            ))
                        .toList(growable: false),
                    controlAffinity: ControlAffinity.trailing,
                  ),
                  FormBuilderRadioGroup<String>(
                    decoration: InputDecoration(
                      labelText: 'rh'.tr,
                    ),
                    initialValue: null,
                    name: 'rh',
                    validator: FormBuilderValidators.required(),
                    options: [
                      '0',
                      '1',
                      '2',
                    ]
                        .map((rh) => FormBuilderFieldOption(
                              value: rh,
                              child: Text(UserProfile.rhList[int.parse(rh)]),
                            ))
                        .toList(growable: false),
                    controlAffinity: ControlAffinity.trailing,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    width: double.infinity,
                    child: CupertinoButton.filled(
                      child: Text("confirm".tr),
                      onPressed: () {
                        registerUser();
                      },
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }

  Future registerUser() async {
    if (!(_signUpFormKey.currentState?.validate()?? false)) {
      return;
    }
    isLoading.value = true;
    String? errMessage = await registerController.registerAccount(
      username: _signUpFormKey.currentState!.fields["username"]?.value,
      birthday: _signUpFormKey.currentState!.fields["birthday"]?.value,
      sex: _signUpFormKey.currentState!.fields["sex"]?.value,
      rh: _signUpFormKey.currentState!.fields["rh"]?.value,
      bloodType: _signUpFormKey.currentState!.fields["bloodType"]?.value,
    );
    if (errMessage != null) {
      if (mounted) KampoDialog.confirmToPop(context, '', errMessage);
    }
    isLoading.value = false;
  }
}
