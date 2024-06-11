
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:ai_kampo_app/models/nine_system_model.dart';
import 'package:ai_kampo_app/common/config.dart';
import 'package:ai_kampo_app/controller/examination_report_controller.dart';
import 'package:ai_kampo_app/models/link_metadata.dart';


class AnalysisReport extends StatefulWidget {
  const AnalysisReport({super.key});

  @override
  State<AnalysisReport> createState() => _AnalysisReportState();
}

class _AnalysisReportState extends State<AnalysisReport> {
  final _examinationReportController = Get.find<ExaminationReportController>();
  late NineSystemModel organData;

  @override
  void initState() {
    super.initState();
    organData = Get.arguments['organData'];
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      List<LinkMetaData> linkData =
        _examinationReportController.linkListState[organData.indexName]!.data;
      return SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(((context, index) {
            return Card(
              child: ListTile(
                title: TextButton(
                  onPressed: () async {
                    final Uri url = Uri.parse(linkData[index].link);
                    if (!await launchUrl(url)) {
                      Get.snackbar("失敗", "無法開啟網址連結");
                      throw Exception(
                        "Could not launch ${linkData[index].link}");
                    }
                  },
                  child: Obx(() {
                    return Text(
                      linkData[index].title, style: const TextStyle(fontSize: 20),
                    );
                  }),
                ),
              ),
            );
          }), childCount: linkData.length),
        ),
      );
    });
  }
}
