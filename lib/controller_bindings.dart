import 'package:ai_kampo_app/controller/auth.controller.dart';
import 'package:ai_kampo_app/screens/healthy.guide/healthy_guide_controller.dart';
import 'package:ai_kampo_app/screens/test.results/test_results_controller.dart';
import 'package:get/get.dart';

class ControllerBindings extends Bindings {
  @override
  void dependencies() {
    Get.put<TestResultsController>(TestResultsController());
    Get.put<HealthyGuideController>(HealthyGuideController());
    Get.put<AuthController>(AuthController());
  }
}
