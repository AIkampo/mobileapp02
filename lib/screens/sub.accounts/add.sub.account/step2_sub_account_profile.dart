import 'package:ai_kampo_app/api/firebase_api.dart';
import 'package:ai_kampo_app/common/config.dart';
import 'package:ai_kampo_app/controller/add_sub_account_controller.dart';
import 'package:ai_kampo_app/models/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Step2SubAccountProfile extends StatelessWidget {
  Step2SubAccountProfile({super.key});

  final _subAccountFormkey = GlobalKey<FormBuilderState>();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: FormBuilder(
        key: _subAccountFormkey,
        initialValue: const {"username": "", "birthday": "", "sex": "", "bloodType": "", "rh": ""},
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FormBuilderTextField(
              name: 'username',
              validator: FormBuilderValidators.required(),
              decoration: InputDecoration(
                labelText: "姓名",
                filled: true,
              ),
            ),
            SizedBox(
              height: 20,
            ),
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
            SizedBox(
              height: 20,
            ),
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
              decoration: InputDecoration(labelText: '性別'),
            ),
            SizedBox(
              height: 20,
            ),
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
              ]
                  .map((type) => FormBuilderFieldOption(
                        value: type,
                        child: Text(UserProfile.bloodTypeList[int.parse(type)]),
                      ))
                  .toList(growable: false),
              controlAffinity: ControlAffinity.trailing,
            ),
            SizedBox(
              height: 20,
            ),
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
            SizedBox(
              height: 20,
            ),
            SizedBox(
              width: double.infinity,
              child: CupertinoButton.filled(
                onPressed: (() {
                  handleAddSubAccount();
                }),
                child: Text("新增"),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> handleAddSubAccount() async {
    if (!(_subAccountFormkey.currentState?.validate() ?? false)) {
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final userPhoneNumber = prefs.getString('phoneNumber')!;
    final controllerASA = Get.find<AddSubAccountController>();

    UserModel newSubAccount = UserModel(
        username: _subAccountFormkey.currentState!.fields['username']?.value,
        phoneNumber: controllerASA.phoneNumber.value,
        birthday: _subAccountFormkey.currentState!.fields['birthday']?.value,
        sex: _subAccountFormkey.currentState!.fields['sex']?.value,
        rh: _subAccountFormkey.currentState!.fields['rh']?.value,
        bloodType: _subAccountFormkey.currentState!.fields['bloodType']?.value,
        agreeServiceAgreement: false,
        isPremium: false,
        mainAccountPhoneNumber: userPhoneNumber,
        isMainAccount: false);

    FirebaseAPI.addUser(newSubAccount.toMap()).then((value) {
      controllerASA.currentStep.value = 2;
    });
  }
}
