import 'dart:convert';
import 'package:ai_kampo_app/models/user_report_list.dart';
import 'package:dio/dio.dart';


class OberonAPI {
  static const apiUrl =
      // "https://www.oberonhc.com/api";
      "https://api.aikserver01.com/api";

  static final Map<String, dynamic> headers = {
    'reseller': 'tw-00026',
    'api-version': '1.0',
    'Accept-Language': 'zh-tw'
  };
  static Future sendExaminationData(Map<String, String> data) {
    return Dio().post("$apiUrl/CloudData", options: Options(headers: headers), data: data);
  }

  static Future checkAnalysisStatus(String caseId) async {
    return await Dio().get('$apiUrl/Status/$caseId', options: Options(headers: headers));
  }

  static Future getExaminationList(String phoneNumber) async {
    return await Dio().get(
      "$apiUrl/CaseByPhone/$phoneNumber",
      options: Options(headers: headers),
    );
  }

  static Future<UserReportListData?> getUserDataFromPhone({
    required String caseId,
    required String phoneNumber,
  }) async {
    Response response = await Dio().post(
      "$apiUrl/User/UserReportListBytel1/$phoneNumber",
      options: Options(headers: headers),
      data: jsonEncode({
        "reseller_no": "tw-00026",
        "reseller_tel1": "0277552030",
      }),
    );
    for (Map<String, dynamic> data in response.data) {
      // check testing time and keep latest data
      UserReportListData iterateData = UserReportListData.fromJson(data);
      if (iterateData.id == caseId) {
        return iterateData;
      }
    }
    return null;
  }

  static Future<List<String>> getExaminationListByName({
    required String phoneNumber,
    required String name,
  }) async {
    Response response = await Dio().post(
      "$apiUrl/User/UserReportList",
      options: Options(headers: headers),
      data: jsonEncode({
        "reseller_no": "tw-00026",
        "reseller_tel1": "0277552030",
      }),
    );
    // TODO: currently only store case ID
    List<String> caseId = [];
    for (Map<String, dynamic> data in response.data) {
      // check testing time and keep latest data
      UserReportListData iterateData = UserReportListData.fromJson(data);
      if (iterateData.name == name && iterateData.tel1 == phoneNumber) {
        caseId.add(iterateData.id?? "");
      }
    }
    return caseId;
  }

  static Future getGermsData(String caseId) {
    return Dio().get(
      "$apiUrl/Score/8/$caseId",
      options: Options(headers: headers),
    );
  }

  static Future getAllergenData(String caseId) {
    return Dio().get(
      "$apiUrl/Score/22/$caseId",
      options: Options(headers: headers),
    );
  }

  static Future getOrganSystemData(String organ, String caseId) {
    return Dio().get(
      "https://api.aikampo.com/api/Score/$organ/7/$caseId",
      options: Options(headers: headers),
    );
  }

  static Future getNineSystemScore(String caseId) {
    return Dio().get(
      "$apiUrl/Score/$caseId",
      options: Options(headers: headers),
    );
  }

  static Future getNutrientsData(String caseId) {
    return Dio().get(
      "$apiUrl/Score/162/$caseId",
      options: Options(headers: headers),
    );
  }

  static Future getAcupunctureData(String caseId) {
    return Dio().get(
      "$apiUrl/Score/156/$caseId",
      options: Options(headers: headers),
    );
  }

  static Future getGemData(String caseId) {
    return Dio().get(
      "$apiUrl/Score/25/$caseId",
      options: Options(headers: headers),
    );
  }

  static Future getCaseId() async {
    return Dio().get(
      "$apiUrl/Ingress/qrcode",
      options: Options(headers: headers),
    );
  }
}
