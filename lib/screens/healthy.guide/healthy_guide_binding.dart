import 'package:ai_kampo_app/screens/healthy.guide/healthy_guide_controller.dart';
import 'package:get/get.dart';

class HealthyGuideBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<HealthyGuideController>(HealthyGuideController());
  }
}
