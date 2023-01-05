import 'package:ai_kampo_app/common/config.dart';
import 'package:ai_kampo_app/controller/auth.controller.dart';
import 'package:ai_kampo_app/utils/check.network.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _authController = Get.find<AuthController>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _usersCollection = FirebaseFirestore.instance.collection("users");

  String _verificationId = '';
  final _phoneNumber = ''.obs;
  final _verificationCode = ''.obs;
  final _userDocId = ''.obs;
  final _isFirstTimeSignIn = false.obs;

  // 0 => 待使用者輸入手機號碼 （呈現輸入手機畫面）
  // 1 => 確認使用者輸入的手機號碼已註冊 （呈現輸入驗證碼畫面）
  final _signInStatus = 0.obs;

  @override
  initState() {
    super.initState();
    checkNetwork();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset("assets/images/logo.png"),
          SizedBox(
            height: 70,
          ),
          Obx(
            () => Center(
              child: Container(
                width: 300,
                child: Column(
                  children: [
                    Container(
                        height: 180,
                        child: _signInStatus == 0
                            ? phoneNumberUI()
                            : verificationCodeUI()),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: _authController.isLoading.value
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
          ),
        ],
      ),
    );
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
    if (!await checkNetwork()) {
      return;
    }

    //檢查手機號碼是否已註冊
    // 已註冊 則進行驗證
    if (await checkPhoneNumber(_phoneNumber.value)) {
      doSignIn();
      // await _auth.verifyPhoneNumber(
      //   phoneNumber: '+886${_phoneNumber.value}',
      //   verificationCompleted: ((PhoneAuthCredential credential) {
      //     print("** verificationCompleted");
      //   }),
      //   verificationFailed: ((FirebaseAuthException error) {
      //     print("** verificationFailed  error: $error");
      //   }),
      //   codeSent: ((String verificationId, int? forceResendingToken) async {
      //     print('** codeSent');
      // _signInStatus.value = 1;
      // _verificationId = verificationId;
      // }),
      // codeAutoRetrievalTimeout: ((String verificationId) {
      //   print("** codeAutoRetrievalTimeout");
      // }),
      // );
    } else {
      Get.snackbar("登入失敗", "手機號碼尚未註冊！");
    }
  }

  Future<void> checkVerificationCode() async {
    try {
      // Create a PhoneAuthCredential with the code
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: _verificationId, smsCode: _verificationCode.value);

      // Sign the user in (or link) with the credential
      await _auth
          .signInWithCredential(credential)
          .then((value) => doSignIn())
          .catchError((error) => Get.snackbar("無法登入", "驗證失敗"));
    } catch (e) {
      Get.snackbar("無法登入", "請檢查驗證碼");
      _authController.isLoading.value = false;
    }
  }

  Widget phoneNumberUI() {
    return Column(
      children: [
        TextField(
          keyboardType: TextInputType.number,
          enabled: !_authController.isLoading.value,
          onChanged: (value) {
            _phoneNumber.value = value;
          },
          decoration: InputDecoration(
              prefixIcon: Icon(Icons.phone_android_sharp),
              border: OutlineInputBorder(),
              labelText: "phone".tr),
        ),
        SizedBox(
          height: 16,
        ),
        SizedBox(
          width: double.infinity,
          child: CupertinoButton.filled(
              child: Text('登入'),
              onPressed: _phoneNumber.value.length == 10
                  ? () => getVerificationCode()
                  : null),
        ),
      ],
    );
  }

  Widget verificationCodeUI() {
    return Column(
      children: [
        Text(
          '請輸入驗證碼',
          style: TextStyle(fontSize: 20),
        ),
        SizedBox(
          height: 12,
        ),
        PinCodeTextField(
          keyboardType: TextInputType.number,
          appContext: context,
          length: 6,
          onChanged: (value) {
            _verificationCode.value = value;
          },
          pinTheme: PinTheme(
            activeColor: KampoColors.primary,
            inactiveColor: Colors.grey,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: ElevatedButton(
                  child: Text('認證'),
                  onPressed: _verificationCode.value.length == 6
                      ? () => checkVerificationCode()
                      : null),
            ),
            SizedBox(
              width: 8,
            ),
            TextButton(
              child: Text('取消'),
              onPressed: () {
                _verificationCode.value = "";
                _signInStatus.value = 0;
              },
            ),
          ],
        )
      ],
    );
  }

  Future<bool> checkPhoneNumber(String phoneNumber) async {
    var res = await _usersCollection
        .where('phoneNumber', isEqualTo: phoneNumber)
        .get();

    if (res.docs.length == 1) {
      _userDocId.value = res.docs[0].id;
      _isFirstTimeSignIn.value = res.docs[0]['lastSignInDatetime'] == null;
    }

    return res.docs.length == 1;
  }

  Future<void> doSignIn() async {
    _authController.isLoading.value = false;

    //Update SignIn datetime.
    await _usersCollection
        .doc(_userDocId.value)
        .update({'lastSignInDatetime': DateTime.now()})
        .then((value) => print('***** last SignIn Datetime updated'))
        .catchError((error) => print("Failed to update lastSignInDatetime"));

    //Store 'phoneNumber' & 'userDocId' in App
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('phoneNumber', _phoneNumber.value);
    await prefs.setString('userDocId', _userDocId.value);

    Get.offAndToNamed(
        _isFirstTimeSignIn.value ? "/service.agreement" : "/main");
  }
}
