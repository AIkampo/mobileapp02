import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:ai_kampo_app/api/firebase_api.dart';
import 'package:ai_kampo_app/controller/account_controller.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../widgets/common/progress_loading.dart';
import '../../../widgets/kampo_dialog.dart';


class ServiceAgreementScreen extends StatefulWidget {
  const ServiceAgreementScreen({super.key});

  @override
  State<ServiceAgreementScreen> createState() => _ServiceAgreementScreenState();
}

class _ServiceAgreementScreenState extends State<ServiceAgreementScreen> {
  final AccountController _accountController = Get.find<AccountController>();
  bool _agreeServiceAgreement = false;

  Future<void> redirectServiceTerm() async {
    String urlLink = "https://www.aikampo.com/home/%e3%80%90%e9%97%9c%e6%96%bc%e6%88%91%e5%80%91%e3%80%91/%e9%9a%b1%e7%a7%81%e6%ac%8a/";
    Uri url = Uri.parse(urlLink);
    if (!await launchUrl(url)) {
      if (mounted) {
        KampoDialog.confirmToPop(context, "無法開啟連結", "無法開啟連結");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          const Expanded(child: Divider(color: Colors.transparent)),
          TextButton(
            onPressed: redirectServiceTerm,
            child: const Text("服務條款連結", style: TextStyle(fontSize: 20)),
          ),
          const Expanded(child: Divider(color: Colors.transparent)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    _agreeServiceAgreement = !_agreeServiceAgreement;
                  });
                },
                icon: Icon(
                  _agreeServiceAgreement?
                    Icons.check_circle_outline: Icons.circle_outlined
                ),
              ),
              const Text("同意AI Kampo服務協議"),
            ],
          ),
          const Divider(color: Colors.transparent, height: 15),
          Container(
            padding: const EdgeInsets.all(20),
            width: double.infinity,
            child: CupertinoButton.filled(
              child: Text("確認"),
              onPressed: () {
                if (!_agreeServiceAgreement) {
                  _showAlertDialog();
                } else {
                  confirmAgreement();
                }
              },
            ),
          )
        ],
      ),
    );
  }

  void confirmAgreement() async {
    Future updateTask = _accountController.updateUserData(
      uid: _accountController.userId.value,
      agreeServiceAgreement: true,
    );
    await Get.dialog(ProgressLoadingPage(task: updateTask));
    String? errMessage = await updateTask;
    if (errMessage != null) {
      if (mounted) await KampoDialog.confirmToPop(context, '', errMessage);
    }
    else {
      Get.offAndToNamed("/main");
    }
  }

  void _showAlertDialog() {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('同意AI Kampo服務協議才可使用本APP的檢測功能！'),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            /// This parameter indicates this action is the default,
            /// and turns the action's text to bold text.
            isDefaultAction: true,
            onPressed: () {
              confirmAgreement();
            },
            child: Text('同意'),
          ),
          CupertinoDialogAction(
            child: Text("先使用"),
            onPressed: () {
              Get.offAndToNamed("/main");
            },
            textStyle: TextStyle(color: Colors.grey),
          )
        ],
      ),
    );
  }
}
