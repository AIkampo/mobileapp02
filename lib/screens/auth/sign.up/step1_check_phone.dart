import 'dart:async';

import 'package:ai_kampo_app/common/config.dart';
import 'package:ai_kampo_app/common/function.dart';
import 'package:ai_kampo_app/controller/auth.controller.dart';
import 'package:ai_kampo_app/utils/check.network.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class Step1CheckPhone extends StatelessWidget {
  Step1CheckPhone({super.key});

  final _authController = Get.find<AuthController>();
  final _phoneNumber = ''.obs;
  final _verificationCode = ''.obs;

  // 0 => 待使用者輸入手機號碼 （呈現輸入手機畫面）
  // 1 => 確認使用者輸入的手機號碼尚未註冊 （呈現輸入驗證碼畫面）
  final _checkStatus = 0.obs;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _verificationId = ''.obs;
  final _hasSentCode = false.obs;
  //可重新發送驗證碼的時間
  final int _verificationTimeout = 60;
  final _countDownVal = 60.obs;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        margin: EdgeInsets.all(20),
        child: _checkStatus.value == 0
            ? phoneNumberUI()
            : verificationCodeUI(context),
      ),
    );
  }

  Widget phoneNumberUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextField(
          keyboardType: TextInputType.phone,
          onChanged: (value) {
            _phoneNumber.value = value;
          },
          decoration: InputDecoration(
            filled: true,
            labelText: "phone".tr,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        SizedBox(
          width: double.infinity,
          child: CupertinoButton.filled(
            onPressed: _phoneNumber.value.length == 10
                ? () => getVerificationCode()
                : null,
            child: Text("confirm".tr),
          ),
        )
      ],
    );
  }

  Widget verificationCodeUI(BuildContext context) {
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
                _checkStatus.value = 0;
                _hasSentCode.value = false;
              },
            ),
          ],
        ),
        SizedBox(
          width: 20,
        ),
        _hasSentCode.value
            ? _countDownVal.value == 0
                ? TextButton(
                    onPressed: () {
                      getVerificationCode();
                    },
                    child: Text("重新發送"),
                  )
                : Text('${_countDownVal.value}秒後可重新傳送')
            : SizedBox(
                height: 20,
              ),
      ],
    );
  }

  Future<void> getVerificationCode() async {
    if (!await checkNetwork()) {
      return;
    }

    //檢查手機號碼是否已註冊
    // 尚未註冊 則進行驗證
    if (await checkPhoneNumber(_phoneNumber.value)) {
      Get.snackbar("驗證失敗", "手機號碼已註冊！");
    } else {
      await _auth.verifyPhoneNumber(
        phoneNumber: '+886${_phoneNumber.value}',
        verificationCompleted: ((PhoneAuthCredential credential) {
          print("** verificationCompleted");
        }),
        verificationFailed: ((FirebaseAuthException error) {
          print("** verificationFailed");
        }),
        codeSent: ((String verificationId, int? forceResendingToken) async {
          print('** codeSent');
          _checkStatus.value = 1;
          _verificationId.value = verificationId;
          _hasSentCode.value = true;
          doCountdown();
        }),
        codeAutoRetrievalTimeout: ((String verificationId) {
          print("** codeAutoRetrievalTimeout");
        }),
      );
    }
  }

  Future<void> checkVerificationCode() async {
    try {
      // Create a PhoneAuthCredential with the code
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: _verificationId.value,
          smsCode: _verificationCode.value);

      // Sign the user in (or link) with the credential
      await _auth.signInWithCredential(credential);
      _authController.signUpPhoneNumber.value = _phoneNumber.value;
      _authController.signUpCurrentStep.value = 1;
    } catch (e) {
      Get.snackbar("無法登入", "請檢查驗證碼");
      _authController.isLoading.value = false;
    }
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
}
