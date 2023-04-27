import 'package:ai_kampo_app/controller/add_sub_account_controller.dart';
import 'package:ai_kampo_app/screens/sub.accounts/add.sub.account/step1_check_phonenumber.dart';
import 'package:ai_kampo_app/screens/sub.accounts/add.sub.account/step2_sub_account_profile.dart';
import 'package:ai_kampo_app/screens/sub.accounts/add.sub.account/step3_success.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddSubAccountStepsScreen extends StatelessWidget {
  AddSubAccountStepsScreen({super.key});

  final _controllerASA = Get.find<AddSubAccountController>();
  @override
  Widget build(BuildContext context) {
    _controllerASA.initData();

    return Scaffold(
      appBar: AppBar(
        title: Text("新增子帳號"),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          TextButton(
              onPressed: () => Get.offAllNamed("/sub.accounts"),
              child: Text(
                "取消",
                style: TextStyle(color: Colors.white),
              ))
        ],
      ),
      body: Obx(
        () => Stepper(
          currentStep: _controllerASA.currentStep.value,
          type: StepperType.horizontal,
          controlsBuilder: (context, details) => SizedBox.shrink(),
          steps: [
            Step(
                isActive: _controllerASA.currentStep.value > 0,
                state: _controllerASA.currentStep.value > 0
                    ? StepState.complete
                    : StepState.disabled,
                title: Text("手機驗證"),
                content: Step1CheckPhoneNumber()),
            Step(
                isActive: _controllerASA.currentStep.value >= 1,
                state: _controllerASA.currentStep.value > 1
                    ? StepState.complete
                    : StepState.disabled,
                title: Text("帳號資料"),
                content: Step2SubAccountProfile()),
            Step(
                isActive: _controllerASA.currentStep.value == 2,
                state: _controllerASA.currentStep.value == 2
                    ? StepState.complete
                    : StepState.disabled,
                title: Text("完成"),
                content: Step3Success()),
          ],
        ),
      ),
    );
  }
}
