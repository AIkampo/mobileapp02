import 'package:ai_kampo_app/api/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';

import 'package:ai_kampo_app/controller/register_account_controller.dart';
import 'package:ai_kampo_app/common/config.dart';
import 'package:ai_kampo_app/widgets/kampo_dialog.dart';

import '../../../widgets/common/progress_loading.dart';


class AddSubAccountStepsScreen extends StatefulWidget {
  const AddSubAccountStepsScreen({super.key});

  @override
  State<AddSubAccountStepsScreen> createState() => _AddSubAccountStepsScreenState();
}

class _AddSubAccountStepsScreenState extends State<AddSubAccountStepsScreen> {
  final currentStep = AddSubAccountSteps.chooseType.obs;
  final SubAccountController subAccountController =
    Get.arguments["subAccountController"];
  final typeChosen = Rx<FamilyMemberType?>(null);
  String? phoneNumber;
  String? accountUsername;
  DateTime? accountBirthday;
  String? accountSex;
  String? accountBloodType;
  String? accountRh;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("新增家庭成員"),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(
              "取消",
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
      body: Obx(
        () => Stepper(
          currentStep: currentStep.value.index,
          type: StepperType.horizontal,
          controlsBuilder: (context, details) => SizedBox.shrink(),
          steps: [
            Step(
              isActive: currentStep.value.index >= 0,
              state: currentStep.value.index > 0?
                StepState.complete: StepState.disabled,
              title: const Text("帳號種類"),
              content: Step1SelectType(onNext: (type) {
                typeChosen.value = type;
                currentStep.value = AddSubAccountSteps.fillInfo;
              }),
            ),
            Step(
              isActive: currentStep.value.index >= 1,
              state: currentStep.value.index > 1?
                StepState.complete: StepState.disabled,
              title: const Text("填寫資料"),
              content: typeChosen.value == FamilyMemberType.bindToPhone?
                Step2SubAccountPhone(
                  subAccountController: subAccountController,
                  onNext: () => currentStep.value = AddSubAccountSteps.done,
                  onPrevious: () {
                    currentStep.value = AddSubAccountSteps.chooseType;
                    typeChosen.value = null;
                  },
                ):
                Step2SubAccountProfile(
                  subAccountController: subAccountController,
                  onNext: () => currentStep.value = AddSubAccountSteps.done,
                  onPrevious: () {
                    currentStep.value = AddSubAccountSteps.chooseType;
                    typeChosen.value = null;
                  },
                ),
            ),
            Step(
              isActive: currentStep.value.index == 2,
              state: currentStep.value.index == 2?
                StepState.complete: StepState.disabled,
              title: const Text("完成"),
              content: Obx(() {
                if (typeChosen.value == null) {
                  return const Text(
                    "新增程序有誤！",
                    style: TextStyle(fontSize: 24, letterSpacing: 3),
                  );
                }
                else {
                  return Step3Done(type: typeChosen.value!);
                }
              }),
            ),
          ],
        ),
      ),
    );
  }
}


class Step1SelectType extends StatelessWidget {
  final void Function(FamilyMemberType type) onNext;
  const Step1SelectType({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("「電話號碼綁定」須提供已註冊帳號。可供其他使用者在其他裝置量測或查閱檢測報告（家庭成員須到「家庭管理」接受邀請）"),
        const Divider(color: Colors.transparent),
        const Text("「無電話號碼」提供給沒有電話號碼的使用者，僅能在家庭主帳號量測或查閱檢測報告"),
        const Divider(color: Colors.transparent, height: 50),
        CupertinoButton.filled(
          onPressed: () => onNext(FamilyMemberType.bindToPhone),
          child: const Text("電話號碼綁定"),
        ),
        const Divider(color: Colors.transparent, height: 30),
        CupertinoButton.filled(
          onPressed: () => onNext(FamilyMemberType.noPhone),
          child: const Text("無電話號碼"),
        ),
      ],
    );
  }
}


class Step2SubAccountPhone extends StatefulWidget {
  final void Function() onPrevious;
  final void Function() onNext;
  final SubAccountController subAccountController;
  const Step2SubAccountPhone({
    super.key,
    required this.onPrevious,
    required this.onNext,
    required this.subAccountController,
  });

  @override
  State<Step2SubAccountPhone> createState() => _Step2SubAccountPhoneState();
}


class _Step2SubAccountPhoneState extends State<Step2SubAccountPhone> {
  late SubAccountController subAccountController;
  final isLoading = false.obs;
  final _phoneNumber = "".obs;

  @override
  void initState() {
    super.initState();
    subAccountController = widget.subAccountController;
  }

  Future<void> onConfirm() async {
    FocusManager.instance.primaryFocus?.unfocus();
    Future addTask = subAccountController
      .addExistedSubAccount(_phoneNumber.value);
    await Get.dialog(ProgressLoadingPage(task: addTask));
    String? errMessage = await addTask;
    if (errMessage == null) {
      widget.onNext();
    }
    else {
      if (mounted) {
        KampoDialog.confirmToPop(context, "無法送出家庭邀請", errMessage);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (isLoading.value) {
        return const SizedBox(
          height: 120, child: Center(child: CircularProgressIndicator())
        );
      }
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
            onPressed: widget.onPrevious,
            child: const Text("上一步"),
          ),
          const Divider(color: Colors.transparent, height: 40),
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
          const Divider(color: Colors.transparent, height: 20),
          SizedBox(
            width: double.infinity,
            child: Obx(() {
              return CupertinoButton.filled(
                onPressed: _phoneNumber.value.length >= 7? onConfirm: null,
                child: Text("confirm".tr),
              );
            }),
          )
        ],
      );
    });
  }
}


