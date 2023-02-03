import 'package:ai_kampo_app/api/orberon_api.dart';
import 'package:dio/dio.dart';
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
  final RxMap<dynamic, dynamic> userProfile = {}.obs;

  Future<void> fetchExaminationList(String phoneNumber) async {
    print("********** fetchExaminationList(phoneNumber) ***************");
    print("phoneNumber:${phoneNumber}");

    isExaminationDataLoading.value = true;
    caseIdList.clear();
    weeklyCaseIdList.clear();
    monthlyCaseIdList.clear();
    threeMonthCaseIdList.clear();

    await Dio()
        .get(
      "https://www.oberonhc.com/api/CaseByPhone/$phoneNumber",
      options: Options(headers: OrberonAPI.headers),
    )
        .then((res) {
      if (res.data['success']) {
        List templist = res.data['data'];

        sortExaminationList(templist);
      } else {
        Get.snackbar("注意!", "無法取得檢測資料");
      }
    });
  }

//依時間排序、分類 檢測清單
  Future<void> sortExaminationList(List examinationList) async {
    print("******* sortExaminationList(List examinationList)  ********");
    print(examinationList);
    examinationList.sort(
      (a, b) => b.compareTo(a),
    );
    //最新檢測
    theLastCaseId.value = examinationList.first;

    final timestamp7DaysAgo =
        DateTime.now().add(Duration(days: -7)).millisecondsSinceEpoch;
    final timestamp1MonthAgo =
        DateTime.now().add(Duration(days: -30)).millisecondsSinceEpoch;
    final timestamp3MonthAgo =
        DateTime.now().add(Duration(days: -90)).millisecondsSinceEpoch;

// 全部檢測清單
    caseIdList.value = examinationList;

    examinationList.forEach((caseId) {
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
    });
    isExaminationDataLoading.value = false;
  }

  Future<void> setUserProfile(Map<dynamic, dynamic> userData) async {
    userProfile.value = userData;
  }
}
