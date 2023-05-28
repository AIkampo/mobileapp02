//歷史報告 頁面
import 'package:flutter/material.dart';

import 'package:syncfusion_flutter_calendar/calendar.dart';

class HistoryReportScreen extends StatefulWidget {
  const HistoryReportScreen({super.key});

  @override
  State<HistoryReportScreen> createState() => _HistoryReportScreenState();
}

class _HistoryReportScreenState extends State<HistoryReportScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(" 歷史報告"),
        ),
        body: SfCalendar(
          view: CalendarView.month,
          showDatePickerButton: true,
        ));
  }
}