class Step2SubAccountProfile extends StatefulWidget {
  final void Function() onPrevious;
  final void Function() onNext;
  final SubAccountController subAccountController;
  const Step2SubAccountProfile({
    super.key,
    required this.onPrevious,
    required this.onNext,
    required this.subAccountController,
  });

  @override
  State<Step2SubAccountProfile> createState() => _Step2SubAccountProfileState();
}

class _Step2SubAccountProfileState extends State<Step2SubAccountProfile> {
  late SubAccountController subAccountController;
  final _subAccountFormkey = GlobalKey<FormBuilderState>();
  final isLoading = false.obs;

  @override
  void initState() {
    super.initState();
    subAccountController = widget.subAccountController;
  }

  Future<void> onConfirm() async {
    if (!(_subAccountFormkey.currentState?.validate() ?? false)) {
      return;
    }
    FocusManager.instance.primaryFocus?.unfocus();
    Future addTask = subAccountController.addNoPhoneAccount(
      username: _subAccountFormkey.currentState!.fields["username"]?.value,
      birthday: _subAccountFormkey.currentState!.fields["birthday"]?.value,
      sex: _subAccountFormkey.currentState!.fields["sex"]?.value,
      rh: _subAccountFormkey.currentState!.fields["rh"]?.value,
      bloodType: _subAccountFormkey.currentState!.fields["bloodType"]?.value,
    );
    await Get.dialog(ProgressLoadingPage(task: addTask));
    String? errMessage = await addTask;
    if (errMessage == null) {
      widget.onNext();
    }
    else {
      if (mounted) {
        KampoDialog.confirmToPop(context, "無法送出家庭邀請", errMessage);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading.value) {
      return const Center(child: CircularProgressIndicator());
    }
    return SingleChildScrollView(
      child: FormBuilder(
        key: _subAccountFormkey,
        initialValue: const {"username": "", "birthday": "", "sex": "", "bloodType": "", "rh": ""},
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: widget.onPrevious,
              child: const Text("上一步"),
            ),
            const Divider(color: Colors.transparent, height: 40),
            FormBuilderTextField(
              name: 'username',
              validator: FormBuilderValidators.required(),
              decoration: const InputDecoration(
                labelText: "姓名",
                filled: true,
              ),
            ),
            const SizedBox(height: 20),
            FormBuilderDateTimePicker(
              name: 'birthday',
              initialEntryMode: DatePickerEntryMode.calendar,
              initialValue: DateTime.now(),
              inputType: InputType.date,
              decoration: InputDecoration(
                filled: true,
                labelText: 'birthday'.tr,
                suffixIcon: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    _subAccountFormkey.currentState!.fields['birthday']?.didChange(null);
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            FormBuilderRadioGroup<String>(
              name: "sex",
              validator: FormBuilderValidators.required(),
              initialValue: null,
              options: ['M', 'F']
                .map((sex) => FormBuilderFieldOption(
                  value: sex,
                  child: Text(sex == 'M' ? 'male'.tr : 'female'.tr),
                ))
                .toList(),
              decoration: const InputDecoration(labelText: '性別'),
            ),
            const SizedBox(height: 20),
            FormBuilderRadioGroup<String>(
              decoration: InputDecoration(
                labelText: 'bloodType'.tr,
              ),
              initialValue: null,
              name: 'bloodType',
              validator: FormBuilderValidators.required(),
              options: [
                  "0",
                  "1",
                  "2",
                  "3",
                  "4",
                ].map((type) => FormBuilderFieldOption(
                  value: type,
                  child: Text(UserProfile.bloodTypeList[int.parse(type)]),
                ))
                .toList(growable: false),
              controlAffinity: ControlAffinity.trailing,
            ),
            const SizedBox(height: 20),
            FormBuilderRadioGroup<String>(
              decoration: InputDecoration(
                labelText: 'rh'.tr,
              ),
              initialValue: null,
              name: 'rh',
              validator: FormBuilderValidators.required(),
              options: [
                  '0',
                  '1',
                  '2',
                ]
                .map((rh) => FormBuilderFieldOption(
                  value: rh,
                  child: Text(UserProfile.rhList[int.parse(rh)]),
                ))
                .toList(growable: false),
              controlAffinity: ControlAffinity.trailing,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: CupertinoButton.filled(
                onPressed: onConfirm,
                child: const Text("新增"),
              ),
            )
          ],
        ),
      ),
    );
  }
}


class Step3Done extends StatelessWidget {
  final FamilyMemberType type;
  const Step3Done({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height - 270,
          child: Center(
            child: Text(
              type == FamilyMemberType.bindToPhone?
                "已送出進入家庭邀請": "無電話號碼成員新增成功",
              style: const TextStyle(fontSize: 24, letterSpacing: 3),
            ),
          ),
        ),
        SizedBox(
          width: double.infinity,
          child: CupertinoButton.filled(
            child: Text("confirm".tr),
            onPressed: () => Get.back(),
          ),
        ),
      ],
    );
  }
}
