import 'package:ai_kampo_app/api/firebase_api.dart';
import 'package:ai_kampo_app/common/config.dart';
import 'package:ai_kampo_app/widgets/common/user_avatar.dart';
import 'package:ai_kampo_app/widgets/kampo_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _profileFormKey = GlobalKey<FormBuilderState>();
  final _phoneNumber = "".obs;
  final _userData = {}.obs;
  final _mainAccountData = {}.obs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("我的檔案"),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 12),
              child: Obx(
                () => Column(
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
                              phoneNumber: _phoneNumber.value,
                            ),
                            SizedBox(
                              height: 38,
                            ),
                            _mainAccountData['phoneNumber'] != null
                                ? Card(
                                    child: ListTile(
                                      title: Text("主帳號資訊"),
                                      subtitle: Text(
                                          '${_mainAccountData["username"]}  ${_mainAccountData["phoneNumber"]}'),
                                    ),
                                  )
                                : SizedBox.shrink(),
                            SizedBox(
                              height: 20,
                            ),
                            FormBuilderTextField(
                              name: "username",
                              validator: FormBuilderValidators.required(),
                              decoration: InputDecoration(labelText: "name".tr, filled: true),
                            ),
                            SizedBox(
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
                              padding: EdgeInsets.symmetric(vertical: 20),
                              width: double.infinity,
                              child: CupertinoButton.filled(
                                child: Text('更新'),
                                onPressed: () {
                                  if (_profileFormKey.currentState?.validate() ?? false) {
                                    updateProfile();
                                  }
                                },
                              ),
                            ),
                          ],
                        )),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  Future<void> getProfile() async {
    final prefs = await SharedPreferences.getInstance();
    _phoneNumber.value = prefs.getString('phoneNumber')!;

    await FirebaseAPI.getUserData(_phoneNumber.value).then((res) {
      _userData.value = res as Map<String, dynamic>;

      _profileFormKey.currentState!.fields['username']!.didChange(_userData['username']);
      _profileFormKey.currentState!.fields['birthday']!
          .didChange(DateTime.fromMillisecondsSinceEpoch(_userData['birthday']));
      _profileFormKey.currentState!.fields['sex']!.didChange(_userData['sex']);
      _profileFormKey.currentState!.fields['bloodType']!.didChange(_userData['bloodType']);
      _profileFormKey.currentState!.fields['rh']!.didChange(_userData['rh']);
      if (_userData['mainAccountPhoneNumber'] != null) {
        getMainAccountData(_userData['mainAccountPhoneNumber']);
      }
    }).catchError((e) {
      KampoDialog.confirmToPop(context, '', '無法取得用戶資料！');
    });
  }

  Future getMainAccountData(String phoneNumber) async {
    print('      +++++++++  getMainAccountData(String phoneNumber)');
    FirebaseAPI.getUserData(phoneNumber).then((res) {
      print(res);
      _mainAccountData.value = res;
      print(_mainAccountData['phoneNumber']);
    }).catchError((e) {
      print(e);
      KampoDialog.confirmToPop(context, '', '無法取得主帳號資訊！');
    });
  }

  Future updateProfile() async {
    print(" ========  updateProfile  =================");
    Map<String, dynamic> updatedUserData = {
      'username': _profileFormKey.currentState!.fields['username']?.value,
      'birthday': _profileFormKey.currentState!.fields['birthday']?.value.millisecondsSinceEpoch,
      'sex': _profileFormKey.currentState!.fields['sex']?.value,
      'rh': _profileFormKey.currentState!.fields['rh']?.value,
      'bloodType': _profileFormKey.currentState!.fields['bloodType']?.value,
    };
    final prefs = await SharedPreferences.getInstance();
    final userDocId = prefs.getString('userDocId')!;
    await FirebaseAPI.updateUserData(userDocId, updatedUserData).then((value) {
      KampoDialog.confirmToPop(context, '', '個人資料已更新');
    }).catchError((e) => KampoDialog.confirmToPop(context, '', '無法更新個人資料！'));
  }
}
