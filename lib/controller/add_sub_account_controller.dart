import 'package:get/get.dart';

class AddSubAccountController extends GetxController {
  final currentStep = 0.obs;
  final phoneNumber = "".obs;
  initData() {
    currentStep.value = 0;
    phoneNumber.value = "";
  }
}
