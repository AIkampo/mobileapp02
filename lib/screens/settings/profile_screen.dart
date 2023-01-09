import 'package:ai_kampo_app/widgets/common/user_avatar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  final _userCollection = FirebaseFirestore.instance.collection("users");
  late DocumentReference<Map<String, dynamic>> _userDocRef;
  String _phoneNumber = "";

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
              width: 330,
              child: FormBuilder(
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
                        height: 20,
                      ),
                      UserAvatar(
                        phoneNumber: _phoneNumber,
                      ),
                      SizedBox(
                        height: 38,
                      ),
                      FormBuilderTextField(
                        name: "username",
                        validator: FormBuilderValidators.required(),
                        decoration:
                            InputDecoration(labelText: "name".tr, filled: true),
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
                        options: ['male', 'female']
                            .map((sex) => FormBuilderFieldOption(
                                  value: sex,
                                  child: Text(
                                      sex == 'male' ? 'male'.tr : 'female'.tr),
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
                          'A',
                          'B',
                          'O',
                          'AB',
                        ]
                            .map((type) => FormBuilderFieldOption(
                                  value: type,
                                  child: Text(type),
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
                          '1',
                          '2',
                          '3',
                          '?',
                        ]
                            .map((rh) => FormBuilderFieldOption(
                                  value: rh,
                                  child: Text(rh),
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
                            // Get.to(() => ServiceAgreementScreen());
                            if (_profileFormKey.currentState?.validate() ??
                                false) {
                              updateProfile();
                            }
                          },
                        ),
                      ),
                    ],
                  )),
            ),
          ),
        ));
  }

  Future<void> getProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final userDocId = prefs.getString('userDocId') ?? 'rFTc4xxJRKsg2lDkhYdY';

    setState(() {
      _userDocRef = _userCollection.doc(userDocId);
      _phoneNumber = prefs.getString('phoneNumber') ?? '0970483255';
    });
    _userDocRef.get().then((DocumentSnapshot doc) {
      final data = doc.data() as Map<String, dynamic>;

      _profileFormKey.currentState!.fields['username']!
          .didChange(data['username']);
      _profileFormKey.currentState!.fields['birthday']!
          .didChange(data['birthday'].toDate());
      _profileFormKey.currentState!.fields['sex']!.didChange(data['sex']);
      _profileFormKey.currentState!.fields['bloodType']!
          .didChange(data['bloodType']);
      _profileFormKey.currentState!.fields['rh']!.didChange(data['rh']);
    });
  }

  Future updateProfile() async {
    await _userDocRef.update({
      "username": _profileFormKey.currentState!.fields['username']?.value,
      "birthday": _profileFormKey.currentState!.fields['birthday']?.value,
      "sex": _profileFormKey.currentState!.fields['sex']?.value,
      "bloodType": _profileFormKey.currentState!.fields['bloodType']?.value,
      "rh": _profileFormKey.currentState!.fields['rh']?.value,
      "lastLoginDatetime": ""
    }).then((value) {
      Get.snackbar("更新", "個人資料已更新");
    });
  }
}
