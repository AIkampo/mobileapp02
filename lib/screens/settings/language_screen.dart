import 'package:ai_kampo_app/common/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("selectLanguage".tr),
        centerTitle: true,
      ),
      body: ListView.separated(
          itemCount: KampoConfig.localeList.length,
          separatorBuilder: (context, index) {
            return Divider();
          },
          itemBuilder: (context, index) {
            return ListTile(
              title: Text("${KampoConfig.localeList[index]['name']}".tr),
              trailing: IconButton(
                  onPressed: () {
                    Get.updateLocale(KampoConfig.localeList[index]['locale']);
                  },
                  icon: Icon(KampoConfig.localeList[index]['key'] ==
                          Get.locale.toString()
                      ? Icons.check_circle
                      : Icons.circle_outlined)),
            );
          }),
    );
  }
}
