import 'package:ai_kampo_app/models/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';

import 'package:ai_kampo_app/api/firebase_api.dart';
import 'package:ai_kampo_app/common/config.dart';
import 'package:ai_kampo_app/widgets/common/user_avatar.dart';
import 'package:ai_kampo_app/widgets/kampo_dialog.dart';
import 'package:ai_kampo_app/controller/account_controller.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AccountController _accountController = Get.find<AccountController>();
  final _profileFormKey = GlobalKey<FormBuilderState>();

  @override
  void initState() {
    super.initState();
    getProfile();
  }

  @override
  Widget build(BuildContext context) {
    UserData? holderData = _accountController.holderAccountData.value;
    UserData? userData = _accountController.userData.value;
    return Scaffold(
        appBar: AppBar(
          title: Text("我的檔案"),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 12),
              child: Obx(() {
                if (_accountController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                return Column(
                  children: [
                    FormBuilder(
                        key: _profileFormKey,
                        initialValue: const {
                          "username": "",
                          "birthday": "",
                          "sex": "",
                          "bloodType": "",
                          "rh": ""
                        },
                        child: Column(
                          children: [
                            SizedBox(
                              height: 38,
                            ),
                            UserAvatar(
                              phoneNumber: _accountController.userPhoneNumber
                                  .value,
                            ),
                            SizedBox(
                              height: 38,
                            ),
                            if (holderData != null)
                              Card(
                                child: ListTile(
                                  title: const Text("家庭主成員帳號"),
                                  subtitle: Text(
                                    '${holderData.username}  ${holderData
                                        .phoneNumber}'),
                                ),
                              ),
                            if (userData != null)
                              Card(
                                child: ListTile(
                                  title: const Text("帳號綁定手機"),
                                  subtitle: Text(userData.phoneNumber),
                                ),
                              ),
                            SizedBox(
                              height: 20,
                            ),
                            FormBuilderTextField(
                              name: "username",
                              validator: FormBuilderValidators.required(),
                              decoration: InputDecoration(
                                  labelText: "name".tr, filled: true),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            FormBuilderDateTimePicker(
                              name: 'birthday',
                              initialEntryMode: DatePickerEntryMode.calendar,
                              initialValue: DateTime.now(),
                              lastDate: DateTime.now(),
                              inputType: InputType.date,
                              decoration: InputDecoration(
                                filled: true,
                                labelText: 'birthday'.tr,
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            FormBuilderRadioGroup<String>(
                              validator: FormBuilderValidators.required(),
                              decoration: InputDecoration(
                                labelText: '性別',
                              ),
                              initialValue: null,
                              name: 'sex',
                              options: ['M', 'F']
                                  .map((sex) =>
                                  FormBuilderFieldOption(
                                    value: sex,
                                    child: Text(
                                        sex == 'M' ? 'male'.tr : 'female'.tr),
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
                                  .map((type) =>
                                  FormBuilderFieldOption(
                                    value: type,
                                    child: Text(
                                        UserProfile.bloodTypeList[int.parse(
                                            type)]),
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
                                  .map((rh) =>
                                  FormBuilderFieldOption(
                                    value: rh,
                                    child: Text(
                                        UserProfile.rhList[int.parse(rh)]),
                                  ))
                                  .toList(growable: false),
                              controlAffinity: ControlAffinity.trailing,
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 20),
                              width: double.infinity,
                              child: CupertinoButton.filled(
                                child: Text('更新'),
                                onPressed: () {
                                  if (_profileFormKey.currentState
                                      ?.validate() ?? false) {
                                    updateProfile();
                                  }
                                },
                              ),
                            ),
                          ],
                        )),
                  ],
                );
              }),
            ),
          ),
        ));
  }

  Future<void> getProfile() async {
    await _accountController.refreshAllAccountsInfo();
    UserData userData = _accountController.userData.value!;
    _profileFormKey.currentState!.fields['username']!.didChange(userData.username);
    _profileFormKey.currentState!.fields['birthday']!.didChange(userData.birthday);
    _profileFormKey.currentState!.fields['sex']!.didChange(userData.sex);
    _profileFormKey.currentState!.fields['bloodType']!.didChange(userData.bloodType);
    _profileFormKey.currentState!.fields['rh']!.didChange(userData.rh);
  }

  Future updateProfile() async {
    String? errMessage = await _accountController.updateUserData(
      uid: _accountController.userId.value,
      username: _profileFormKey.currentState!.fields['username']?.value,
      birthday: _profileFormKey.currentState!.fields['birthday']?.value,
      sex: _profileFormKey.currentState!.fields['sex']?.value,
      rh: _profileFormKey.currentState!.fields['rh']?.value,
      bloodType: _profileFormKey.currentState!.fields['bloodType']?.value,
    );

    if (errMessage == null) {
      if (mounted) KampoDialog.confirmToPop(context, '', '個人資料已更新');
    }
    else {
      if (mounted) KampoDialog.confirmToPop(context, '', errMessage);
    }
  }
}
