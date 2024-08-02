import 'package:ai_kampo_app/api/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';

import 'package:ai_kampo_app/controller/register_account_controller.dart';
import 'package:ai_kampo_app/common/config.dart';
import 'package:ai_kampo_app/widgets/kampo_dialog.dart';
import 'package:ai_kampo_app/widgets/common/progress_loading.dart';

import '../../../models/user_model.dart';
import '../../../utils/utils.dart';


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
  final TextEditingController nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final birthday = Rx<DateTime?>(null);
  final gender = Rx<Gender?>(null);
  final bloodType = Rx<BloodType?>(null);
  final rhesus = Rx<Rhesus?>(null);

  @override
  void initState() {
    super.initState();
    subAccountController = widget.subAccountController;
  }

  Future<void> selectBirthDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: birthday.value?? DateTime(1990, 6, 30),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.bodyMedium!
                  .copyWith(color: Colors.black),
              ),
            ),
            textTheme: TextTheme(
              bodySmall: Theme.of(context).textTheme.bodyMedium!
                .copyWith(color: Colors.black),
              titleMedium: const TextStyle(color: Colors.black),
              bodyLarge: const TextStyle(color: Colors.black),
            ),
          ),
          child: child!,
        );
      },
      cancelText: "取消",
      confirmText: "確認",
      helpText: "選擇生日日期",
      locale: const Locale('zh'),
    );
    if (pickedDate != null) birthday.value = pickedDate;
  }

  Future<void> onConfirm() async {
    if (!(_formKey.currentState?.validate()?? false)) {
      return;
    }
    if (birthday.value == null) {
      if (mounted) KampoDialog.confirmToPop(context, '', "請填寫生日日期");
    }
    if (gender.value == null) {
      if (mounted) KampoDialog.confirmToPop(context, '', "請填寫性別");
    }
    if (bloodType.value == null) {
      if (mounted) KampoDialog.confirmToPop(context, '', "請填寫血型");
    }
    FocusManager.instance.primaryFocus?.unfocus();
    Future addTask = subAccountController.addNoPhoneAccount(
      username: nameController.text,
      birthday: birthday.value,
      gender: gender.value,
      rh: rhesus.value,
      bloodType: bloodType.value,
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
    TextStyle fieldTextStyle = const TextStyle(fontSize: 14);
    TextStyle fieldTitleTextStyle = const TextStyle(
      fontSize: 14, fontWeight: FontWeight.bold);
    ButtonStyle selectionButtonStyle = ButtonStyle(
      minimumSize: WidgetStateProperty.all(Size.zero),
      backgroundColor: WidgetStateProperty.all(Colors.transparent),
      shadowColor: WidgetStateProperty.all(Colors.transparent),
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return Colors.blue;
        }
        return Colors.grey[500];
      }),
      textStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains((WidgetState.disabled))) {
          return Theme.of(context).textTheme.bodyLarge!
              .copyWith(fontWeight: FontWeight.bold);
        }
        return Theme.of(context).textTheme.bodyLarge!;
      }),
    );

    Widget nameField = Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          Text("姓名：", style: fieldTitleTextStyle),
          const VerticalDivider(),
          Expanded(
            child: TextFormField(
              style: fieldTextStyle,
              controller: nameController,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(filled: true),
              validator: (value) {
                if (value == null || value == "") return "姓名不能為空";
                return null;
              },
            ),
          ),
        ],
      ),
    );

    Widget genderField = Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          Text("性別：", style: fieldTitleTextStyle),
          for (Gender type in Gender.values)
            Obx(() {
              return ElevatedButton(
                style: selectionButtonStyle,
                onPressed: gender.value == type? null: () => gender.value = type,
                child: Container(
                    padding: const EdgeInsets.all(2),
                    child: Text(genderToText[type]!)
                ),
              );
            }),
        ],
      ),
    );

    Widget bloodTypeField = Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          Text("血型：", style: fieldTitleTextStyle),
          Expanded(
            child: Wrap(
              children: [
                for (BloodType type in BloodType.values)
                  Obx(() {
                    return TextButton(
                      style: selectionButtonStyle,
                      onPressed: bloodType.value == type? null:
                          () => bloodType.value = type,
                      child: Text(bloodTypeToText[type]!),
                    );
                  }),
              ],
            ),
          )
        ],
      ),
    );

    Widget rhesusField = Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          Text("RH：", style: fieldTitleTextStyle),
          Expanded(
            child: Wrap(
              children: [
                for (Rhesus type in Rhesus.values)
                  Obx(() {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: TextButton(
                        style: selectionButtonStyle,
                        onPressed: rhesus.value == type? null:
                            () => rhesus.value = type,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          child: Text(rhesusToText[type]!),
                        ),
                      ),
                    );
                  }),
              ],
            ),
          )
        ],
      ),
    );

    ButtonStyle birthButtonStyle = ButtonStyle(
      backgroundColor: WidgetStateProperty.all(Colors.transparent),
      shadowColor: WidgetStateProperty.all(Colors.transparent),
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return Colors.grey[500];
        }
        return Colors.blue;
      }),
      textStyle: WidgetStateProperty.all(
        Theme.of(context).textTheme.bodyLarge!),
    );
    Widget birthField = Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Obx(() {
        return Row(
          children: [
            Text("生日：", style: fieldTitleTextStyle),
            const VerticalDivider(),
            Expanded(
              child: TextButton(
                style: birthButtonStyle,
                onPressed: selectBirthDate,
                child: SizedBox(
                  width: double.infinity,
                  child: Text(
                    birthday.value == null? "點擊選擇日期":
                      dateTimeToYearUntilDay(birthday.value!),
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );

    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: widget.onPrevious,
              child: const Text("上一步"),
            ),
            const Divider(color: Colors.transparent, height: 40),
            nameField,
            const Divider(height: 20),
            birthField,
            const Divider(height: 20),
            genderField,
            const Divider(height: 20),
            bloodTypeField,
            const Divider(height: 20),
            rhesusField,
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
