import 'package:ai_kampo_app/widgets/kampo_dialog.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

Future<bool> checkNetwork(BuildContext context) async {
  var connResult = await Connectivity().checkConnectivity();
  if (connResult == ConnectivityResult.none) {
    KampoDialog.confirmToPop(context, '', '請檢查手機是否有網路連線');
    return false;
  } else {
    return true;
  }
}
