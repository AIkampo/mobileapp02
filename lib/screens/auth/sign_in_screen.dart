import 'package:ai_kampo_app/common/config.dart';
import 'package:ai_kampo_app/controller/auth.controller.dart';
import 'package:ai_kampo_app/screens/auth/forgot_password_screen.dart';
import 'package:ai_kampo_app/utils/EncryptPassword.dart';
import 'package:ai_kampo_app/utils/check.network.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final authController = Get.find<AuthController>();

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
                  child: Column(
                    children: [
                      TextField(
                        keyboardType: TextInputType.number,
                        enabled: !authController.isLoading.value,
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.phone_android_sharp),
                            suffixIcon: TextButton(
                              onPressed: () {
                                getVerificationCode("0970483255");
                              },
                              child: Text("取得驗證碼"),
                            ),
                            border: OutlineInputBorder(),
                            labelText: "phone".tr),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextField(
                        enabled: !authController.isLoading.value,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.password),
                            suffixIcon: TextButton.icon(
                              onPressed: null,
                              icon: Icon(Icons.login),
                              label: Text("signIn".tr),
                            ),
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
                            onPressed: () {
                              authController.isLoading.value
                                  ? null
                                  : Get.toNamed("/sign.up");
                            },
                            child: Text("signUp".tr),
                          ),
                        ],
                      ),
                    ],
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

  Future<void> getVerificationCode(String phoneNumber) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: "+886 0963517217",
      verificationCompleted: ((PhoneAuthCredential credential) {
        print("** verificationCompleted");
      }),
      verificationFailed: ((FirebaseAuthException error) {
        print("** verificationFailed");
      }),
      codeSent: ((String verificationId, int? forceResendingToken) {
        print("** codeSent");
      }),
      codeAutoRetrievalTimeout: ((String verificationId) {
        print("** codeAutoRetrievalTimeout");
      }),
    );
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
