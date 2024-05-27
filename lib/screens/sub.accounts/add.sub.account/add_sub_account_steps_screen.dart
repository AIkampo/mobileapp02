// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import 'package:ai_kampo_app/screens/sub.accounts/add.sub.account/step1_check_phonenumber.dart';
// import 'package:ai_kampo_app/screens/sub.accounts/add.sub.account/step2_sub_account_profile.dart';
// import 'package:ai_kampo_app/screens/sub.accounts/add.sub.account/step3_success.dart';
// import 'package:ai_kampo_app/controller/register_account_controller.dart';
//
//
// class AddSubAccountStepsScreen extends StatelessWidget {
//   AddSubAccountStepsScreen({super.key});
//
//   final SubAccountController subAccountController = SubAccountController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("新增家庭成員"),
//         centerTitle: true,
//         automaticallyImplyLeading: false,
//         actions: [
//           TextButton(
//               onPressed: () => Get.offAllNamed("/sub.accounts"),
//               child: Text(
//                 "取消",
//                 style: TextStyle(color: Colors.white),
//               ))
//         ],
//       ),
//       body: Obx(
//         () => Stepper(
//           currentStep: subAccountController.currentStep.value.index,
//           type: StepperType.horizontal,
//           controlsBuilder: (context, details) => SizedBox.shrink(),
//           steps: [
//             Step(
//               isActive: subAccountController.currentStep.value.index > 0,
//               state: subAccountController.currentStep.value.index > 0?
//                 StepState.complete: StepState.disabled,
//               title: const Text("手機驗證"),
//               content: Step1CheckPhoneNumber(
//                 subAccountController: subAccountController
//               )
//             ),
//             Step(
//               isActive: subAccountController.currentStep.value.index >= 1,
//               state: subAccountController.currentStep.value.index > 1?
//                 StepState.complete: StepState.disabled,
//               title: const Text("帳號資料"),
//               content: Step2SubAccountProfile(
//                 subAccountController: subAccountController
//               ),
//             ),
//             Step(
//               isActive: subAccountController.currentStep.value.index == 2,
//               state: subAccountController.currentStep.value.index == 2?
//                 StepState.complete: StepState.disabled,
//               title: const Text("完成"),
//               content: const Step3Success(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
