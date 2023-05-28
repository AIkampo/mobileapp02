import 'package:ai_kampo_app/common/config.dart';
import 'package:ai_kampo_app/controller/account_controller.dart';
import 'package:ai_kampo_app/screens/clinics/clinics_webview_screen.dart';
import 'package:ai_kampo_app/screens/examination.list/examination_list_screen.dart';
import 'package:ai_kampo_app/screens/info.center/info_center_screen.dart';
import 'package:ai_kampo_app/screens/main/examination_button.dart';
import 'package:ai_kampo_app/screens/main/subaccounts_button.dart';
import 'package:ai_kampo_app/screens/settings/settings_screen.dart';
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
    const BottomNavigationBarItem(icon: Icon(CupertinoIcons.doc_text_search), label: "檢測報告"),
    const BottomNavigationBarItem(icon: Icon(CupertinoIcons.doc_richtext), label: "資訊中心"),
    const BottomNavigationBarItem(icon: Icon(Icons.local_hospital_outlined), label: "聯盟診所"),
    const BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), label: "設定"),
  ];

  final List<Widget> _screens = [
    ExaminationListScreen(),
    const InfoCenterScreen(),
    const ClinicsWebviewScreen(),
    const SettingsScreen()
  ];

  final _currentIndex = 0.obs;
  final _accountController = Get.find<AccountController>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _accountController.initData();

    return Scaffold(
        appBar: AppBar(
          backgroundColor: KampoColors.primary,
          toolbarHeight: 82,
          centerTitle: true,
          leading: ExaminationButton(),
          title: Image.asset(
            "assets/images/logo.png",
            scale: 1.5,
          ),
          actions: [SubAccountsButton()],
        ),
        body: Obx(() => SafeArea(child: _screens[_currentIndex.value])),
        backgroundColor: Colors.grey[100],
        bottomNavigationBar: Obx(
          () => BottomNavigationBar(
            items: _bottomNavigationBarItems,
            type: BottomNavigationBarType.fixed,
            currentIndex: _currentIndex.value,
            onTap: (index) {
              if (_currentIndex.value != index) {
                _currentIndex.value = index;
              }
            },
          ),
        ));
  }
}
