import 'dart:io';

import 'package:ai_kampo_app/screens/auth/sign.up/service_agreement_screen.dart';
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
  final _formKey = GlobalKey<FormBuilderState>();
  File? _userImg;

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
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: 330,
            child: FormBuilder(
                key: _formKey,
                onChanged: () {
                  print("++++${_formKey.currentState!.fields}");
                },
                initialValue: {
                  "name": "12345",
                  "phone": "0912345678",
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
                      name: "phone",
                      validator: FormBuilderValidators.required(),
                      decoration:
                          InputDecoration(filled: true, labelText: "phone".tr),
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
                            _formKey.currentState!.fields['date']
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
                          if (_formKey.currentState?.validate() ?? false) {
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
    );
  }

  Future getImageFromGallery() async {
    final _img = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (_img == null) return;
    File? tempImg = File(_img.path);
    tempImg = await CropImage(imgFile: tempImg);
    setState(() {
      _userImg = tempImg;
    });

    final ref = FirebaseStorage.instance.ref().child(tempImg!.path);
    ref.putFile(tempImg!);
  }

  Future<File?> CropImage({required File imgFile}) async {
    CroppedFile? _croppedImg =
        await ImageCropper().cropImage(sourcePath: imgFile.path);
    if (_croppedImg == null) return null;
    return File(_croppedImg.path);
  }

  Stream readUsers() => FirebaseFirestore.instance
      .collection("user")
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => print("***************${doc.data().toString()}")));

  Future registerUser() async {
    await FirebaseFirestore.instance.collection("user").add({
      "name": _formKey.currentState!.fields['name']?.value,
      "phone": _formKey.currentState!.fields['phone']?.value,
      "birthday": _formKey.currentState!.fields['birthday']?.value,
      "sex": _formKey.currentState!.fields['sex']?.value,
      "bloodType": _formKey.currentState!.fields['bloodType']?.value,
      "rh": _formKey.currentState!.fields['rh']?.value,
    });
  }

  void _onChanged(dynamic val) => debugPrint(val.toString());
}
