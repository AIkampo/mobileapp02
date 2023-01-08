//檢測結果

import 'package:ai_kampo_app/screens/clinics/clinics_screen.dart';
import 'package:ai_kampo_app/screens/constitution.assessment/constitution_assessment_screen.dart';
import 'package:ai_kampo_app/screens/healthy.guide/healthy_guide_screen.dart';
import 'package:ai_kampo_app/screens/info.center/info_center_screen.dart';
import 'package:ai_kampo_app/screens/settings/settings_screen.dart';
import 'package:ai_kampo_app/screens/sub.accounts/sub_accounts_screen.dart';
import 'package:ai_kampo_app/screens/test.results/test_results_list_screen.dart';
import 'package:ai_kampo_app/screens/test.results/test_results_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final List<BottomNavigationBarItem> _bottomNavigationBarItems = [
    BottomNavigationBarItem(
        icon: Icon(CupertinoIcons.doc_text_search), label: "檢測報告"),
    // BottomNavigationBarItem(
    //     icon: Icon(CupertinoIcons.doc_text_search), label: "檢測結果"),
    // BottomNavigationBarItem(
    //     icon: Icon(Icons.assignment_ind_outlined), label: "健康指引"),
    BottomNavigationBarItem(
        icon: Icon(CupertinoIcons.doc_richtext), label: "資訊中心"),
    BottomNavigationBarItem(
        icon: Icon(Icons.local_hospital_outlined), label: "聯盟診所"),
    BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), label: "設定"),
  ];

  List<Widget> _screens = [
    TestResultListScreen(),
    // TestResultsScreen(),
    // HealthyGuideScreen(),
    InfoCenterScreen(),
    ClinicsScreen(),
    SettingsScreen()
  ];

  int _currentIndex = 0;
  bool _isMainAccount = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF7890C8),
        toolbarHeight: 82,
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            _isMainAccount
                ? _showAccountMenu()
                : Get.to(() => ConstitutionAssessmentScreen());

            //      // ConstitutionCardScreen()
            //     //TestingScreen() //SubscribeScreen(),
            //     );
          },
          child: Image.asset(
            "assets/icons/detection.png",
          ),
        ),
        title: Image.asset(
          "assets/images/logo.png",
          scale: 1.5,
        ),
        actions: [
          IconButton(
              onPressed: () {
                Get.to(() => SubAccountsScreen());
              },
              icon: Icon(
                CupertinoIcons.person_3_fill,
                color: Colors.white,
              ))
        ],
      ),
      body: SafeArea(child: _screens[_currentIndex]),
      backgroundColor: Colors.grey[100],
      bottomNavigationBar: BottomNavigationBar(
        items: _bottomNavigationBarItems,
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) {
          if (_currentIndex != index)
            setState(() {
              _currentIndex = index;
            });
        },
      ),
    );
  }

  void _showAccountMenu() {
    showCupertinoModalPopup(
      context: context,
      builder: ((BuildContext context) => CupertinoActionSheet(
            title: Text("請選擇檢測帳號"),
            cancelButton: CupertinoActionSheetAction(
              child: Text("Cancel"),
              onPressed: () {
                Get.back();
              },
              isDestructiveAction: true,
            ),
            actions: <CupertinoActionSheetAction>[
              CupertinoActionSheetAction(
                onPressed: () {
                  Get.to(() => ConstitutionAssessmentScreen());
                },
                child: Text("主帳號"),
                isDefaultAction: true,
              ),
              CupertinoActionSheetAction(
                  onPressed: () {
                    Get.to(() => ConstitutionAssessmentScreen());
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.male_outlined,
                        color: Colors.blue,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text("黃大明"),
                      Expanded(child: Text('')),
                      Text('0912345677')
                    ],
                  )),
              CupertinoActionSheetAction(
                  onPressed: () {
                    Get.to(() => ConstitutionAssessmentScreen());
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.male,
                        color: Colors.blue,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text("黃小明"),
                      Expanded(child: Text('')),
                      Text('0912345678')
                    ],
                  )),
              CupertinoActionSheetAction(
                  onPressed: () {
                    Get.to(() => ConstitutionAssessmentScreen());
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.female,
                        color: Colors.red,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text("黃小媚"),
                      Expanded(child: Text('')),
                      Text('0912345679')
                    ],
                  )),
            ],
          )),
    );
  }
}
