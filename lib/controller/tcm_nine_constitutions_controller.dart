import 'package:ai_kampo_app/common/nbc.in.tcm.dart';
import 'package:get/get.dart';

class TcmNineConstitutionsController extends GetxController {
  final currentUserPhoneNumber = ''.obs;
  final currentUserSex = 'F'.obs;
  final currentEvaluationType = 0.obs;
  final currentQuestionIndex = 0.obs;
  final isFillOut = false.obs;
  final ratingList = [].obs;
  final isLoading = false.obs;
  //計算每個體質分數
  final scoreList = [].obs;

  initData() {
    currentEvaluationType.value = 0;
    currentQuestionIndex.value = 0;
    isFillOut.value = false;
    ratingList.clear();
    isLoading.value = false;

    for (var form in NBCinTCM.evaluationForm) {
      List tempList = [];
      // 依每個體質的檢測題目來設定初始值 (尚未填選 預設為 0
      for (var question in form) {
        tempList.add(0);
      }
      ratingList.add(tempList);
      scoreList.add(0); //尚未計算的部份 設為0
    }
  }

  goToNextForm() async {
    isLoading.value = true;
    currentEvaluationType.value += 1;
    currentQuestionIndex.value = 0;
    isFillOut.value = false;
    await Future.delayed(const Duration(milliseconds: 777));

    isLoading.value = false;
  }
}
