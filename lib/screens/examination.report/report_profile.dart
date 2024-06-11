import 'package:ai_kampo_app/common/config.dart';
import 'package:ai_kampo_app/common/function.dart';
import 'package:ai_kampo_app/controller/examination_report_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ReportProfile extends StatelessWidget {
  ReportProfile({
    Key? key,
  }) : super(key: key);

  final _examinationReportController = Get.find<ExaminationReportController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (_examinationReportController.isUserProfileLoading.value) {
        return const Card(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 6),
            child: SizedBox(
              width: double.infinity,
              child: Text("載入個人資料中...")
            )
          ),
        );
      }
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "檢測日期",
                    style: TextStyle(color: Colors.red, fontSize: 22),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Text(
                    caseIdToDatetime(_examinationReportController.reportCaseId.value),
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        _examinationReportController.sex.value == "M"
                            ? Icon(
                                Icons.man,
                                color: Colors.blue,
                              )
                            : Icon(
                                Icons.woman,
                                color: Colors.red,
                              ),
                        SizedBox(
                          width: 2,
                        ),
                        Text(
                          _examinationReportController.name.value,
                          style: TextStyle(fontSize: 22),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Icon(
                          Icons.bloodtype,
                          color: Colors.red,
                        ),
                        Text(
                          '${_examinationReportController.bloodGroup.value}型',
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Icon(
                          Icons.cake,
                          color: Colors.pink,
                        ),
                        Text(
                          _examinationReportController.birth.value,
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}
