import 'package:ai_kampo_app/common/config.dart';
import 'package:ai_kampo_app/models/score_model.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class HealthyGuideController extends GetxController {
  //健康飲食指引
  var dietList = <ScoreModel>[].obs;
  //微量營養素指引
  var nutrientsList = <ScoreModel>[].obs;
  //正能量顏色
  // var colorsList = <ScoreModel>[].obs;

  //能量針灸
  var acupunctureList = <ScoreModel>[].obs;

  //能量寶石
  var gemList = <ScoreModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    print("***** HealthyGuideController");
    fetchDietData();
    fetchNutrientsData();
    fetchAcupunctureData();
    fetchGemData();
  }

  Future<void> fetchDietData() async {
    try {
      final response = await Dio().get(
        "https://www.oberonhc.com/api/Score/23/${KampoConfig.caseId}",
        options: Options(headers: KampoConfig.headers),
      );
      if (response.data['success']) {
        List tempList = response.data['data'].toList();
        tempList.forEach((e) => dietList.add(ScoreModel.fromJson(e)));
      } else {
        Get.snackbar("Failed!", "無法取得健康飲食指引資料");
      }
    } catch (e) {
      Get.snackbar("", "無法取得健康飲食指引資料");
    }
  }

  Future<void> fetchNutrientsData() async {
    try {
      final response = await Dio().get(
        "https://www.oberonhc.com/api/Score/162/${KampoConfig.caseId}",
        options: Options(headers: KampoConfig.headers),
      );
      if (response.data['success']) {
        List tempList = response.data['data'].toList();
        tempList.forEach((e) => nutrientsList.add(ScoreModel.fromJson(e)));
      } else {
        Get.snackbar("Failed!", "無法取得微量營養素指引資料");
      }
    } catch (e) {
      Get.snackbar("", "無法取得微量營養素指引資料");
    }
  }

  Future<void> fetchAcupunctureData() async {
    try {
      final response = await Dio().get(
        "https://www.oberonhc.com/api/Score/156/${KampoConfig.caseId}",
        options: Options(headers: KampoConfig.headers),
      );
      if (response.data['success']) {
        List tempList = response.data['data'].toList();
        tempList.forEach((e) => acupunctureList.add(ScoreModel.fromJson(e)));
      } else {
        Get.snackbar("Failed!", "無法取得能量針灸資料");
      }
    } catch (e) {
      Get.snackbar("", "無法取得能量針灸資料");
    }
  }

  Future<void> fetchGemData() async {
    try {
      final response = await Dio().get(
        "https://www.oberonhc.com/api/Score/25/${KampoConfig.caseId}",
        options: Options(headers: KampoConfig.headers),
      );
      if (response.data['success']) {
        List tempList = response.data['data'].toList();
        tempList.forEach((e) => gemList.add(ScoreModel.fromJson(e)));
      } else {
        Get.snackbar("Failed!", "無法取得能量寶石資料");
      }
    } catch (e) {
      Get.snackbar("", "無法取得能量寶石資料");
    }
  }
}
