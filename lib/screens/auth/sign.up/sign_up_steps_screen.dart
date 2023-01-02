import 'package:ai_kampo_app/controller/auth.controller.dart';
import 'package:ai_kampo_app/screens/auth/sign.up/step1_check_phone.dart';
import 'package:ai_kampo_app/screens/auth/sign.up/step2_user_info.dart';
import 'package:ai_kampo_app/screens/auth/sign.up/step3_done.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpStepsScreen extends StatelessWidget {
  SignUpStepsScreen({super.key});

  final _authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("signUp".tr),
        centerTitle: true,
      ),
      body: Obx(
        () => Stepper(
          currentStep: _authController.signUpCurrentStep.value,
          type: StepperType.horizontal,
          physics: ScrollPhysics(),
          steps: _buildSteps,
          controlsBuilder: (context, details) {
            return SizedBox(
              width: 10,
            );
          },
        ),
      ),
    );
  }

  List<Step> get _buildSteps {
    return <Step>[
      Step(
        isActive: _authController.signUpCurrentStep.value > 0,
        state: _authController.signUpCurrentStep.value > 0
            ? StepState.complete
            : StepState.disabled,
        title: Text("手機認證"),
        content: Step1CheckPhone(),
      ),
      Step(
        isActive: _authController.signUpCurrentStep.value > 1,
        state: _authController.signUpCurrentStep.value > 1
            ? StepState.complete
            : StepState.disabled,
        title: Text("基本資料"),
        content: Step2UserInfo(),
      ),
      Step(
        isActive: _authController.signUpCurrentStep.value == 2,
        state: _authController.signUpCurrentStep.value == 2
            ? StepState.complete
            : StepState.disabled,
        title: Text("完成"),
        content: Step3Done(),
      ),
    ];
  }
}
