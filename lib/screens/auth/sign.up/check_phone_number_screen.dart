import 'package:ai_kampo_app/controller/auth.controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';

class CheckPhoneNumberScreen extends StatefulWidget {
  CheckPhoneNumberScreen({super.key});

  @override
  State<CheckPhoneNumberScreen> createState() => _CheckPhoneNumberScreenState();
}

class _CheckPhoneNumberScreenState extends State<CheckPhoneNumberScreen> {
  String _phoneNumber = "";
  final _formKey = GlobalKey<FormBuilderState>();
  final _authController = Get.find<AuthController>();
  var _phoneNumberCheckable = false.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("signUp".tr),
          centerTitle: true,
        ),
        body: Obx(
          (() => FormBuilder(
                key: _formKey,
                initialValue: const {
                  'phoneNumber': '091234567',
                },
                child: Container(
                  margin: EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FormBuilderTextField(
                        enabled: !_authController.isAvailablePhoneNumber.value,
                        keyboardType: TextInputType.phone,
                        name: "phoneNumber",
                        onChanged: (value) {
                          _phoneNumberCheckable.value = value!.length == 10;
                        },
                        decoration: InputDecoration(
                          filled: true,
                          labelText: "phone".tr,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _phoneNumberCheckable.value
                              ? () => checkPhoneNumber()
                              : null,
                          child: Text("驗證"),
                        ),
                      )
                    ],
                  ),
                ),
              )),
        ));
  }

  Future<void> checkPhoneNumber() async {
    final usersCollection = FirebaseFirestore.instance.collection("users");
    final phoneNumber = _formKey.currentState!.fields["phoneNumber"]?.value;
    try {
      usersCollection
          .where(
            'phoneNumber',
            isEqualTo: phoneNumber,
          )
          .get()
          .then((value) {
        if (value.docs.length == 1) {
          Get.snackbar("驗證失敗", "手機號碼已註冊！");
        } else {
          // Get.toNamed("/verify.code", arguments: {'phoneNumber': phoneNumber});
          Get.toNamed('/sign.up');
        }
      });
    } catch (e) {
      print('************* Failed~ checkPhoneNumber e:${e}');
    }
  }
}
