//體質評估表

import 'package:ai_kampo_app/screens/constitution.assessment/constitution_card_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';

class ConstitutionAssessmentScreen extends StatefulWidget {
  const ConstitutionAssessmentScreen({super.key});

  @override
  State<ConstitutionAssessmentScreen> createState() =>
      _ConstitutionAssessmentScreenState();
}

class _ConstitutionAssessmentScreenState
    extends State<ConstitutionAssessmentScreen> {
  int _stepIndex = 0;
  List<String> _questionList = [
    "您平時覺得精力充沛嗎？",
    "您容易感到疲乏易累嗎？",
    "您平時説話聲音低弱無力嗎？",
    "您容易感到悶悶不樂嗎？",
    "您平時怕冷嗎？",
    "您平時胃口良好嗎？",
    "您能快熟適應外界的變化嗎？",
    // "您容易失眠嗎？",
    // "你容易健忘嗎？",
    // "您容易臉色蒼白嗎？",
  ];

  List<bool> _activeList = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    // false,
    // false,
    // false
  ].obs;

// 判別是否填寫完成
  bool _fillOut = false.obs();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
          appBar: AppBar(
            title: Text("體質表"),
            centerTitle: true,
            actions: [
              TextButton(
                onPressed: _fillOut
                    ? () {
                        Get.to(() => ConstitutionCardScreen());
                      }
                    : null,
                child: Text(
                  "查詢結果",
                  style: TextStyle(
                    color: _fillOut ? Colors.amber : Colors.black12,
                  ),
                ),
              )
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Text(
                    "爲了可以跟瞭解您的身體狀況，本系統每個月會跳出\“體質表\”供您填寫，以便提供您更正確的檢測報告。",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                Text("透過下列題目，能快速評估您所屬的體質。"),
                Stepper(
                  physics: ClampingScrollPhysics(),
                  currentStep: _stepIndex,
                  // onStepCancel: _prevStep,
                  // onStepContinue: _nextStep,
                  onStepTapped: _skipToStep,
                  controlsBuilder: (context, details) {
                    return SizedBox(
                      width: 10,
                    );
                  },
                  steps: buildStep(_questionList, _activeList, _stepIndex),
                ),
              ],
            ),
          ));
    });
  }

  void _skipToStep(value) {
    setState(() {
      _stepIndex = value;
    });
  }

  void _nextStep() {
    if (_stepIndex <= _questionList.length - 2) {
      setState(() {
        _stepIndex += 1;
      });
    }
  }

  void _prevStep() {
    if (_stepIndex > 0) {
      setState(() {
        _stepIndex -= 1;
      });
    }
  }

  void _checkFillOut() {
    bool tempVal = true;
    _activeList.forEach((val) {
      //只要有一個false, 表示尚未填完
      if (!val) {
        tempVal = val;
        print("val:$val");
      }
    });
    _fillOut = tempVal;
  }

  List<Step> buildStep(
      List<String> questionList, List<bool> activeList, int stepIndex) {
    List optionsList = ["沒有 ", "很少 ", "還好 ", "經常 ", "總是 "];
    return questionList.map((question) {
      int _currentIndex = questionList.indexOf(question);
      return Step(
        isActive: activeList[_currentIndex],
        title: Text(question),
        content: Row(
          children: [
            Expanded(
              child: FormBuilderRadioGroup(
                name: "",
                onChanged: (value) {
                  activeList[_currentIndex] = true;
                  _nextStep();
                  _checkFillOut();
                },
                options: optionsList
                    .map((e) => FormBuilderFieldOption(
                          value: e,
                          child: Text(e),
                        ))
                    .toList(),
              ),
            )
          ],
        ),
      );
    }).toList();
  }
}
