import 'package:ai_kampo_app/controller/auth.controller.dart';
import 'package:ai_kampo_app/controller/examination_list_controller.dart';
import 'package:ai_kampo_app/controller/examination_report_controller.dart';
import 'package:ai_kampo_app/controller/healthy_guidance_controller.dart';
import 'package:ai_kampo_app/screens/test.results/test_results_controller.dart';
import 'package:get/get.dart';

class ControllerBindings extends Bindings {
  @override
  void dependencies() {
    Get.put<TestResultsController>(TestResultsController());
    Get.put<AuthController>(AuthController());
    Get.put<ExaminationReportController>(ExaminationReportController());
    Get.put<HealthyGuidanceController>(HealthyGuidanceController());
    Get.put<ExaminationListController>(ExaminationListController());
  }
}
