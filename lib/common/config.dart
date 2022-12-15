import 'package:flutter/material.dart';

class KampoConfig {
  static var headers = {
    'reseller': 'tw-00026',
    'api-version': '1.0',
    'Accept-Language': 'zh-tw'
  };
  static var caseId = "1668931826224";

  static List localeList = [
    {
      "key": "zh_TW",
      "name": "locale_zhTW",
      "locale": const Locale("zh", "TW"),
    },
    {
      "key": "zh_CN",
      "name": "locale_zhCN",
      "locale": const Locale("zh", "CN"),
    },
    {
      "key": "en_US",
      "name": "locale_enUS",
      "locale": Locale("en", "US"),
    }
  ];
}
