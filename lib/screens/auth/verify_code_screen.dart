import 'dart:async';
import 'package:ai_kampo_app/common/config.dart';
import 'package:ai_kampo_app/controller/auth.controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class VerifyCodeScreen extends StatelessWidget {
  VerifyCodeScreen({super.key});

  final _authController = Get.find<AuthController>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _verificationId = '';
  //可重新發送驗證碼的時間
  final int _verificationTimeout = 60;
  final _phoneNumber = Get.arguments['phoneNumber'];
  final _countDownVal = 60.obs;
  //判斷 系統是否已寄出驗證碼
  final _haveSent = false.obs;

  //使用者輸入之驗證碼
  final _verificationCode = ''.obs;

  @override
  Widget build(BuildContext context) {
    getVerificationCode();

    return Scaffold(
      appBar: AppBar(
        title: Text("驗證手機號碼"),
        centerTitle: true,
      ),
      body: Obx(
        () => Center(
          child: Container(
            width: 300,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
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
                  height: 6,
                ),
                SizedBox(
                  width: double.infinity,
                  child: CupertinoButton.filled(
                    onPressed:
                        _verificationCode.value.length == 6 ? () => checkVerificationCode() : null,
                    child: Text("認證"),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                _haveSent.value
                    ? _countDownVal.value == 0
                        ? TextButton(
                            onPressed: () {
                              getVerificationCode();
                            },
                            child: Text("重新發送"),
                          )
                        : Text('${_countDownVal.value}秒後重新傳送')
                    : SizedBox(
                        height: 20,
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

//到數可重新發送的時間
  Future<void> doCountdown() async {
    //先設定值 才開始到數
    _countDownVal.value = _verificationTimeout;

    final countdownTimer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (_countDownVal > 0) {
          _countDownVal.value = _countDownVal.value - 1;
        } else {
          timer.cancel();
        }
      },
    );
  }

  Future<void> getVerificationCode() async {
    await _auth.verifyPhoneNumber(
      phoneNumber: '+886 $_phoneNumber',
      timeout: Duration(seconds: _verificationTimeout),
      verificationCompleted: ((PhoneAuthCredential credential) {
        print("** verificationCompleted");
      }),
      verificationFailed: ((FirebaseAuthException error) {
        Get.back();
        Get.snackbar("驗證失敗", "請確認手機號碼");
      }),
      codeSent: ((String verificationId, int? forceResendingToken) async {
        _haveSent.value = true;
        doCountdown();
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
          verificationId: _verificationId, smsCode: _verificationCode.value);

      // Sign the user in (or link) with the credential
      await _auth.signInWithCredential(credential);

      // authController.isLoading.value = false;
      // Get.offAndToNamed("/main");
      _authController.isAvailablePhoneNumber.value = true;
      Get.toNamed('/sign.up', arguments: {'phoneNumber': _phoneNumber});
    } catch (e) {
      Get.snackbar("驗證失敗", "請檢查驗證碼");
      // authController.isLoading.value = false;
    }
  }
}
