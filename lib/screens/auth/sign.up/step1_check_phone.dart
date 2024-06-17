import 'dart:async';
import 'package:ai_kampo_app/controller/register_account_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import 'package:ai_kampo_app/common/config.dart';
import 'package:ai_kampo_app/utils/check.network.dart';
import 'package:ai_kampo_app/widgets/kampo_dialog.dart';


enum Step1Stage{
  inputPhone, // 待使用者輸入手機號碼 （呈現輸入手機畫面）
  codeVerification, // 確認使用者輸入的手機號碼尚未註冊 （呈現輸入驗證碼畫面）
}

class PhoneNumberInput extends StatefulWidget {
  final RegisterAccountController registerController;
  final Function() onPhoneLock;
  const PhoneNumberInput({
    super.key,
    required this.registerController,
    required this.onPhoneLock,
  });

  @override
  State<PhoneNumberInput> createState() => _PhoneNumberInputState();
}

class _PhoneNumberInputState extends State<PhoneNumberInput> {
  late RegisterAccountController registerController;
  final _lockPhone = false.obs;
  final _phoneNumber = ''.obs;

  @override
  void initState() {
    super.initState();
    registerController = widget.registerController;
  }

  Future<void> lockPhone() async {
    registerController.setPhoneNumber(_phoneNumber.value);
    // check phone exist
    bool exist = await registerController.checkPhone();
    if (exist) {
      if (mounted) KampoDialog.confirmToPop(context, '', '手機號碼已註冊！');
    }
    else {
      _lockPhone.value = true;
      widget.onPhoneLock();
    }
  }

  @override
  Widget build(BuildContext context) {
    return _lockPhone.value?
      Container(height: 120, child: Center(child: CircularProgressIndicator())):
      Column(
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
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: Obx(() {
              return CupertinoButton.filled(
                onPressed: _phoneNumber.value.length >= 7? lockPhone: null,
                child: Text("confirm".tr),
              );
            }),
          )
        ],
      );
  }
}


class StepCheckVerification extends StatefulWidget {
  final RegisterAccountController registerController;
  final Function() onCancel;
  const StepCheckVerification({
    super.key,
    required this.registerController,
    required this.onCancel,
  });

  @override
  State<StepCheckVerification> createState() => _StepCheckVerificationState();
}

class _StepCheckVerificationState extends State<StepCheckVerification> {
  late RegisterAccountController registerController;
  final _verificationCode = ''.obs;
  final isLoading = true.obs;
  final int _verificationTimeout = 60;
  final _countDownVal = 60.obs;
  Timer? _countDownTimer;

  @override
  void initState() {
    super.initState();
    registerController = widget.registerController;
    getVerificationCode();
  }

  Future<void> getVerificationCode() async {
    isLoading.value = true;
    if (!await checkNetwork(context)) {
      isLoading.value = false;
      return;
    }

    await registerController.getVerificationCode(
      onError: (errMessage) {
        if (mounted) KampoDialog.confirmToPop(context, '', errMessage);
      }
    );
    doCountdown();
    isLoading.value = false;
  }

  Future<void> checkVerificationCode() async {
    isLoading.value = true;
    String? errMessage = await registerController.checkVerificationCode(
      verificationCode: _verificationCode.value);
    if (errMessage != null) {
      if (mounted) KampoDialog.confirmToPop(context, '', errMessage);
      isLoading.value = false;
      return;
    }
    isLoading.value = false;
  }

  //到數可重新發送的時間
  Future<void> doCountdown() async {
    //先設定值 才開始到數
    _countDownVal.value = _verificationTimeout;

    if (_countDownTimer != null) _countDownTimer!.cancel();
    _countDownTimer = Timer.periodic(
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

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      return Column(
        children: [
          const Text('請輸入驗證碼', style: TextStyle(fontSize: 28)),
          const SizedBox(height: 20),
          PinCodeTextField(
            cursorColor: Colors.black,
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
          const SizedBox(height: 22),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _verificationCode.value.length == 6?
                    checkVerificationCode: null,
                  child: const Text('認證', style: TextStyle(fontSize: 22)),
                ),
              ),
              const VerticalDivider(width: 20),
              TextButton(
                onPressed: widget.onCancel,
                child: const Text('取消', style: TextStyle(fontSize: 22)),
              ),
            ],
          ),
          const SizedBox(height: 38),
          if (_countDownVal.value <= 0)
            TextButton(
              onPressed: () {
                getVerificationCode();
              },
              child: const Text(
                "重新發送",
                style: TextStyle(fontSize: 22, color: Colors.red),
              ),
            )
          else
            Text(
              '${_countDownVal.value}秒後可重新傳送',
              style: const TextStyle(fontSize: 18),
            ),
        ],
      );
    });
  }
}


class Step1CheckPhone extends StatefulWidget {
  final RegisterAccountController registerController;
  const Step1CheckPhone({
    super.key,
    required this.registerController
  });

  @override
  State<Step1CheckPhone> createState() => _Step1CheckPhoneState();
}

class _Step1CheckPhoneState extends State<Step1CheckPhone> {
  late RegisterAccountController registerController;
  final stage = Step1Stage.inputPhone.obs;

  @override
  void initState() {
    super.initState();
    registerController = widget.registerController;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        margin: const EdgeInsets.all(20),
        child: stage.value == Step1Stage.inputPhone?
          PhoneNumberInput(
            registerController: registerController,
            onPhoneLock: () => stage.value = Step1Stage.codeVerification,
          ):
          StepCheckVerification(
            registerController: registerController,
            onCancel: () => stage.value = Step1Stage.inputPhone,
          ),
      ),
    );
  }
}
