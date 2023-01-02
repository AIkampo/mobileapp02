import 'dart:io';

import 'package:ai_kampo_app/controller/auth.controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class Step2UserInfo extends StatefulWidget {
  const Step2UserInfo({super.key});

  @override
  State<Step2UserInfo> createState() => _Step2UserInfoState();
}

class _Step2UserInfoState extends State<Step2UserInfo> {
  final _authController = Get.find<AuthController>();

  final _signUpFormKey = GlobalKey<FormBuilderState>();
  final _fs = FirebaseFirestore.instance;
  File? _userAvater = null;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Container(
          width: 330,
          child: FormBuilder(
              key: _signUpFormKey,
              initialValue: {
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
                  GestureDetector(
                    onTap: () {
                      getImageFromGallery();
                    },
                    child: _userAvater == null
                        ? CircleAvatar(
                            child: Icon(
                              CupertinoIcons.person,
                              size: 50,
                            ),
                            radius: 50,
                          )
                        : CircleAvatar(
                            backgroundImage: FileImage(_userAvater!),
                            radius: 50,
                          ),
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
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          _signUpFormKey.currentState!.fields['date']
                              ?.didChange(null);
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  FormBuilderRadioGroup<String>(
                    validator: FormBuilderValidators.required(),
                    decoration: InputDecoration(
                      labelText: 'sex'.tr,
                    ),
                    initialValue: null,
                    name: 'sex',
                    options: ['male', 'female']
                        .map((sex) => FormBuilderFieldOption(
                              value: sex,
                              child:
                                  Text(sex == 'male' ? 'male'.tr : 'female'.tr),
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
                      child: Text("confirm".tr),
                      onPressed: () {
                        // Get.to(() => ServiceAgreementScreen());
                        if (_signUpFormKey.currentState?.validate() ?? false) {
                          registerUser();
                        }
                      },
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }

  Future getImageFromGallery() async {
    final _img = await ImagePicker().pickImage(source: ImageSource.gallery);
    try {
      if (_img == null) return;
      File? tempImg = File(_img.path);
      tempImg = await CropImage(imgFile: tempImg);
      setState(() {
        _userAvater = tempImg;
      });
    } catch (e) {
      print("********** Update Image:" + e.toString());
    }
  }

  Future<File?> CropImage({required File imgFile}) async {
    CroppedFile? _croppedImg =
        await ImageCropper().cropImage(sourcePath: imgFile.path);
    if (_croppedImg == null) return null;
    return File(_croppedImg.path);
  }

  Future registerUser() async {
    final phoneNumber = _authController.signUpPhoneNumber.value;
    var userAvatarRef = "";

    //使用者有上傳照片=> _userAvater.value != null 才需執行
    if (_userAvater != null) {
      userAvatarRef = "userAvatar/$phoneNumber.jpg";
      final ref = FirebaseStorage.instance.ref(userAvatarRef).child("");
      ref.putFile(_userAvater!);
    }

    await _fs.collection("users").add({
      "userAvatar": userAvatarRef,
      "username": _signUpFormKey.currentState!.fields['username']?.value,
      "phoneNumber": phoneNumber,
      "birthday": _signUpFormKey.currentState!.fields['birthday']?.value,
      "sex": _signUpFormKey.currentState!.fields['sex']?.value,
      "bloodType": _signUpFormKey.currentState!.fields['bloodType']?.value,
      "rh": _signUpFormKey.currentState!.fields['rh']?.value,
      "lastLoginDatetime": ""
    }).then((value) {
      _authController.signUpCurrentStep.value = 2;
    });
  }
}
