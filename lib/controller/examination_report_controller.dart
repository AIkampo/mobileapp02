import 'dart:async';
import 'dart:math';

import 'package:ai_kampo_app/controller/account_controller.dart';
import 'package:get/get.dart';

import 'package:ai_kampo_app/common/config.dart';
import 'package:ai_kampo_app/api/oberon_api.dart';
import 'package:ai_kampo_app/common/function.dart';
import 'package:ai_kampo_app/models/allergen_model.dart';
import 'package:ai_kampo_app/models/germs.dart';
import 'package:ai_kampo_app/models/link_metadata.dart';
import 'package:ai_kampo_app/models/nine_system_model.dart';
import 'package:ai_kampo_app/models/nine_system_trend_model.dart';
import 'package:ai_kampo_app/models/score_model.dart';


class ExaminationReportController extends GetxController {
  final reportCaseId = "".obs;

  final birth = "".obs;
  final name = "".obs;
  final bloodGroup = "".obs;
  final sex = "".obs;
  final isUserProfileLoading = true.obs;

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
  Map<String, LinkListState> linkListState = {
    "digestion": LinkListState(),
    "breathe": LinkListState(),
    "urinary": LinkListState(),
    "cycle": LinkListState(),
    "lymph": LinkListState(),
    "endocrine": LinkListState(),
    "nerve": LinkListState(),
    "perception": LinkListState(),
    "skeleton": LinkListState(),
  };

//九大組織系統檢測 歷史資料

  final RxMap nineSystemTrendMap = {}.obs;
  final isNineSystemTrendLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> fetchUserData(caseId) async {
    isUserProfileLoading.value = true;
    allergenList.clear();
    String phone =
      Get.find<AccountController>().selectedUser.value!.phoneNumber;
    await OberonAPI.getUserDataFromPhone(
      caseId: caseId,
      phoneNumber: phone,
    ).then((res) {
      if (res != null) {
        birth.value = res.birthDate?? "";
        name.value = res.name?? "";
        bloodGroup.value = res.bloodGroup?? "";
        sex.value = res.sex?? "";
      } else {
        throw Exception("無法取得基本資料");
      }
    }).catchError((e) {
      Get.snackbar("注意", "無法取得基本資料");
    }).whenComplete(() {
      isUserProfileLoading.value = false;
    });
  }

