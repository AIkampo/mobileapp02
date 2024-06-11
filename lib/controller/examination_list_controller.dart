import 'package:ai_kampo_app/api/oberon_api.dart';
import 'package:ai_kampo_app/api/user.dart';
import 'package:ai_kampo_app/models/user_report_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class ExaminationListController extends GetxController {
  //caseId 為 檢測當時timestamp

  // 全部檢測清單
  final caseIdList = [].obs;
  //近一週 檢測清單
  final weeklyCaseIdList = [].obs;
  //近一個月 檢測清單
  final monthlyCaseIdList = [].obs;
  //近三個月 檢測清單
  final threeMonthCaseIdList = [].obs;
  final isExaminationDataLoading = true.obs;
  final theLastCaseId = "".obs;

  removeData() {
    caseIdList.clear();
    weeklyCaseIdList.clear();
    monthlyCaseIdList.clear();
    threeMonthCaseIdList.clear();
    isExaminationDataLoading.value = true;
    theLastCaseId.value = "";
  }

  Future<void> fetchExaminationList({
    required String phoneNumber,
    String? name,
  }) async {
    isExaminationDataLoading.value = true;
    caseIdList.clear();
    weeklyCaseIdList.clear();
    monthlyCaseIdList.clear();
    threeMonthCaseIdList.clear();
    if (name == null) {
      await OberonAPI.getExaminationList(phoneNumber).then((res) {
        if (res.data['success']) {
          List<String> templist = res.data['data'].cast<String>();

          _updateExaminationList(templist);
        } else {
          Get.snackbar("注意", "無法取得檢測列表！");
        }
      }).catchError((e) {
        print(e);
        isExaminationDataLoading.value = false;
        Get.snackbar("注意", "無法取得檢測列表！");
      });
    }
    else {
      await OberonAPI.getExaminationListByName(
        phoneNumber: phoneNumber,
        name: name,
      ).then((res) {
        _updateExaminationList(res);
      }).catchError((e) {
        print(e);
        isExaminationDataLoading.value = false;
        Get.snackbar("注意", "無法取得檢測列表！");
      });
    }
  }

//依時間排序、分類 檢測清單
  Future<void> _updateExaminationList(List<String> examinationList) async {
    if (examinationList.isEmpty) {
      isExaminationDataLoading.value = false;
      return;
    }
    examinationList.sort(
      (a, b) => b.compareTo(a),
    );
    //最新檢測
    theLastCaseId.value = examinationList.first;

    final timestamp7DaysAgo = DateTime.now().add(const Duration(days: -7)).millisecondsSinceEpoch;
    final timestamp1MonthAgo = DateTime.now().add(const Duration(days: -30)).millisecondsSinceEpoch;
    final timestamp3MonthAgo = DateTime.now().add(const Duration(days: -90)).millisecondsSinceEpoch;

// 全部檢測清單
    caseIdList.value = examinationList;

    for (var caseId in examinationList) {
      //取得 近一週 檢測清單
      if (int.parse(caseId) >= timestamp7DaysAgo) {
        weeklyCaseIdList.add(caseId);
      }
      //取得 近一個月 檢測清單
      if (int.parse(caseId) >= timestamp1MonthAgo) {
        monthlyCaseIdList.add(caseId);
      }

      //取得 近三個月 檢測清單
      if (int.parse(caseId) >= timestamp3MonthAgo) {
        threeMonthCaseIdList.add(caseId);
      }
    }
    isExaminationDataLoading.value = false;
  }
}
