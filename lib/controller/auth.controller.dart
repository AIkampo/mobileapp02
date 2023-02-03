import 'package:get/get.dart';

class AuthController extends GetxController {
  var isLoading = false.obs;
  var isAvailablePhoneNumber = false.obs;
  var signUpCurrentStep = 0.obs;
  //暫存已驗證、未註冊之手機號碼
  var signUpPhoneNumber = ''.obs;
}
