import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("我的檔案")),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: 320,
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                CircleAvatar(
                  child: Icon(
                    Icons.person_pin_outlined,
                  ),
                  radius: 50,
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  decoration: InputDecoration(
                    filled: true,
                    label: Text("名字"),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  decoration: InputDecoration(
                    filled: true,
                    label: Text("電話"),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                FormBuilderDateTimePicker(
                  name: 'date',
                  initialEntryMode: DatePickerEntryMode.calendar,
                  initialValue: DateTime.now(),
                  inputType: InputType.date,
                  decoration: InputDecoration(
                    filled: true,
                    labelText: '生日',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        _formKey.currentState!.fields['date']?.didChange(null);
                      },
                    ),
                  ),

                  // locale: const Locale.fromSubtags(languageCode: 'fr'),
                ),
                SizedBox(
                  height: 20,
                ),
                FormBuilderRadioGroup<String>(
                  decoration: InputDecoration(
                    labelText: '性別',
                  ),
                  initialValue: null,
                  name: 'caseSex',
                  options: ['男', '女']
                      .map((sex) => FormBuilderFieldOption(
                            value: sex,
                            child: Text(sex),
                          ))
                      .toList(growable: false),
                  controlAffinity: ControlAffinity.trailing,
                ),
                FormBuilderRadioGroup<String>(
                  decoration: InputDecoration(
                    labelText: '血型',
                  ),
                  initialValue: null,
                  name: 'caseSex',
                  options: [
                    'A',
                    'B',
                    'O',
                    'AB',
                  ]
                      .map((sex) => FormBuilderFieldOption(
                            value: sex,
                            child: Text(sex),
                          ))
                      .toList(growable: false),
                  controlAffinity: ControlAffinity.trailing,
                ),
                FormBuilderRadioGroup<String>(
                  decoration: InputDecoration(
                    labelText: 'RH',
                  ),
                  initialValue: null,
                  name: '',
                  options: [
                    '1',
                    '2',
                    '3',
                    '?',
                  ]
                      .map((sex) => FormBuilderFieldOption(
                            value: sex,
                            child: Text(sex),
                          ))
                      .toList(growable: false),
                  controlAffinity: ControlAffinity.trailing,
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  width: double.infinity,
                  child: CupertinoButton.filled(
                    child: Text("儲存"),
                    onPressed: () {
                      Get.back();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
