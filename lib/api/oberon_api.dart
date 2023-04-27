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
    print(" ------- sendExaminationData()   data;---------------");
    print(data);
    return Dio().post("$apiUrl/CloudData",
        options: Options(headers: headers), data: data);
  }

  static Future checkAnalysisStatus(String caseId) async {
    return await Dio()
        .get('$apiUrl/Status/$caseId', options: Options(headers: headers));
  }

  static Future getExaminationList(String phoneNumber) async {
    return await Dio().get(
      "$apiUrl/CaseByPhone/$phoneNumber",
      options: Options(headers: headers),
    );
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
      "$apiUrl/Score/$organ/7/$caseId",
      options: Options(headers: headers),
    );
  }

  static Future getNineSystemScore(String caseId) {
    return Dio().get(
      "$apiUrl/Score/$caseId",
      options: Options(headers: headers),
    );
  }

  static Future getDietData(String caseId) {
    return Dio().get(
      "$apiUrl/Score/23/$caseId",
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
