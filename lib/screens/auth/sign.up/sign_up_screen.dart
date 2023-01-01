import 'dart:io';

import 'package:ai_kampo_app/screens/auth/sign.up/service_agreement_screen.dart';
import 'package:ai_kampo_app/utils/EncryptPassword.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _signUpFormKey = GlobalKey<FormBuilderState>();
  File? _userImg;
  final _fs = FirebaseFirestore.instance;
  var _phoneNumberCheckable = false.obs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final db = FirebaseFirestore.instance;
    // db.collection("user").doc("d11S7VxcAD0DfoPrQ4zN").get().then(
    //     (DocumentSnapshot doc) {
    //   final data = doc.data() as Map<String, dynamic>;
    //   print("********** $data");
    // }, onError: (e) => print("Error getting doc:$e"));
    return Scaffold(
      appBar: AppBar(title: Text("signUp".tr)),
      body: Obx(
        () => SingleChildScrollView(
          child: Center(
            child: Container(
              width: 330,
              child: FormBuilder(
                  key: _signUpFormKey,
                  initialValue: {
                    "name": "",
                    "phoneNumber": "096351721",
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
                        child: _userImg == null
                            ? CircleAvatar(
                                child: Icon(
                                  CupertinoIcons.person,
                                  size: 50,
                                ),
                                radius: 50,
                              )
                            : CircleAvatar(
                                backgroundImage: FileImage(_userImg!),
                                radius: 50,
                              ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      FormBuilderTextField(
                        name: "name",
                        validator: FormBuilderValidators.required(),
                        decoration:
                            InputDecoration(labelText: "name".tr, filled: true),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      FormBuilderTextField(
                        keyboardType: TextInputType.phone,
                        name: "phoneNumber",
                        validator: FormBuilderValidators.required(),
                        onChanged: (value) {
                          _phoneNumberCheckable.value = value!.length == 10;
                        },
                        decoration: InputDecoration(
                          filled: true,
                          labelText: "phone".tr,
                          suffix: TextButton(
                            onPressed: _phoneNumberCheckable.value
                                ? () => checkPhoneNumber()
                                : null,
                            child: Text("驗證"),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      FormBuilderTextField(
                        keyboardType: TextInputType.phone,
                        name: "verificationCode",
                        validator: FormBuilderValidators.required(),
                        decoration: InputDecoration(
                          labelText: "手機驗證碼",
                        ),
                        // onEditingComplete: () {
                        //   print(" ***** onEditingComplete");
                        // },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      // FormBuilderTextField(
                      //   obscureText: true,
                      //   name: "password",
                      //   validator: FormBuilderValidators.required(),
                      //   decoration: InputDecoration(
                      //       filled: true, labelText: "password".tr),
                      // ),
                      // SizedBox(
                      //   height: 20,
                      // ),
                      // FormBuilderTextField(
                      //   obscureText: true,
                      //   name: "confirmPassword",
                      //   validator: FormBuilderValidators.required(),
                      //   decoration: InputDecoration(
                      //       filled: true, labelText: "confirmPassword".tr),
                      // ),
                      // SizedBox(
                      //   height: 20,
                      // ),
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
                        options: ['male'.tr, 'female'.tr]
                            .map((sex) => FormBuilderFieldOption(
                                  value: sex,
                                  child: Text(sex),
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
                            if (_signUpFormKey.currentState?.validate() ??
                                false) {
                              registerUser();
                            }
                            // registerUser();
                          },
                        ),
                      ),
                    ],
                  )),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> checkPhoneNumber() async {
    final usersCollection = _fs.collection("users");
    final phoneNumber =
        _signUpFormKey.currentState!.fields["phoneNumber"]?.value;
    try {
      usersCollection
          .where(
            'phoneNumber',
            isEqualTo: phoneNumber,
          )
          .get()
          .then((value) {
        if (value.docs.length == 1) {
          Get.snackbar("驗證失敗", "手機號碼已註冊！");
        } else {
          Get.toNamed("/verify.code", arguments: {'phoneNumber': phoneNumber});
        }
      });
    } catch (e) {
      print('************* Failed~ checkPhoneNumber e:${e}');
    }
  }

  Future getImageFromGallery() async {
    final _img = await ImagePicker().pickImage(source: ImageSource.gallery);
    try {
      if (_img == null) return;
      File? tempImg = File(_img.path);
      tempImg = await CropImage(imgFile: tempImg);
      setState(() {
        _userImg = tempImg;
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

  Stream readUsers() =>
      FirebaseFirestore.instance.collection("user").snapshots().map(
            (snapshot) => snapshot.docs.map(
              (doc) => print("***${doc.data().toString()}"),
            ),
          );

  Future registerUser() async {
    await FirebaseFirestore.instance.collection("user").add({
      "name": _signUpFormKey.currentState!.fields['name']?.value,
      "phone": _signUpFormKey.currentState!.fields['phone']?.value,
      "birthday": _signUpFormKey.currentState!.fields['birthday']?.value,
      "sex": _signUpFormKey.currentState!.fields['sex']?.value,
      "bloodType": _signUpFormKey.currentState!.fields['bloodType']?.value,
      "rh": _signUpFormKey.currentState!.fields['rh']?.value,
    });

    final ref = FirebaseStorage.instance
        .ref(
            "userAvatar/${_signUpFormKey.currentState!.fields['phone']?.value}.jpg")
        .child("");
    ref.putFile(_userImg!);
  }

  void _onChanged(dynamic val) => debugPrint(val.toString());
}
