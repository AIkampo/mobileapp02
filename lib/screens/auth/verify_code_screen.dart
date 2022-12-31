import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';

class VerifyCodeScreen extends StatelessWidget {
  VerifyCodeScreen({super.key});
  FirebaseAuth _auth = FirebaseAuth.instance;
  String _verificationId = '';
  final _phoneNumber = Get.arguments['phoneNumber'];
  @override
  Widget build(BuildContext context) {
    getVerificationCode();

    return Scaffold(
      appBar: AppBar(
        title: Text("驗證"),
        centerTitle: true,
      ),
      body: Center(
        child: FormBuilderTextField(name: "code"),
      ),
    );
  }

  Future<void> getVerificationCode() async {
    await _auth.verifyPhoneNumber(
      phoneNumber: '+886 ${_phoneNumber}',
      verificationCompleted: ((PhoneAuthCredential credential) {
        print("** verificationCompleted");
      }),
      verificationFailed: ((FirebaseAuthException error) {
        print("** verificationFailed");
      }),
      codeSent: ((String verificationId, int? forceResendingToken) async {
        print('** codeSent');

        _verificationId = verificationId;
      }),
      codeAutoRetrievalTimeout: ((String verificationId) {
        print("** codeAutoRetrievalTimeout");
      }),
    );
  }
}
