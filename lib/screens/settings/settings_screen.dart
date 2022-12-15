import 'package:ai_kampo_app/screens/settings/intelligent_customer_service_screen.dart';
import 'package:ai_kampo_app/screens/settings/contact_us_screen.dart';
import 'package:ai_kampo_app/screens/settings/faq_screen.dart';
import 'package:ai_kampo_app/screens/settings/language_screen.dart';
import 'package:ai_kampo_app/screens/settings/modify_password_screen.dart';
import 'package:ai_kampo_app/screens/settings/profile_screen.dart';
import 'package:ai_kampo_app/screens/settings/user_guide_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  List menuList = [
    {
      "title": "userProfile",
      "icon": CupertinoIcons.person_crop_circle,
      "screen": () => ProfileScreen()
    },
    {
      "title": "resetPassword",
      "icon": CupertinoIcons.lock_shield,
      "screen": () => ModifyPasswordScreen()
    },
    {
      "title": "faq",
      "icon": CupertinoIcons.question_circle,
      "screen": () => FAQ_SCREEN()
    },
    {
      "title": "manual",
      "icon": Icons.auto_stories_outlined,
      "screen": () => UserGuideScreen()
    },
    {
      "title": "contactUs",
      "icon": Icons.phone_in_talk_outlined,
      "screen": () => ContactUsScreen()
    },
    {
      "title": "chatCustomerService",
      "icon": Icons.forum_outlined,
      "screen": () => IntelligentCustomerServiceScreen()
    },
    {
      "title": "language",
      "icon": Icons.g_translate,
      "screen": () => LanguageScreen()
    },
    {"title": "signOut", "icon": Icons.logout, "screen": "/sign.in"},
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: menuList.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 8),
            child: Card(
              child: ListTile(
                  contentPadding: EdgeInsets.all(5),
                  leading: Icon(
                    menuList[index]['icon'],
                    size: 36,
                  ),
                  title: Text("${menuList[index]['title']}".tr),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    if (menuList[index]["screen"] is String)
                      Get.offAllNamed("/sign.in");
                    else
                      Get.to(menuList[index]["screen"]);
                  }),
            ),
          );
        });
  }
}
