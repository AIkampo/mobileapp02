import 'package:ai_kampo_app/models/allergen_model.dart';
import 'package:ai_kampo_app/models/germs.dart';
import 'package:ai_kampo_app/models/nine_system_model.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class TestResultsController extends GetxController {
  var _headers = {
    'reseller': 'tw-00026',
    'api-version': '1.0',
    'Accept-Language': 'zh-tw'
  };
  var _caseId = "1668931826224";

  //九大組織系統檢測資料
  var nineSystemList = <NineSystemModel>[].obs;
  //細菌與微生物評估資料
  var germsList = <GermsModel>[].obs;
  //過敏原評估資料
  var allergenList = <AllergenModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchNineSystemData();
    fetchGermsData();
    fetchAllergenData();
  }

  Future<void> fetchNineSystemData() async {
    try {
      final response = await Dio().get(
        "https://www.oberonhc.com/api/Score/$_caseId",
        options: Options(headers: _headers),
      );
      if (response.data['success']) {
        //先將回傳的資料依索引順序取得值建立LIST、再依數值大小排序
        // [0 消化, 1 呼吸, 2 泌尿, 3循環, 4 淋巴, 5 內分泌, 6 神經, 7 感知, 8 骨骼]
        List tempList = response.data['data'].toList();
        nineSystemList.add(NineSystemModel.fromJson({
          "score": int.parse(tempList[3].toString()),
          "name": "循環系統",
          "img": "assets/icons/circulatory_system.png"
        }));
        nineSystemList.add(NineSystemModel.fromJson({
          "score": int.parse(tempList[0].toString()),
          "name": "消化系統",
          "img": "assets/icons/digestive_system.png"
        }));
        nineSystemList.add(NineSystemModel.fromJson({
          "score": int.parse(tempList[2].toString()),
          "name": "泌尿系統",
          "img": "assets/icons/urinary_system.png"
        }));
        nineSystemList.add(NineSystemModel.fromJson({
          "score": int.parse(tempList[5].toString()),
          "name": "内分泌系統",
          "img": "assets/icons/endocrine_system.png"
        }));
        nineSystemList.add(NineSystemModel.fromJson({
          "score": int.parse(tempList[6].toString()),
          "name": "神經系統",
          "img": "assets/icons/nervous_system.png"
        }));
        nineSystemList.add(NineSystemModel.fromJson({
          "score": int.parse(tempList[4].toString()),
          "name": "淋巴系統",
          "img": "assets/icons/lymphatic_system.png"
        }));
        nineSystemList.add(NineSystemModel.fromJson({
          "score": int.parse(tempList[7].toString()),
          "name": "感知系統",
          "img": "assets/icons/perception_system.png"
        }));
        nineSystemList.add(NineSystemModel.fromJson({
          "score": int.parse(tempList[8].toString()),
          "name": "骨骼系統",
          "img": "assets/icons/skeletal_system.png"
        }));
        nineSystemList.add(NineSystemModel.fromJson({
          "score": int.parse(tempList[1].toString()),
          "name": "呼吸系統",
          "img": "assets/icons/respiratory_system.png"
        }));

        nineSystemList.sort((a, b) => a.score!.compareTo(b.score!));
      } else {
        Get.snackbar("Failed!", "無法取得九大系統檢測資料");
      }
    } catch (e) {
      Get.snackbar("", "無法取得九大系統檢測資料");
    }
  }

  Future<void> fetchGermsData() async {
    try {
      final response = await Dio().get(
        "https://www.oberonhc.com/api/Score/8/$_caseId",
        options: Options(headers: _headers),
      );
      if (response.data['success']) {
        List tempList = response.data['data'].toList();
        tempList.forEach((e) => germsList.add(GermsModel.fromJson(e)));
      } else {
        Get.snackbar("Failed!", "無法取得細菌與微生物評估資料");
      }
    } catch (e) {
      Get.snackbar("", "無法取得細菌與微生物評估資料");
    }
  }

  Future<void> fetchAllergenData() async {
    try {
      final response = await Dio().get(
        "https://www.oberonhc.com/api/Score/22/$_caseId",
        options: Options(headers: _headers),
      );
      if (response.data['success']) {
        List tempList = response.data['data'].toList();
        tempList.forEach((e) => allergenList.add(AllergenModel.fromJson(e)));
      } else {
        Get.snackbar("Failed!", "無法取得過敏原評估資料");
      }
    } catch (e) {
      Get.snackbar("", "無法取得過敏原評估資料");
    }
  }
}
