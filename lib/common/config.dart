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

class KampoColors {
  static const scoreGreen = Color(0xFF9ECE6D);
  static const scoreYellow = Color(0xFFEDDA80);
  static const scoreOrange = Color(0xFFFCCD9B);
  static const scoreRed = Color(0xFFF28A8A);
  static Color getScoreColor(int score) {
    Color scoreColor;
    if (score >= 70) {
      scoreColor = KampoColors.scoreGreen;
    } else if (score >= 50) {
      scoreColor = KampoColors.scoreYellow;
    } else if (score >= 20) {
      scoreColor = KampoColors.scoreOrange;
    } else {
      scoreColor = KampoColors.scoreRed;
    }
    return scoreColor;
  }
}
