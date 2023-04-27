import 'package:ai_kampo_app/api/firebase_api.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountController extends GetxController {
  final isLoading = true.obs;
  //使用者本人（登入者）手機號碼
  final userPhoneNumber = "".obs;
  final isMainAccount = false.obs;
  final subAccounts = [].obs;
  final selectedPhoneNumber = "".obs;

  removeData() {
    print('(((((((((((((((((((((((( AccountController - initData()  ))))))))))))))))))))))))');
    isLoading.value = true;
    userPhoneNumber.value = "";
    isMainAccount.value = false;
    subAccounts.clear();
    selectedPhoneNumber.value = "";
  }

  Future initData() async {
    print("%%%%%%%%%%% AccountController initData()");
    print("   -------------     selectedPhoneNumber.value:${selectedPhoneNumber.value}");

    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString('phoneNumber') == null || prefs.getString('userDocId') == null) {
      Get.offAllNamed("/sign.in");
    } else {
      userPhoneNumber.value = prefs.getString('phoneNumber')!;
      isMainAccount.value = prefs.getBool('isMainAccount')!;
      if (isMainAccount.value) {
        getSubAccounts(prefs.getString('phoneNumber')!);
      } else {
        isLoading.value = false;
      }
    }
  }

  Future getSubAccounts(String phoneNumber) async {
    print("%%%%%%%%%%% AccountController getSubAccounts()");
    isLoading.value = true;
    await FirebaseAPI.getSubAccounts(phoneNumber).then((res) {
      subAccounts.value = res;
    }).whenComplete(() => isLoading.value = false);
  }
}
