import 'package:ai_kampo_app/api/oberon_api.dart';
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

  Future<void> fetchExaminationList(String phoneNumber) async {
    isExaminationDataLoading.value = true;
    caseIdList.clear();
    weeklyCaseIdList.clear();
    monthlyCaseIdList.clear();
    threeMonthCaseIdList.clear();
    await OberonAPI.getExaminationList(phoneNumber).then((res) {
      if (res.data['success']) {
        List templist = res.data['data'];

        sortExaminationList(templist);
      } else {
        Get.snackbar("注意", "無法取得檢測列表！");
      }
    }).catchError((e) {
      isExaminationDataLoading.value = false;
      Get.snackbar("注意", "無法取得檢測列表！");
    });
  }

  // Future fetchUserProfile(String phoneNumber) async {
  //   FirebaseAPI.getUserData(phoneNumber).then((res) => userProfile.value = res);
  // }

//依時間排序、分類 檢測清單
  Future<void> sortExaminationList(List examinationList) async {
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
