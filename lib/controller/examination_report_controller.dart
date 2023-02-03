import 'package:ai_kampo_app/common/function.dart';
import 'package:ai_kampo_app/models/allergen_model.dart';
import 'package:ai_kampo_app/models/germs.dart';
import 'package:ai_kampo_app/models/nine_system_model.dart';
import 'package:ai_kampo_app/models/nine_system_trend_model.dart';
import 'package:ai_kampo_app/models/score_model.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class ExaminationReportController extends GetxController {
  final _headers = {
    'reseller': 'tw-00002',
    'api-version': '1.0',
    'Accept-Language': 'zh-tw'
  };
  final reportCaseId = "".obs;

  //九大組織系統檢測資料
  final nineSystemList = <NineSystemModel>[].obs;
  final isNineSystemDataLoading = true.obs;

  //細菌與微生物評估資料
  final germsList = <GermsModel>[].obs;
  final isGermsDataLoading = true.obs;
  //過敏原評估資料
  final allergenList = <AllergenModel>[].obs;
  final isAllergenDataLoading = true.obs;
  //器官系統分析資料
  final organSystemList = <ScoreModel>[].obs;
  final isOrganSystemDataLoading = true.obs;

//九大組織系統檢測 歷史資料

  final RxMap NineSystemTrendMap = {}.obs;
  final isNineSystemTrendLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> fetchNineSystemData(String caseId) async {
    isNineSystemDataLoading.value = true;
    nineSystemList.clear();

    List tempList = await fetchNineSystemScore(caseId);

    if (tempList.isNotEmpty) {
      //先將回傳的資料依索引順序取得值建立LIST、再依數值大小排序
      // [0 消化, 1 呼吸, 2 泌尿, 3循環, 4 淋巴, 5 內分泌, 6 神經, 7 感知, 8 骨骼]
      nineSystemList.add(
        NineSystemModel.fromJson({
          "indexName": "digestion",
          "score": int.parse(tempList[0].toString()),
          "name": "消化系統",
          "img": "assets/icons/digestive_system.png"
        }),
      );
      nineSystemList.add(NineSystemModel.fromJson({
        "indexName": "breathe",
        "score": int.parse(tempList[1].toString()),
        "name": "呼吸系統",
        "img": "assets/icons/respiratory_system.png"
      }));
      nineSystemList.add(NineSystemModel.fromJson({
        "indexName": "urinary",
        "score": int.parse(tempList[2].toString()),
        "name": "泌尿系統",
        "img": "assets/icons/urinary_system.png"
      }));
      nineSystemList.add(NineSystemModel.fromJson({
        "indexName": "cycle",
        "score": int.parse(tempList[3].toString()),
        "name": "循環系統",
        "img": "assets/icons/circulatory_system.png"
      }));
      nineSystemList.add(NineSystemModel.fromJson({
        "indexName": "lymph",
        "score": int.parse(tempList[4].toString()),
        "name": "淋巴系統",
        "img": "assets/icons/lymphatic_system.png"
      }));

      nineSystemList.add(NineSystemModel.fromJson({
        "indexName": "endocrine",
        "score": int.parse(tempList[5].toString()),
        "name": "内分泌系統",
        "img": "assets/icons/endocrine_system.png"
      }));

      nineSystemList.add(NineSystemModel.fromJson({
        "indexName": "nerve",
        "score": int.parse(tempList[6].toString()),
        "name": "神經系統",
        "img": "assets/icons/nervous_system.png"
      }));

      nineSystemList.add(NineSystemModel.fromJson({
        "indexName": "perception",
        "score": int.parse(tempList[7].toString()),
        "name": "感知系統",
        "img": "assets/icons/perception_system.png"
      }));
      nineSystemList.add(NineSystemModel.fromJson({
        "indexName": "skeletion",
        "score": int.parse(tempList[8].toString()),
        "name": "骨骼系統",
        "img": "assets/icons/skeletal_system.png"
      }));

      nineSystemList.sort((a, b) => a.score!.compareTo(b.score!));
      isNineSystemDataLoading.value = false;
    }
  }

  Future<void> fetchGermsData(caseId) async {
    isGermsDataLoading.value = true;
    germsList.clear();
    try {
      final response = await Dio().get(
        "https://www.oberonhc.com/api/Score/8/$caseId",
        options: Options(headers: _headers),
      );
      if (response.data['success']) {
        List tempList = response.data['data'].toList();
        tempList = sortAndGetList(tempList, "d", "DESC", 5);
        for (var e in tempList) {
          germsList.add(GermsModel.fromJson(e));
        }
        isGermsDataLoading.value = false;
      } else {
        Get.snackbar("Failed!", "無法取得細菌與微生物評估資料");
      }
    } catch (e) {
      Get.snackbar("", "無法取得細菌與微生物評估資料");
    }
  }

  List sortAndGetList(List dataList, column, orderBy, count) {
    if (orderBy == "DESC") {
      dataList.sort((a, b) => b['d'].compareTo(a['d']));
    } else {
      dataList.sort((a, b) => a['d'].compareTo(b['d']));
    }

    return dataList.getRange(0, count).toList();
  }

  Future<void> fetchAllergenData(caseId) async {
    isAllergenDataLoading.value = true;
    allergenList.clear();
    try {
      final response = await Dio().get(
        "https://www.oberonhc.com/api/Score/22/$caseId",
        options: Options(headers: _headers),
      );
      if (response.data['success']) {
        List tempList = response.data['data'].toList();
        tempList = sortAndGetList(tempList, "d", "DESC", 5);
        for (var e in tempList) {
          allergenList.add(AllergenModel.fromJson(e));
        }
        isAllergenDataLoading.value = false;
      } else {
        Get.snackbar("Failed!", "無法取得過敏原評估資料");
      }
    } catch (e) {
      Get.snackbar("", "無法取得過敏原評估資料");
    }
  }

  Future<void> fetchOrganSystemData(String organ, String caseId) async {
    isOrganSystemDataLoading.value = true;
    organSystemList.clear();
    try {
      final response = await Dio().get(
        "https://www.oberonhc.com/api/Score/$organ/7/$caseId",
        options: Options(headers: _headers),
      );

      if (response.data['success']) {
        List tempList = response.data['data'].toList();
        tempList = sortAndGetList(tempList, "d", "DESC", 5);

        tempList.forEach((e) => organSystemList.add(ScoreModel.fromJson(e)));
      } else {
        Get.snackbar("Failed!", "無法取得器官系統分析資料!");
      }
    } catch (e) {
      Get.snackbar("", "無法取得器官系統分析資料");
    }
    isOrganSystemDataLoading.value = false;
  }

  setCaseId(String caseId) {
    reportCaseId.value = caseId;
  }

