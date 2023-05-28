import 'package:ai_kampo_app/api/firebase_api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ServiceAgreementScreen extends StatefulWidget {
  const ServiceAgreementScreen({super.key});

  @override
  State<ServiceAgreementScreen> createState() => _ServiceAgreementScreenState();
}

class _ServiceAgreementScreenState extends State<ServiceAgreementScreen> {
  int _index = 0;
  bool _agreeServiceAgreement = false;

  @override
  Widget build(BuildContext context) {
    var steps = [
      Step(
        isActive: _index > 0,
        title: Text("服務條款協議"),
        content: Column(
          children: [
            Text(
                "    本公司服務條款包括所列規範，《隱私權政策》、《商業條款》、《使用者準則》、《智慧財產權法規》所載的條文。如您註冊或使用AIKAMPO APP，即視為您已確認接受有關條款並同意使用AIKAMPO APP。"),
            Text("    本系統需連接網路來獲取您的資訊，使用過程中會使用您的手機數據，所以建議您在有Wifi的情況下進行檢測。"),
            Text("    爲了可以提供更完善的服務，本系統會收集您的個人資訊和檢測結果，我們會將其資料保密，妥善保護您的隱私。"),
            Text("    本系統為非臨床醫學診斷，您當下的狀況、生活環境、心理情緒、用藥等都會影響您的檢測結果，請確保自身狀況再進行檢測。"),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              width: double.infinity,
              child:
                  CupertinoButton.filled(child: Text('confirm'.tr), onPressed: () => _nextStep()),
            )
          ],
        ),
      ),
      Step(
        isActive: _index > 1,
        title: Text("個資法"),
        content: Column(children: [
          Text("個資法"),
          SizedBox(
            height: 20,
          ),
          SizedBox(
            width: double.infinity,
            child: CupertinoButton.filled(child: Text('confirm'.tr), onPressed: () => _nextStep()),
          ),
        ]),
      ),
      Step(
        isActive: _index > 2,
        title: Text("免責聲明"),
        content: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          width: double.infinity,
          child: Column(
            children: [
              Text("免責聲明"),
              SizedBox(
                height: 50,
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _agreeServiceAgreement = !_agreeServiceAgreement;
                      });
                    },
                    icon: Icon(_agreeServiceAgreement
                        ? Icons.check_circle_outline
                        : Icons.circle_outlined),
                  ),
                  Text("同意AI Kampo服務協議"),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              SizedBox(
                width: double.infinity,
                child: CupertinoButton.filled(
                  child: Text("確認"),
                  onPressed: () {
                    if (!_agreeServiceAgreement) {
                      _showAlertDialog();
                    } else {
                      confirmAgreement();
                    }
                  },
                ),
              )
            ],
          ),
        ),
      )
    ];
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: Stepper(
        currentStep: _index,
        onStepCancel: _prevStep,
        onStepContinue: _nextStep,
        onStepTapped: null, //_skipStep,
        steps: steps,
        controlsBuilder: (context, details) {
          return SizedBox.shrink();
        },
      ),
    );
  }

  void _skipStep(int index) {
    setState(() {
      _index = index;
    });
  }

  void _nextStep() {
    if (_index >= 0) {
      setState(() {
        _index += 1;
      });
    }
  }

  void _prevStep() {
    if (_index > 0) {
      setState(() {
        _index -= 1;
      });
    }
  }

  void confirmAgreement() async {
    final prefs = await SharedPreferences.getInstance();
    final userDocId = prefs.getString('userDocId');

    FirebaseAPI.updateUserData(userDocId!, {'agreeServiceAgreement': true})
        .then((value) => Get.offAndToNamed("/main"));
  }

  void _showAlertDialog() {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('同意AI Kampo服務協議才可使用本APP的檢測功能！'),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            /// This parameter indicates this action is the default,
            /// and turns the action's text to bold text.
            isDefaultAction: true,
            onPressed: () {
              confirmAgreement();
            },
            child: Text('同意'),
          ),
          CupertinoDialogAction(
            child: Text("先使用"),
            onPressed: () {
              Get.offAndToNamed("/main");
            },
            textStyle: TextStyle(color: Colors.grey),
          )
        ],
      ),
    );
  }
}
