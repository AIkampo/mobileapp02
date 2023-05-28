import 'package:ai_kampo_app/controller/account_controller.dart';
import 'package:ai_kampo_app/controller/add_sub_account_controller.dart';
import 'package:ai_kampo_app/controller/auth.controller.dart';
import 'package:ai_kampo_app/controller/examination_list_controller.dart';
import 'package:ai_kampo_app/controller/examination_report_controller.dart';
import 'package:ai_kampo_app/controller/headset_list_controller.dart';
import 'package:ai_kampo_app/controller/healthy_guidance_controller.dart';
import 'package:ai_kampo_app/controller/physical_examination_controller.dart';
import 'package:ai_kampo_app/controller/tcm_nine_constitutions_controller.dart';
import 'package:get/get.dart';

class ControllerBindings extends Bindings {
  @override
  void dependencies() {
    Get.put<AccountController>(AccountController());
    Get.put<AuthController>(AuthController());
    Get.put<ExaminationReportController>(ExaminationReportController());
    Get.put<HealthyGuidanceController>(HealthyGuidanceController());
    Get.put<ExaminationListController>(ExaminationListController());
    Get.put<AddSubAccountController>(AddSubAccountController());
    Get.put<PhysicalExaminationController>(PhysicalExaminationController());
    Get.put<HeadsetListContorller>(HeadsetListContorller());
    Get.put<TcmNineConstitutionsController>(TcmNineConstitutionsController());
  }
}
