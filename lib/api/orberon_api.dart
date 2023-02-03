import 'package:dio/dio.dart';

class OrberonAPI {
  static final Map<String, dynamic> headers = {
    'reseller': 'tw-00026',
    'api-version': '1.0',
    'Accept-Language': 'zh-tw'
  };
  static Future sendExaminationData(Map<String, String> data) async {
    return await Dio().post("https://www.oberonhc.com/api/CloudData",
        options: Options(headers: headers), data: data);
  }

  static Future checkAnalysisStatus(String caseId) async {
    return await Dio().get('https://www.oberonhc.com/api/Status/$caseId',
        options: Options(headers: headers));
  }
}