  Future<void> fetchNineSystemData(String caseId) async {
    isNineSystemDataLoading.value = true;
    nineSystemList.clear();

    List tempList = await fetchNineSystemScore(caseId);

    if (tempList.isNotEmpty) {
      //先將回傳的資料依索引順序取得值建立LIST、再依數值大小排序
      // [0 消化, 1 呼吸, 2 泌尿, 3循環, 4 淋巴, 5 內分泌, 6 神經, 7 感知, 8 骨骼]
      nineSystemList.add(
        NineSystemModel(
          indexName: "digestion",
          score: int.parse(tempList[0].toString()),
          name: "消化系統",
          meridianName: "脾胃",
          img: "assets/images/digestive_system.png"
        )
      );
      nineSystemList.add(
        NineSystemModel(
          indexName: "breathe",
          score: int.parse(tempList[1].toString()),
          name: "呼吸系統",
          meridianName: "肺經絡",
          img: "assets/images/respiratory_system.png"
        )
      );
      nineSystemList.add(
        NineSystemModel(
          indexName: "urinary",
          score: int.parse(tempList[2].toString()),
          name: "泌尿系統",
          meridianName: "腎膀胱",
          img: "assets/images/urinary_system.png"
        )
      );
      nineSystemList.add(
        NineSystemModel(
          indexName: "cycle",
          score: int.parse(tempList[3].toString()),
          name: "循環系統",
          meridianName: "心包經絡",
          img: "assets/images/circulatory_system.png"
        )
      );
      nineSystemList.add(
        NineSystemModel(
          indexName: "lymph",
          score: int.parse(tempList[4].toString()),
          name: "淋巴系統",
          meridianName: "三焦淋巴",
          img: "assets/images/lymphatic_system.png"
        )
      );
      nineSystemList.add(
        NineSystemModel(
          indexName: "endocrine",
          score: int.parse(tempList[5].toString()),
          name: "内分泌系統",
          meridianName: "三焦內分泌",
          img: "assets/images/endocrine_system.png"
        )
      );
      nineSystemList.add(
        NineSystemModel(
          indexName: "nerve",
          score: int.parse(tempList[6].toString()),
          name: "神經系統",
          meridianName: "心經絡",
          img: "assets/images/nervous_system.png"
        )
      );
      nineSystemList.add(
        NineSystemModel(
          indexName: "perception",
          score: int.parse(tempList[7].toString()),
          name: "感知系統",
          meridianName: "心肝感知",
          img: "assets/images/perception_system.png"
        )
      );
      nineSystemList.add(
        NineSystemModel(
          indexName: "skeleton",
          score: int.parse(tempList[8].toString()),
          name: "骨骼系統",
          meridianName: "腎主骨",
          img: "assets/images/skeletal_system.png"
        )
      );
      nineSystemList.sort((a, b) => a.score!.compareTo(b.score!));
      isNineSystemDataLoading.value = false;
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

  Future<void> fetchOrganSystemData(String caseId) async {
    linkListState = {
      "digestion": LinkListState(),
      "breathe": LinkListState(),
      "urinary": LinkListState(),
      "cycle": LinkListState(),
      "lymph": LinkListState(),
      "endocrine": LinkListState(),
      "nerve": LinkListState(),
      "perception": LinkListState(),
      "skeleton": LinkListState(),
    };

    Map<String, List<ScoreModel>> allSystemData = {};
    List<Future> systemDataTasks = [];
    for (String organ in ExaminationConfig.nineSystemIndexList) {
      Future task = OberonAPI.getOrganSystemData(organ, caseId).then((res) {
        if (res.data['success']) {
          List tempList = res.data['data'].toList();
          tempList = sortAndGetList(tempList, "d", "ACE", 10);

          List<ScoreModel> organSystemData = [];
          for (var e in tempList) {
            organSystemData.add(ScoreModel.fromJson(e));
          }
          allSystemData[organ] = organSystemData;
        } else {
          throw Exception("無法取得經絡分析資料!");
        }
      })
      .catchError((e) {
        Get.snackbar("注意", "無法取得經絡分析資料!");
      });
      systemDataTasks.add(task);
    }
    await Future.wait(systemDataTasks);

    for (String organ in ExaminationConfig.nineSystemIndexList) {
      List<ScoreModel> organSystemData = allSystemData[organ]?? [];
      List<LinkMetaData> metaData = [];
      for (ScoreModel data in organSystemData) {
        metaData.add(LinkMetaData(
          link: data.gptUrl?? "", title: data.title?? ""));
        if (metaData.length >= 10) break;
      }
      linkListState[organ]?.loadingData.value = false;
      linkListState[organ]?.data.value = metaData;
    }
  }

  Future<void> setCaseId(String caseId) async {
    reportCaseId.value = caseId;
    fetchNineSystemData(caseId);
    fetchUserData(caseId).then((value) => fetchNineSystemTrendData());
    fetchOrganSystemData(caseId);
    nineSystemTrendMap.value = {};
  }

//取得歷使器官分數已繪製「健康趨勢圖」
  Future<void> fetchNineSystemTrendData() async {
    if (isUserProfileLoading.value == true) return;
    isNineSystemTrendLoading.value = true;
    List<String> caseIdList = await OberonAPI.getExaminationListByName(
      phoneNumber: Get.find<AccountController>().selectedUser.value!.phoneNumber,
      name: name.value,
    ).catchError((e) {
      print(e);
      Get.snackbar("注意", "無法取得檢測列表！");
      return <String>[];
    });
    caseIdList = caseIdList.sublist(0, min(caseIdList.length, 10));
    List<SystemTrendModel> digestionList =
      [for (String id in caseIdList) SystemTrendModel("", 0)];
    List<SystemTrendModel> breatheList =
      [for (String id in caseIdList) SystemTrendModel("", 0)];
    List<SystemTrendModel> urinaryList =
      [for (String id in caseIdList) SystemTrendModel("", 0)];
    List<SystemTrendModel> cycleList =
      [for (String id in caseIdList) SystemTrendModel("", 0)];
    List<SystemTrendModel> lymphList =
      [for (String id in caseIdList) SystemTrendModel("", 0)];
    List<SystemTrendModel> endocrineList =
      [for (String id in caseIdList) SystemTrendModel("", 0)];
    List<SystemTrendModel> nerveList =
      [for (String id in caseIdList) SystemTrendModel("", 0)];
    List<SystemTrendModel> perceptionList =
      [for (String id in caseIdList) SystemTrendModel("", 0)];
    List<SystemTrendModel> skeletonList =
      [for (String id in caseIdList) SystemTrendModel("", 0)];

    try {
      List<Future> tasks = [];
      for (var caseId in caseIdList.reversed) {
        Future task = fetchNineSystemScore(caseId)
        .then((tempList) {
          var tempDate = caseIdToDatetime(caseId);
          int index = caseIdList.indexOf(caseId);
          if (index == -1) return;
          // [0 消化, 1 呼吸, 2 泌尿, 3循環, 4 淋巴, 5 內分泌, 6 神經, 7 感知, 8 骨骼]
          digestionList[index] = SystemTrendModel(tempDate, tempList[0]);
          breatheList[index] = SystemTrendModel(tempDate, tempList[1]);
          urinaryList[index] = SystemTrendModel(tempDate, tempList[2]);
          cycleList[index] = SystemTrendModel(tempDate, tempList[3]);
          lymphList[index] = SystemTrendModel(tempDate, tempList[4]);
          endocrineList[index] = SystemTrendModel(tempDate, tempList[5]);
          nerveList[index] = SystemTrendModel(tempDate, tempList[6]);
          perceptionList[index] = SystemTrendModel(tempDate, tempList[7]);
          skeletonList[index] = SystemTrendModel(tempDate, tempList[8]);
        });
        tasks.add(task);
      }
      await Future.wait(tasks);

      nineSystemTrendMap.value = {
        "digestion": digestionList,
        "breathe": breatheList,
        "urinary": urinaryList,
        "cycle": cycleList,
        "lymph": lymphList,
        "endocrine": endocrineList,
        "nerve": nerveList,
        "perception": perceptionList,
        "skeleton": skeletonList
      };
      print("trend data READY!");
      isNineSystemTrendLoading.value = false;
    } catch (e) {
      Get.snackbar("注意！", "無法解析健康趨勢資料");
      isNineSystemTrendLoading.value = false;
    }
  }

  Future<List> fetchNineSystemScore(String caseId) async {
    List scoreList = [];

    await OberonAPI.getNineSystemScore(caseId).then((res) {
      if (res.data['success']) {
        scoreList = res.data['data'];
      } else {
        throw Exception("無法取得九大組織系統分數");
      }
    }).catchError((e) {
      Get.snackbar("注意!", "無法取得九大組織系統分數");
    }).whenComplete(() => scoreList);
    return scoreList;
  }
}
