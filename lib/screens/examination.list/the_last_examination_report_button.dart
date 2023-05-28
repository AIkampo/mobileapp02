import 'package:ai_kampo_app/common/config.dart';
import 'package:ai_kampo_app/common/function.dart';
import 'package:ai_kampo_app/controller/examination_list_controller.dart';
import 'package:ai_kampo_app/screens/examination.report/examination_report_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TheLastExaminationReportButton extends StatelessWidget {
  TheLastExaminationReportButton({
    Key? key,
  }) : super(key: key);

  final _examinationListController = Get.find<ExaminationListController>();
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(() => ExaminationReportScreen(),
            arguments: {"caseId": _examinationListController.theLastCaseId.value});
      },
      child: Container(
        margin: const EdgeInsets.only(top: 10, left: 22, right: 22),
        height: 88,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(3)),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF9AB8D9),
              Color(0xFFE3D7E2),
            ],
          ),
        ),
        child: Card(
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  CupertinoIcons.doc_text,
                  size: 60,
                  color: KampoColors.primary,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "最新報告",
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 6,
                        color: KampoColors.primary,
                      ),
                    ),
                    Text(
                        "檢測日期：${caseIdToDatetime(_examinationListController.theLastCaseId.toString())}")
                  ],
                ),
                const Icon(Icons.arrow_forward_ios)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
