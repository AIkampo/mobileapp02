import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:ai_kampo_app/screens/auth/sign.up/step1_check_phone.dart';
import 'package:ai_kampo_app/screens/auth/sign.up/step2_user_info.dart';
import 'package:ai_kampo_app/screens/auth/sign.up/step3_done.dart';
import 'package:ai_kampo_app/controller/register_account_controller.dart';


class SignUpStepsScreen extends StatefulWidget {
  const SignUpStepsScreen({super.key});

  @override
  State<SignUpStepsScreen> createState() => _SignUpStepsScreenState();
}

class _SignUpStepsScreenState extends State<SignUpStepsScreen> {
  final RegisterAccountController registerController =
    RegisterAccountController();

  @override
  void dispose() {
    if (registerController.currentStep.value != SignUpSteps.done) {
      registerController.logoutWhenUnregistered();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("signUp".tr),
        centerTitle: true,
      ),
      body: Obx(
        () => Stepper(
          currentStep: registerController.currentStep.value.index,
          type: StepperType.horizontal,
          physics: const ScrollPhysics(),
          steps: _buildSteps,
          controlsBuilder: (context, details) {
            return const SizedBox(width: 10);
          },
        ),
      ),
    );
  }

  List<Step> get _buildSteps {
    return <Step>[
      Step(
        isActive: registerController.currentStep.value.index > 0,
        state: registerController.currentStep.value.index > 0?
          StepState.complete: StepState.disabled,
        title: const Text("手機認證"),
        content: Step1CheckPhone(registerController: registerController),
      ),
      Step(
        isActive: registerController.currentStep.value.index > 1,
        state: registerController.currentStep.value.index > 1?
          StepState.complete:
          StepState.disabled,
        title: const Text("基本資料"),
        content: registerController.currentStep.value.index == 1?
          Step2UserInfo(registerController: registerController):
          const Text("Step2"),
      ),
      Step(
        isActive: registerController.currentStep.value.index == 2,
        state: registerController.currentStep.value.index == 2?
          StepState.complete:
          StepState.disabled,
        title: const Text("完成"),
        content: Step3Done(),
      ),
    ];
  }
}
