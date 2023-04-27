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
    print(
        " ****************  _examinationReportController :${_examinationReportController.userProfile['username']}");
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
                  caseIdToDatetime(
                      _examinationReportController.reportCaseId.value),
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
                      _examinationReportController.userProfile['sex'] == "M"
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
                        _examinationReportController.userProfile['username'],
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
                        '${UserProfile.bloodTypeList[int.parse(_examinationReportController.userProfile['bloodType'])]}型',
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
                        DateFormat("yyyy/MM/dd").format(
                            DateTime.fromMillisecondsSinceEpoch(
                                _examinationReportController
                                    .userProfile['birthday'])),
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
  }
}