//取得歷使器官分數已繪製「健康趨勢圖」
  Future<void> fetchNineSystemTrendData(List caseIdList) async {
    isNineSystemTrendLoading.value = true;
    NineSystemTrendMap.value = {};
    List<SystemTrendModel> digestionList = [];
    List<SystemTrendModel> breatheList = [];
    List<SystemTrendModel> urinaryList = [];
    List<SystemTrendModel> cycleList = [];
    List<SystemTrendModel> lymphList = [];
    List<SystemTrendModel> endocrineList = [];
    List<SystemTrendModel> nerveList = [];
    List<SystemTrendModel> perceptionList = [];
    List<SystemTrendModel> skeletionList = [];

    try {
      for (var caseId in caseIdList.reversed) {
        var tempList = await fetchNineSystemScore(caseId);
        var tempDate = caseIdToDatetime(caseId);

        // [0 消化, 1 呼吸, 2 泌尿, 3循環, 4 淋巴, 5 內分泌, 6 神經, 7 感知, 8 骨骼]
        digestionList.add(SystemTrendModel(tempDate, tempList[0]));
        breatheList.add(SystemTrendModel(tempDate, tempList[1]));
        urinaryList.add(SystemTrendModel(tempDate, tempList[2]));
        cycleList.add(SystemTrendModel(tempDate, tempList[3]));
        lymphList.add(SystemTrendModel(tempDate, tempList[4]));
        endocrineList.add(SystemTrendModel(tempDate, tempList[5]));
        nerveList.add(SystemTrendModel(tempDate, tempList[6]));
        perceptionList.add(SystemTrendModel(tempDate, tempList[7]));
        skeletionList.add(SystemTrendModel(tempDate, tempList[8]));
      }

      NineSystemTrendMap.value = {
        "digestion": digestionList,
        "breathe": breatheList,
        "urinary": urinaryList,
        "cycle": cycleList,
        "lymph": lymphList,
        "endocrine": endocrineList,
        "nerve": nerveList,
        "perception": perceptionList,
        "skeletion": skeletionList
      };
    } catch (e) {
      Get.snackbar("注意！", "無法解析健康趨勢資料");
    }
    isNineSystemTrendLoading.value = false;
  }

  Future<List> fetchNineSystemScore(String caseId) async {
    List scoreList = [];
    await Dio()
        .get(
      "https://www.oberonhc.com/api/Score/${caseId}",
      options: Options(headers: _headers),
    )
        .then((res) {
      if (res.data['success']) {
        scoreList = res.data['data'];
      }
    }).catchError((e) {
      Get.snackbar("注意!", "無法取得九大組織系統分數");
    });
    return scoreList;
  }
}
