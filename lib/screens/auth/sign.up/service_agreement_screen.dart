import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';

class ServiceAgreementScreen extends StatefulWidget {
  const ServiceAgreementScreen({super.key});

  @override
  State<ServiceAgreementScreen> createState() => _ServiceAgreementScreenState();
}

class _ServiceAgreementScreenState extends State<ServiceAgreementScreen> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    var _steps = [
      Step(
        isActive: _index > 0,
        title: Text("服務條款協議"),
        content: Column(
          children: [
            Text(
                "    本公司服務條款包括所列規範，《隱私權政策》、《商業條款》、《使用者準則》、《智慧財產權法規》所載的條文。如您註冊或使用AIKAMPO APP，即視為您已確認接受有關條款並同意使用AIKAMPO APP。"),
            Text("    本系統需連接網路來獲取您的資訊，使用過程中會使用您的手機數據，所以建議您在有Wifi的情況下進行檢測。"),
            Text("    爲了可以提供更完善的服務，本系統會收集您的個人資訊和檢測結果，我們會將其資料保密，妥善保護您的隱私。"),
            Text(
                "    本系統為非臨床醫學診斷，您當下的狀況、生活環境、心理情緒、用藥等都會影響您的檢測結果，請確保自身狀況再進行檢測。"),
          ],
        ),
      ),
      Step(
          isActive: _index > 1,
          title: Text("個資法"),
          content: Center(child: Text("個資法"))),
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
                height: 80,
              ),
              FormBuilderCheckbox(
                name: '',
                initialValue: false,
                title: RichText(
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: '同意AI Kampo服務協議',
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
              FormBuilderCheckbox(
                name: '',
                initialValue: false,
                title: RichText(
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: '不再顯示',
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 20),
                width: double.infinity,
                child: CupertinoButton.filled(
                  child: Text("確認"),
                  onPressed: () {
                    // _showAlertDialog(context);
                    Get.offAndToNamed("/main");
                  },
                ),
              ),
            ],
          ),
        ),
      )
    ];
    return Scaffold(
      appBar: AppBar(),
      body: Stepper(
        currentStep: _index,
        onStepCancel: _prevStep,
        onStepContinue: _nextStep,
        onStepTapped: _skipStep,
        steps: _steps,
        controlsBuilder: (context, details) {
          return
              //SizedBox.shrink();
              Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  child: Text("上一步"),
                  onPressed: _prevStep,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: ElevatedButton(
                  child: Text("下一步"),
                  onPressed: _nextStep,
                ),
              )
            ],
          );
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
    if (_index <= 0) {
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

  void _showAlertDialog(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('註冊成功'),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            /// This parameter indicates this action is the default,
            /// and turns the action's text to bold text.
            isDefaultAction: true,
            onPressed: () {
              Get.offAllNamed("/sign.in");
            },
            child: const Text('ok'),
          ),
        ],
      ),
    );
  }
}
