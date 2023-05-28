import 'package:ai_kampo_app/api/firebase_api.dart';
import 'package:ai_kampo_app/common/config.dart';
import 'package:ai_kampo_app/common/nbc.in.tcm.dart';
import 'package:ai_kampo_app/controller/tcm_nine_constitutions_controller.dart';
import 'package:ai_kampo_app/screens/physical.examination/examination_tips_screen.dart';
import 'package:ai_kampo_app/tcm.nine.constitutions/body_constitution_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';

class EvaluationScreen extends StatelessWidget {
  EvaluationScreen({super.key});
  final _tncController = Get.find<TcmNineConstitutionsController>();

  @override
  Widget build(BuildContext context) {
    _tncController.initData();
    return Obx(
      () => Scaffold(
          appBar: AppBar(
            leading: buildPageIndex(),
            automaticallyImplyLeading: false,
            title: Text(
              NBCinTCM.types[_tncController.currentEvaluationType.value],
            ),
            centerTitle: true,
            actions: [
              TextButton(
                onPressed: () {
                  Get.to(() => ExaminationTipsScreen());
                },
                child: const Text(
                  '略過評估',
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          ),
          body: _tncController.isLoading.value
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      Stepper(
                        physics: const ClampingScrollPhysics(),
                        currentStep: _tncController.currentQuestionIndex.value,
                        steps: buildStep().toList(),
                        onStepTapped: _skipToStep,
                        controlsBuilder: (context, details) => const SizedBox.shrink(),
                      ),
                    ],
                  ),
                ),
          bottomNavigationBar: buildNavigationButton()),
    );
  }

  buildPageIndex() {
    return Container(
      color: KampoColors.secondary,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${_tncController.currentEvaluationType.value + 1}',
            style: const TextStyle(
              fontSize: 36,
            ),
          ),
         const Text(
            '/',
            style: TextStyle(fontSize: 18),
          ),
          const Text('9')
        ],
      ),
    );
  }

  buildNavigationButton() {
    if (_tncController.isFillOut.value) {
      // 確認是否已完成9種體質表
      if (_tncController.currentEvaluationType.value + 1 == 9) {
        return Container(
          padding: const EdgeInsets.all(8),
          child: CupertinoButton.filled(
            child: Text("查看結果"),
            onPressed: () {
              countScore();            
              saveRating();
              Get.offAll(() => BodyConstitutionCard(
                    userConsitutionType: NBCinTCM.getType(_tncController.scoreList),
                  ));
            },
          ),
        );
      } else {
        return Container(
          padding: const EdgeInsets.all(8),
          child: CupertinoButton.filled(
            child: Text("繼續"),
            onPressed: () => _tncController.goToNextForm(),
          ),
        );
      }
    } else {
      return null;
    }
  }

  List<Step> buildStep() {
    //當前正在評估的體質類型
    final int currentType = _tncController.currentEvaluationType.value;
    final int currentQuestion = _tncController.currentQuestionIndex.value;
    List<Map> optionsList = [
      {"text": "沒有", "value": 1},
      {"text": "很少", "value": 2},
      {"text": "還好", "value": 3},
      {"text": "經常", "value": 4},
      {"text": "總是", "value": 5}
    ];
    List ratingList = [
      "",
      "沒有",
      "很少",
      "還好",
      "經常",
      "總是",
    ];

    return NBCinTCM.evaluationForm[currentType].map((question) {
      //get question index by question text
      int questionIndex = NBCinTCM.evaluationForm[currentType].indexOf(question);

      return Step(
        isActive: questionIndex == currentQuestion,
        title: Row(
          children: [
            Expanded(
              child: Text(
                question.runtimeType == String ? question : question[_tncController.currentUserSex],
                style: TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(
              width: 6,
            ),
            _tncController.ratingList[currentType][questionIndex] != 0
                ? Text(
                    ratingList[_tncController.ratingList[currentType][questionIndex]],
                    style: TextStyle(color: Colors.blue),
                  )
                : const SizedBox.shrink()
          ],
        ),
        content: Row(
          children: [
            Expanded(
              child: FormBuilderRadioGroup(
                orientation: OptionsOrientation.vertical,
                name: "",
                onChanged: (value) {
                  //記錄評估分數             
                  _tncController.ratingList[currentType][questionIndex] = value;
                  _nextStep();
                  // 檢查是否都已填選

                  _tncController.isFillOut.value = !_tncController
                      .ratingList[_tncController.currentEvaluationType.value]
                      .contains(0); // 0 → 尚未填選
                },
                options: optionsList
                    .map((e) => FormBuilderFieldOption(
                          value: e['value'],
                          child: Text(
                            e['text'],
                            style: const TextStyle(fontSize: 16),
                          ),
                        ))
                    .toList(),
              ),
            )
          ],
        ),
      );
    }).toList();
  }

  void _nextStep() {
    if (_tncController.currentQuestionIndex.value + 1 <
        NBCinTCM.evaluationForm[_tncController.currentEvaluationType.value].length) {
      _tncController.currentQuestionIndex.value += 1;
    }
  }

  void _skipToStep(value) {
    _tncController.currentQuestionIndex.value = value;
  }

  countScore() {
    _tncController.isLoading.value = true;
    _tncController.ratingList.asMap().forEach((index, typeScoreList) {
      //計算 "原始分" → 各個條目的分值相加
      num originScore = 0;
      typeScoreList.asMap().forEach((scoreIndex, score) {
        //平和型體質(index == 0)的分數 2,3,4,5,7,8題 要反向計算分數 (5→1, 4→2, 3→3, 2→1, 1→5 )
        if (index == 0 && [1, 2, 3, 4, 6, 7].contains(scoreIndex)) {
          originScore += 6 - score;
        } else {
          originScore += score;
        }
      });
    
      //計算 "轉化分" → [(原始分-條目數）/（條目數×4）］×100
      double finalScore = ((originScore - typeScoreList.length) / (typeScoreList.length * 4)) * 100;

      _tncController.scoreList[index] = finalScore;
    });
  }

  saveRating() async {
    FirebaseAPI.addEvaluationRating(
        _tncController.currentUserPhoneNumber.value,
        _tncController.scoreList,
        DateTime.now(),
        NBCinTCM.types[NBCinTCM.getType(_tncController.scoreList)]);
    final userDocId = await FirebaseAPI.getUserDocId(_tncController.currentUserPhoneNumber.value);
    FirebaseAPI.updateUserData(userDocId, {'lastPhysiqueRatingDateTime': DateTime.now()});
  }
}
