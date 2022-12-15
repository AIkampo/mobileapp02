import 'package:ai_kampo_app/screens/healthy.guide/acupuncture_screen.dart';
import 'package:ai_kampo_app/screens/healthy.guide/color_screen.dart';
import 'package:ai_kampo_app/screens/healthy.guide/diet_screen.dart';
import 'package:ai_kampo_app/screens/healthy.guide/gem_screen.dart';
import 'package:ai_kampo_app/screens/healthy.guide/nutrients_screen.dart';
import 'package:ai_kampo_app/screens/test.results/allergen.dart';
import 'package:ai_kampo_app/screens/test.results/germs_microorganism.dart';
import 'package:ai_kampo_app/screens/test.results/lung_info.dart';
import 'package:ai_kampo_app/screens/test.results/nine_system_buttons.dart';
import 'package:ai_kampo_app/screens/test.results/test_status_tips.dart';
import 'package:ai_kampo_app/widgets/common/KampoTitle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TestingReportScreen extends StatefulWidget {
  const TestingReportScreen({super.key});

  @override
  State<TestingReportScreen> createState() => _TestingReportScreenState();
}

class _TestingReportScreenState extends State<TestingReportScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 77,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Card(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "檢測日期",
                          style: TextStyle(color: Colors.red, fontSize: 18),
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Text(
                          " 2022/11/22",
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "王小明  男  O型",
                            style: TextStyle(fontSize: 22),
                          ),
                          Text(
                            "生日 1989/08/09",
                            style: TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // actions: [
            //   Card(
            //     child: Column(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: [
            //         Container(
            //             padding: EdgeInsets.all(5),
            //             color: Colors.red,
            //             child: Text("檢測日期")),
            //         SizedBox(
            //           height: 6,
            //         ),
            //         Text(" 2022/11/22"),
            //       ],
            //     ),
            //   )
            // ],
            bottom: TabBar(tabs: [
              Tab(
                // icon: Icon(CupertinoIcons.doc_text_search),
                text: "檢測結果",
              ),
              Tab(
                // icon: Icon(Icons.assignment_ind_outlined),
                text: "健康指引",
              )
            ]),
          ),
          body: TabBarView(
            children: [
              TestResultView(),
              HealthyGuideView(),
            ],
          )),
    );
  }
}

class HealthyGuideView extends StatelessWidget {
  HealthyGuideView({
    Key? key,
  }) : super(key: key);
  final List dataList = [
    {
      "screen": () => DietScreen(),
      "title": "健康飲食指引",
      "icon": "assets/icons/diet.png"
    },
    {
      "screen": () => NutrientsScreen(),
      "title": "微量營養素指引",
      "icon": "assets/icons/nutrients.png"
    },
    {
      "screen": () => ColorScreen(),
      "title": "正能量顔色指引",
      "icon": "assets/icons/color.png"
    },
    {
      "screen": () => AcupunctureScreen(),
      "title": "能量針灸指引",
      "icon": "assets/icons/acupuncture.png"
    },
    {
      "screen": () => GemScreen(),
      "title": "能量寶石指引",
      "icon": "assets/icons/gem.png"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
            padding: EdgeInsets.all(12),
            sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate((context, index) {
                  return InkWell(
                    onTap: () {
                      Get.to(dataList[index]['screen']);
                    },
                    child: Card(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Image.asset(dataList[index]['icon']),
                          ),
                          Text(dataList[index]['title'])
                        ],
                      ),
                    ),
                  );
                }, childCount: dataList.length),
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 170,
                    mainAxisSpacing: 6,
                    crossAxisSpacing: 6,
                    childAspectRatio: 1)))
      ],
    );
  }
}

class TestResultView extends StatelessWidget {
  const TestResultView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // ReportProfile(),
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

class ReportProfile extends StatelessWidget {
  ReportProfile({
    Key? key,
  }) : super(key: key);

  List dataList = [
    {"title": "檢測日期", "value": "2022/11/22"},
    {"title": "名   字", "value": "王小明"},
    {"title": "生   日", "value": "1989/08/09"},
    {"title": "性   別", "value": "男"},
    {"title": "血   型", "value": "O"},
  ];

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.all(20),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          return Card(
            child: ListTile(
                title: Text(
                  "${dataList[index]["title"]}",
                ),
                trailing: Text(
                  "${dataList[index]["value"]}",
                )),
          );
        }, childCount: dataList.length),
      ),
    );
  }
}
