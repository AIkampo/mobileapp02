// import 'package:ai_kampo_app/api/user.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_form_builder/flutter_form_builder.dart';
// import 'package:form_builder_validators/form_builder_validators.dart';
// import 'package:get/get.dart';
//
// import 'package:ai_kampo_app/common/config.dart';
// import 'package:ai_kampo_app/controller/register_account_controller.dart';
// import 'package:ai_kampo_app/widgets/kampo_dialog.dart';
//
//
// class Step2SubAccountProfile extends StatefulWidget {
//   final SubAccountController subAccountController;
//   const Step2SubAccountProfile({
//     super.key,
//     required this.subAccountController,
//   });
//
//   @override
//   State<Step2SubAccountProfile> createState() => _Step2SubAccountProfileState();
// }
//
// class _Step2SubAccountProfileState extends State<Step2SubAccountProfile> {
//   late SubAccountController subAccountController;
//   final _subAccountFormkey = GlobalKey<FormBuilderState>();
//   final isLoading = false.obs;
//
//   @override
//   void initState() {
//     super.initState();
//     subAccountController = widget.subAccountController;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (isLoading.value) {
//       return const Center(child: CircularProgressIndicator());
//     }
//     return SingleChildScrollView(
//       child: FormBuilder(
//         key: _subAccountFormkey,
//         initialValue: const {"username": "", "birthday": "", "sex": "", "bloodType": "", "rh": ""},
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             FormBuilderTextField(
//               name: 'username',
//               validator: FormBuilderValidators.required(),
//               decoration: const InputDecoration(
//                 labelText: "姓名",
//                 filled: true,
//               ),
//             ),
//             const SizedBox(height: 20),
//             FormBuilderDateTimePicker(
//               name: 'birthday',
//               initialEntryMode: DatePickerEntryMode.calendar,
//               initialValue: DateTime.now(),
//               inputType: InputType.date,
//               decoration: InputDecoration(
//                 filled: true,
//                 labelText: 'birthday'.tr,
//                 suffixIcon: IconButton(
//                   icon: const Icon(Icons.close),
//                   onPressed: () {
//                     _subAccountFormkey.currentState!.fields['birthday']?.didChange(null);
//                   },
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//             FormBuilderRadioGroup<String>(
//               name: "sex",
//               validator: FormBuilderValidators.required(),
//               initialValue: null,
//               options: ['M', 'F']
//                   .map((sex) => FormBuilderFieldOption(
//                         value: sex,
//                         child: Text(sex == 'M' ? 'male'.tr : 'female'.tr),
//                       ))
//                   .toList(),
//               decoration: const InputDecoration(labelText: '性別'),
//             ),
//             const SizedBox(height: 20),
//             FormBuilderRadioGroup<String>(
//               decoration: InputDecoration(
//                 labelText: 'bloodType'.tr,
//               ),
//               initialValue: null,
//               name: 'bloodType',
//               validator: FormBuilderValidators.required(),
//               options: [
//                   "0",
//                   "1",
//                   "2",
//                   "3",
//                   "4",
//                 ].map((type) => FormBuilderFieldOption(
//                   value: type,
//                   child: Text(UserProfile.bloodTypeList[int.parse(type)]),
//                 ))
//                 .toList(growable: false),
//               controlAffinity: ControlAffinity.trailing,
//             ),
//             const SizedBox(height: 20),
//             FormBuilderRadioGroup<String>(
//               decoration: InputDecoration(
//                 labelText: 'rh'.tr,
//               ),
//               initialValue: null,
//               name: 'rh',
//               validator: FormBuilderValidators.required(),
//               options: [
//                   '0',
//                   '1',
//                   '2',
//                 ]
//                 .map((rh) => FormBuilderFieldOption(
//                   value: rh,
//                   child: Text(UserProfile.rhList[int.parse(rh)]),
//                 ))
//                 .toList(growable: false),
//               controlAffinity: ControlAffinity.trailing,
//             ),
//             const SizedBox(height: 20),
//             SizedBox(
//               width: double.infinity,
//               child: CupertinoButton.filled(
//                 onPressed: (() {
//                   handleAddSubAccount();
//                 }),
//                 child: const Text("新增"),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
//
//   Future<void> handleAddSubAccount() async {
//     if (!(_subAccountFormkey.currentState?.validate() ?? false)) {
//       return;
//     }
//     isLoading.value = true;
//     String? errMessage;
//     if (subAccountController.targetStatus == AccountStatus.unregistered) {
//       errMessage = await subAccountController.addNewSubAccount(
//         username: _subAccountFormkey.currentState!.fields["username"]?.value,
//         birthday: _subAccountFormkey.currentState!.fields["birthday"]?.value,
//         sex: _subAccountFormkey.currentState!.fields["sex"]?.value,
//         rh: _subAccountFormkey.currentState!.fields["rh"]?.value,
//         bloodType: _subAccountFormkey.currentState!.fields["bloodType"]?.value,
//       );
//     }
//     else {
//       errMessage = await subAccountController.addExistedSubAccount();
//     }
//     if (errMessage != null) {
//       if (mounted) KampoDialog.confirmToPop(context, '', errMessage);
//     }
//     isLoading.value = false;
//   }
// }
