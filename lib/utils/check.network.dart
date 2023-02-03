import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

Future<bool> checkNetwork() async {
  var connResult = await Connectivity().checkConnectivity();
  if (connResult == ConnectivityResult.none) {
    Get.snackbar("沒有網路", "請檢查手機是否有網路連線");
    return false;
  } else {
    return true;
  }
}
