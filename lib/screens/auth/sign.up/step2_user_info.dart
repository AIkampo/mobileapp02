import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:ai_kampo_app/widgets/common/user_avatar.dart';
import 'package:ai_kampo_app/widgets/kampo_dialog.dart';
import 'package:ai_kampo_app/controller/register_account_controller.dart';
import 'package:ai_kampo_app/models/user_model.dart';
import 'package:ai_kampo_app/widgets/common/progress_loading.dart';
import 'package:ai_kampo_app/utils/utils.dart';


class Step2UserInfo extends StatefulWidget {
  final RegisterAccountController registerController;
  const Step2UserInfo({
    super.key,
    required this.registerController,
  });

  @override
  State<Step2UserInfo> createState() => _Step2UserInfoState();
}

class _Step2UserInfoState extends State<Step2UserInfo> {
  late RegisterAccountController registerController;
  final TextEditingController nameController = TextEditingController();
  final _signUpFormKey = GlobalKey<FormState>();
  final birthday = Rx<DateTime?>(null);
  final gender = Rx<Gender?>(null);
  final bloodType = Rx<BloodType?>(null);
  final rhesus = Rx<Rhesus?>(null);

  @override
  void initState() {
    super.initState();
    registerController = widget.registerController;
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

  Future registerUser() async {
    if (!(_signUpFormKey.currentState?.validate()?? false)) {
      return;
    }
    if (birthday.value == null) {
      if (mounted) KampoDialog.confirmToPop(context, '', "請填寫生日日期");
      return;
    }
    if (gender.value == null) {
      if (mounted) KampoDialog.confirmToPop(context, '', "請填寫性別");
      return;
    }
    if (bloodType.value == null) {
      if (mounted) KampoDialog.confirmToPop(context, '', "請填寫血型");
      return;
    }
    Future registerTask = registerController.registerAccount(
      username: nameController.text,
      birthday: birthday.value!,
      gender: gender.value!,
      rh: rhesus.value?? Rhesus.unknown,
      bloodType: bloodType.value!,
    );
    await Get.dialog(ProgressLoadingPage(task: registerTask));
    String? errMessage = await registerTask;
    if (errMessage != null) {
      if (mounted) KampoDialog.confirmToPop(context, '', errMessage);
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
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 12),
          child: Form(
              key: _signUpFormKey,
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  UserAvatar(phoneNumber: registerController.signUpPhone),
                  const SizedBox(
                    height: 38,
                  ),
                  nameField,
                  const Divider(),
                  birthField,
                  const Divider(),
                  genderField,
                  const Divider(),
                  bloodTypeField,
                  const Divider(),
                  rhesusField,
                  const Divider(),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    width: double.infinity,
                    child: CupertinoButton.filled(
                      onPressed: registerUser,
                      child: Text("confirm".tr),
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
