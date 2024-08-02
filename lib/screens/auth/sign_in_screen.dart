import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import 'package:ai_kampo_app/common/config.dart';
import 'package:ai_kampo_app/controller/account_controller.dart';
import 'package:ai_kampo_app/utils/check.network.dart';
import 'package:ai_kampo_app/widgets/kampo_dialog.dart';


class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _accountController = Get.find<AccountController>();

  final _phoneNumber = ''.obs;
  final _verificationCode = ''.obs;

  // 0 => 待使用者輸入手機號碼 （呈現輸入手機畫面）
  // 1 => 確認使用者輸入的手機號碼已註冊 （呈現輸入驗證碼畫面）
  final _signInStatus = 0.obs;

  final _isLoading = false.obs;

  @override
  initState() {
    super.initState();
    checkNetwork(context);
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
          Center(
            child: Container(
              width: 300,
              child: Obx(() {
                if (_isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                else {
                  return Column(
                    children: [
                      SizedBox(
                        height: 180,
                        child: _signInStatus.value == 0?
                          phoneNumberUI(): verificationCodeUI()
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: _isLoading.value? null:
                                () => Get.toNamed("/sign.up"),
                            child: Text("signUp".tr),
                          ),
                        ],
                      ),
                    ],
                  );
                }
              })
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
          actions: KampoConfig.localeList.map(
            (e) => CupertinoActionSheetAction(
              isDefaultAction: e['key'] == Get.locale.toString(),
              onPressed: () {
                Get.updateLocale(e['locale']);
                Get.back();
              },
              child: Text("${e['name']}".tr),
            ),
          ).toList(),
        );
      }),
    );
  }

  Future<void> getVerificationCode() async {
    _isLoading.value = true;
    if (!await checkNetwork(context)) {
      return;
    }

    String? errMessage = await _accountController.getVerificationCode(
      phoneNumber: _phoneNumber.value,
      onError: (errMessage) {
        if (mounted) KampoDialog.confirmToPop(context, '', errMessage);
      }
    );
    if (errMessage != null) {
      if (mounted) KampoDialog.confirmToPop(context, '', errMessage);
    }
    else {
      _signInStatus.value = 1;
    }
    _isLoading.value = false;
  }

  Future<void> checkVerificationCode() async {
    _isLoading.value = true;

    String? errMessage = await _accountController.checkVerificationCode(
      verificationCode: _verificationCode.value,
    );
    if (errMessage == null) {
      await _accountController.refreshAll();
      bool agreeServiceAgreement = _accountController.userData.value != null?
        _accountController.userData.value!.agreeServiceAgreement: false;
      Get.offAndToNamed(agreeServiceAgreement? "/main": "/service.agreement");
    }
    else {
      if (mounted) KampoDialog.confirmToPop(context, '', errMessage);
    }
    _isLoading.value = false;
  }

  Widget phoneNumberUI() {
    return Obx(() {
      return Column(
        children: [
          TextField(
            keyboardType: TextInputType.number,
            enabled: _isLoading.value == false,
            onChanged: (value) {
              _phoneNumber.value = value;
            },
            decoration: InputDecoration(
              filled: true,
              prefixIcon: const Icon(Icons.phone_android_sharp),
              border: const OutlineInputBorder(),
              labelText: "phone".tr,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: CupertinoButton.filled(
              onPressed: _phoneNumber.value.length >= 7?
                getVerificationCode: null,
              child: const Text('登入')
            ),
          ),
        ],
      );
    });
  }

  Widget verificationCodeUI() {
    return Column(
      children: [
        const Text('請輸入驗證碼', style: TextStyle(fontSize: 20)),
        const SizedBox(height: 12),
        PinCodeTextField(
          backgroundColor: Colors.transparent,
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
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 210,
              height: 50,
              child: ElevatedButton(
                onPressed: _verificationCode.value.length == 6?
                  checkVerificationCode: null,
                child: const Text('認證', style: TextStyle(fontSize: 22)),
              ),
            ),
            const SizedBox(width: 20),
            TextButton(
              child: const Text('取消', style: TextStyle(fontSize: 22)),
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
}
