import 'package:flutter/material.dart';

class KampoConfig {
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
      "locale": const Locale("en", "US"),
    }
  ];

  //預計取得耳機的資料長度(bytes)
  static int examinationDataLength = 12800;
  //預估耳機檢測時間 (second)
  static int headsetExaminationTime = 120;
  //預估server 分析時間(second)
  static int examinationAnalysingTime = 90;
  static int totalExaminationTime = headsetExaminationTime + examinationAnalysingTime;

  //預計每隔多少天進行 體質表 評估
  static int doPhysiqueRatingEveryDays = 31;
}

class KampoColors {
  static const primary = Color(0xFF7890C8);
  static const secondary = Color(0xFFB6ADDE);
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

  static Color getOrganSystemScoreColor(double score) {
    Color scoreColor;
    if (score > 1) {
      scoreColor = KampoColors.scoreGreen;
    } else if (score > 0.75) {
      scoreColor = KampoColors.scoreYellow;
    } else if (score > 0.425) {
      scoreColor = KampoColors.scoreOrange;
    } else {
      scoreColor = KampoColors.scoreRed;
    }
    return scoreColor;
  }
}

class UserProfile {
  static List<String> bloodTypeList = ["O", "A", "B", "AB", "未知"];
  static List<String> rhList = ["+", "-", "未知"];
}

class Examination {
  //[0 消化, 1 呼吸, 2 泌尿, 3 循環, 4 淋巴, 5 內分泌, 6 神經, 7 感知, 8 骨骼]
  static List<String> nineSystemIndexList = [
    "digestion",
    "breathe",
    "urinary",
    "cycle",
    "lymph",
    "endocrine",
    "nerve",
    "perception",
    "skeleton"
  ];
  //[0 消化, 1 呼吸, 2 泌尿, 3 循環, 4 淋巴, 5 內分泌, 6 神經, 7 感知, 8 骨骼]
  static List<String> nineSystemNameList = [
    "消化系統",
    "呼吸系統",
    "泌尿系統",
    "循環系統",
    "淋巴系統",
    "內分泌系統",
    "神經系統",
    "感知系統",
    "骨骼系統"
  ];

  static getScoreText(double score) {
    if (score > 1) {
      return 'G';
    } else if (score > 0.75) {
      return 'Y';
    } else if (score > 0.425) {
      return 'O';
    } else {
      return 'R';
    }
  }

  static Color getScoreTextColor(double score) {
    if (score > 0.75) {
      return Colors.black;
    } else {
      return Colors.white;
    }
  }
}
