//檢測結果
import 'package:ai_kampo_app/screens/test.results/allergen.dart';
import 'package:ai_kampo_app/screens/test.results/germs_microorganism.dart';
import 'package:ai_kampo_app/screens/test.results/lung_info.dart';
import 'package:ai_kampo_app/screens/test.results/nine_system_buttons.dart';

import 'package:ai_kampo_app/screens/test.results/test_status_tips.dart';
import 'package:ai_kampo_app/widgets/common/KampoTitle.dart';
import 'package:flutter/material.dart';

class TestResultsScreen extends StatelessWidget {
  const TestResultsScreen({
    Key? key,
  }) : super(key: key);

  final title = "您的九大組織系統檢測結果";
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // TestResultsAppBar(),
        KampoSliverTitle(title: "您的九大組織系統檢測結果"),
        SliverToBoxAdapter(
          child: Center(
            child: Text(
              "請點選下方器官圖片擦看深入分析",
              style: TextStyle(fontSize: 20),
            ),
          ),
        ),
        NineSystemButtons(),
        TestStatusTips(),
        KampoSliverTitle(title: "肺部健康指數"),
        LungInfo(),
        KampoSliverTitle(title: "免疫系統指數"),
        SliverToBoxAdapter(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                child: Card(
                  child: ListTile(
                    leading: Image(
                      image: AssetImage("assets/icons/immune_system.png"),
                      width: 42,
                    ),
                    title: Text("免疫系統指數"),
                    trailing: Text("88%"),
                  ),
                ),
              )
            ],
          ),
        ),
        KampoSliverTitle(title: "細菌與微生物評估"),
        GermsAndMicroorganism(),
        KampoSliverTitle(title: "過敏原評估"),
        Allergen()
      ],
    );
  }
}
