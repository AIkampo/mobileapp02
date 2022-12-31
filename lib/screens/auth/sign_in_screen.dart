import 'package:ai_kampo_app/common/config.dart';
import 'package:ai_kampo_app/controller/auth.controller.dart';
import 'package:ai_kampo_app/screens/auth/forgot_password_screen.dart';
import 'package:ai_kampo_app/utils/EncryptPassword.dart';
import 'package:ai_kampo_app/utils/check.network.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final authController = Get.find<AuthController>();
  final _signInFormKey = GlobalKey<FormBuilderState>();

  FirebaseAuth auth = FirebaseAuth.instance;
  String _verificationId = '';
  String _verificationCode = '';
  var _canGetVerificationCode = false.obs;

  @override
  initState() {
    super.initState();
    checkNetwork();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            actions: [
              Row(
                children: [
                  TextButton.icon(
                      onPressed: () => _showLanguageActionSheet(context),
                      icon: Icon(CupertinoIcons.globe),
                      label: Text(
                          "${KampoConfig.localeList.where((e) => e['key'] == Get.locale.toString()).toList()[0]['name']}"
                              .tr)),
                  SizedBox(
                    width: 10,
                  ),
                ],
              )
            ],
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset("assets/images/logo.png"),
                SizedBox(
                  height: 70,
                ),
                Container(
                  width: 300,
                  child: FormBuilder(
                    key: _signInFormKey,
                    initialValue: {
                      'phoneNumber': '',
                      'verificationCode': '',
                    },
                    child: Column(
                      children: [
                        FormBuilderTextField(
                          name: 'phoneNumber',
                          keyboardType: TextInputType.number,
                          enabled: !authController.isLoading.value,
                          onChanged: (value) {
                            _canGetVerificationCode.value = _signInFormKey
                                    .currentState!
                                    .fields["phoneNumber"]
                                    ?.value
                                    .length >=
                                9;
                          },
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.phone_android_sharp),
                              suffixIcon: TextButton(
                                onPressed: _canGetVerificationCode.value
                                    ? () => getVerificationCode()
                                    : null,
                                child: Text("取得驗證碼"),
                              ),
                              border: OutlineInputBorder(),
                              labelText: "phone".tr),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        FormBuilderTextField(
                          name: 'verificationCode',
                          enabled: !authController.isLoading.value &&
                              _canGetVerificationCode.value,
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            if (value!.length == 6) {
                              checkVerificationCode();
                              authController.isLoading.value = true;
                            }
                          },
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.password),
                              // suffixIcon: TextButton.icon(
                              //   onPressed: () => checkVerificationCode(),
                              //   icon: Icon(Icons.login),
                              //   label: Text("signIn".tr),
                              // ),
                              border: OutlineInputBorder(),
                              labelText: "驗證碼"),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              onPressed: authController.isLoading.value
                                  ? null
                                  : () => Get.toNamed("/sign.up"),
                              child: Text("signUp".tr),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  void _showLanguageActionSheet(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: ((context) {
        return CupertinoActionSheet(
          title: Text("selectLanguage".tr),
          actions: KampoConfig.localeList
              .map(
                (e) => CupertinoActionSheetAction(
                  isDefaultAction: e['key'] == Get.locale.toString(),
                  onPressed: () {
                    Get.updateLocale(e['locale']);
                    Get.back();
                  },
                  child: Text("${e['name']}".tr),
                ),
              )
              .toList(),
        );
      }),
    );
  }

  Future<void> getVerificationCode() async {
    await auth.verifyPhoneNumber(
      phoneNumber:
          '+886${_signInFormKey.currentState!.fields["phoneNumber"]?.value}',
      verificationCompleted: ((PhoneAuthCredential credential) {
        print("** verificationCompleted");
      }),
      verificationFailed: ((FirebaseAuthException error) {
        print("** verificationFailed");
      }),
      codeSent: ((String verificationId, int? forceResendingToken) async {
        print('** codeSent');

        _verificationId = verificationId;
      }),
      codeAutoRetrievalTimeout: ((String verificationId) {
        print("** codeAutoRetrievalTimeout");
      }),
    );
  }

  Future<void> checkVerificationCode() async {
    try {
      // Create a PhoneAuthCredential with the code
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: _verificationId,
          smsCode:
              _signInFormKey.currentState!.fields["verificationCode"]?.value);

      // Sign the user in (or link) with the credential
      await auth.signInWithCredential(credential);
      authController.isLoading.value = false;
      Get.offAndToNamed("/main");
    } catch (e) {
      Get.snackbar("無法登入", "請檢查驗證碼");
      authController.isLoading.value = false;
    }
  }

  Future<void> doSignIn() async {
    // print("********** result : ${result.docs.length}");
    // result.docs.forEach((e) => print("***data:${e.data()}"));
    // final authController = Get.find<AuthController>();
    authController.isLoading.value = true;

    if (!await checkNetwork()) {
      return;
    }

    try {
      final password = await encryptPassword("88");
      final checkResult = await FirebaseFirestore.instance
          .collection("user")
          .where("phone", isEqualTo: "0912345678")
          .where("password", isEqualTo: password)
          .get();
      if (checkResult.docs.length != 0) {
        Get.offAndToNamed("/main");
      } else {
        Get.snackbar("無法登入", "手機號碼或密碼不正確！");
      }
      authController.isLoading.value = false;
    } catch (e) {
      print("*** Failed Sign in:$e");
    }
  }
}
