import 'dart:io';
import 'package:ai_kampo_app/api/firebase_api.dart';
import 'package:ai_kampo_app/widgets/common/user_avatar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  final _profileFormKey = GlobalKey<FormBuilderState>();
  final _userCollection = FirebaseFirestore.instance.collection("users");
  var _userDocRef = null;
  File? _userAvater = null;

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
                  initialValue: {
                    "username": "",
                    "birthday": "",
                    "sex": "",
                    "bloodType": "",
                    "rh": ""
                  },
                  child: Column(
                    children: [
                      CupertinoContextMenu(
                        child: Text("show menu"),
                        actions: [
                          CupertinoContextMenuAction(
                            child: Text("1"),
                            onPressed: () {
                              Get.snackbar("yes", "");
                            },
                          )
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      UserAvatar(
                        phoneNumber: '0963517217',
                      ),
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

  Future<void> getProfile() async {
    final _prefs = await SharedPreferences.getInstance();
    final userDocId = _prefs.getString('userDocId');

    setState(() {
      _userDocRef = _userCollection.doc(userDocId);
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

    // final storageRef = FirebaseStorage.instance.ref();
    // final pathReference = storageRef.child('userAvatar/0963517217.jpg');
    // final gsRef = FirebaseStorage.instance
    //     .refFromURL('gs://aikampo-app.appspot.com/userAvatar/0963517217.jpg');
    // print('*******************');
    // print(await gsRef.getDownloadURL());
  }

  Future updateProfile() async {
    final phoneNumber = "";
    final docId = "";
    var userAvatarRef = "";

    //使用者有上傳照片=> _userAvater.value != null 才需執行
    if (_userAvater != null) {
      userAvatarRef = "userAvatar/$phoneNumber.jpg";
      final ref = FirebaseStorage.instance.ref(userAvatarRef).child("");
      ref.putFile(_userAvater!);
    }

    await _userDocRef.update({
      "userAvatar": userAvatarRef,
      "username": _profileFormKey.currentState!.fields['username']?.value,
      "phoneNumber": phoneNumber,
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
