import 'package:connectivity_plus/connectivity_plus.dart';

class Utils {
  static Future<bool> isNetworkAvailable() async {
    return await Connectivity()
        .checkConnectivity()
        .then((res) => res != ConnectivityResult.none);
  }
}
