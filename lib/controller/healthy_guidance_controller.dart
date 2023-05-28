import 'package:ai_kampo_app/api/oberon_api.dart';
import 'package:ai_kampo_app/models/score_model.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class HealthyGuidanceController extends GetxController {
  //健康飲食指引
  final dietList = <ScoreModel>[].obs;
  final recommendFoods = <ScoreModel>[].obs;
  final disrecommendFoods = <ScoreModel>[].obs;
  final isDietDataLoading = true.obs;

  //微量營養素指引
  final nutrientsList = <ScoreModel>[].obs;
  final isNutrientsDataLoading = true.obs;

  //能量針灸
  final acupunctureList = <ScoreModel>[].obs;
  final isAcupunctureDataLoading = true.obs;

  //能量寶石
  final gemList = <ScoreModel>[].obs;
  final isGemDataLoading = true.obs;

  Future<void> fetchDietData(caseId) async {
    isDietDataLoading.value = true;
    dietList.clear();
    recommendFoods.clear();
    disrecommendFoods.clear();

    //RTU
    try {
      final response = await Dio().get(
        "https://api.aikserver01.com/api/Score/23/${caseId}",
        options: Options(headers: OberonAPI.headers),
      );
      if (response.data['success']) {
        List tempList = response.data['data'].toList();
        for (var e in tempList) {
          dietList.add(ScoreModel.fromJson(e));
        }

        if (dietList.length >= 20) {
          recommendFoods.addAll(dietList.getRange(0, 10));
          disrecommendFoods.addAll(dietList.reversed.toList().getRange(0, 10));
        } else {
          recommendFoods.addAll(dietList.getRange(0, dietList.length));
          disrecommendFoods.addAll(dietList.reversed.toList().getRange(0, dietList.length));
        }

        isDietDataLoading.value = false;
      } else {
        Get.snackbar("注意", "無法取得健康飲食指引資料");
      }
    } catch (e) {
      Get.snackbar("注意", "無法取得健康飲食指引資料");
    }
  }

  Future<void> fetchNutrientsData(caseId) async {
    isNutrientsDataLoading.value = true;
    nutrientsList.clear();
    try {
      final response = await Dio().get(
        "https://api.aikserver01.com/api/Score/162/$caseId",
        options: Options(headers: OberonAPI.headers),
      );
      if (response.data['success']) {
        List tempList = response.data['data'].toList();
        for (var e in tempList.length >= 10 ? tempList.getRange(0, 10) : tempList) {
          nutrientsList.add(ScoreModel.fromJson(e));
        }
        isNutrientsDataLoading.value = false;
      } else {
        Get.snackbar("注意", "無法取得微量營養素指引資料");
      }
    } catch (e) {
      Get.snackbar("注意", "無法取得微量營養素指引資料");
    }
  }

  Future<void> fetchAcupunctureData(caseId) async {
    isAcupunctureDataLoading.value = true;

    //RTU
    try {
      final response = await Dio().get(
        "https://api.aikserver01.com/api/Score/156/$caseId",
        options: Options(headers: OberonAPI.headers),
      );
      if (response.data['success']) {
        List tempList = response.data['data'].toList();
        for (var e in tempList.length >= 10 ? tempList.getRange(0, 10) : tempList) {
          acupunctureList.add(ScoreModel.fromJson(e));
        }
        isAcupunctureDataLoading.value = false;
      } else {
        Get.snackbar("注意", "無法取得能量針灸資料");
      }
    } catch (e) {
      Get.snackbar("注意", "無法取得能量針灸資料");
    }
  }

  Future<void> fetchGemData(caseId) async {
    isGemDataLoading.value = true;
    gemList.clear();
//rtu
    try {
      final response = await Dio().get(
        "https://api.aikserver01.com/api/Score/25/$caseId",
        options: Options(headers: OberonAPI.headers),
      );
      if (response.data['success']) {
        List tempList = response.data['data'].toList();
        for (var e in tempList.length >= 10 ? tempList.getRange(0, 10) : tempList) {
          gemList.add(ScoreModel.fromJson(e));
        }
        isGemDataLoading.value = false;
      } else {
        Get.snackbar("注意", "無法取得能量寶石資料");
      }
    } catch (e) {
      Get.snackbar("注意", "無法取得能量寶石資料");
    }
  }

  initHealthyGuidanceData(caseId) {
    fetchDietData(caseId);
    fetchNutrientsData(caseId);
    fetchAcupunctureData(caseId);
    fetchGemData(caseId);
  }
}
