import 'package:ai_kampo_app/api/firebase_api.dart';
import 'package:ai_kampo_app/controller/examination_list_controller.dart';
import 'package:ai_kampo_app/screens/examination.list/history_examination_list.dart';
import 'package:ai_kampo_app/screens/examination.list/the_last_examination_report_button.dart';
import 'package:ai_kampo_app/widgets/common/accounts_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExaminationListScreen extends StatelessWidget {
  ExaminationListScreen({super.key});

  final bool _isMainAccount = true;
  final _controller = Get.find<ExaminationListController>();

  @override
  Widget build(BuildContext context) {
    print("=================== ExaminationListScreen");

    handleGetData();
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _isMainAccount ? AccountsDropdown() : SizedBox.shrink(),
            TheLastExaminationReportButton(),
            HistoryExaminationList(),
          ],
        ),
      ),
    );
  }

  Future<void> handleGetData() async {
    final prefs = await SharedPreferences.getInstance();
    final phoneNumber = prefs.getString('phoneNumber');
    final String userDocId = prefs.getString('userDocId')!;

    await FirebaseAPI.getUserDataWithDocId(userDocId)
        .then((res) => _controller.setUserProfile(res));

    _controller.fetchExaminationList(phoneNumber.toString());
  }
}
