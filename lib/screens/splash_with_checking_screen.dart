import 'dart:async';

import 'package:ai_kampo_app/api/firebase_api.dart';
import 'package:ai_kampo_app/utils/utils.dart';
import 'package:ai_kampo_app/widgets/kampo_dialog.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashWithCheckingScreen extends StatelessWidget {
  SplashWithCheckingScreen({super.key});

  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  Widget build(BuildContext context) {
    //1.Check Network
    //1-1. If network is available, then check whether  user has signed in or not.
    // 1-1-1. if user did't signed in yet → go to SignIn Screen.
    // 1-1-2. if user has sigined in → go to main screen.
    //1-2. If network is not available, then start to monitor network uitil connecting to the internet

    handleCheck(context);
    return const Image(
      fit: BoxFit.cover,
      image: AssetImage(
        "assets/images/splash_background.png",
      ),
    );
  }

  Future handleCheck(BuildContext context) async {
    print("  ======= SplashWithCheckingScreen handleCheck()");
    await Utils.isNetworkAvailable().then((res) {
      if (res) {
        // Network is available
        checkAuth();
      } else {
        KampoDialog.confirmToPop(context, "尚未連線網路！", "");
        monitorNetwork();
      }
    });
  }

  Future checkAuth() async {
    //Check sign in
    await SharedPreferences.getInstance().then((prefs) async {
      if (prefs.getString("phoneNumber") == null ||
          prefs.getString("userDocId") == null) {
        Get.toNamed("/sign.in");
      }
      await FirebaseAPI.getUserData(prefs.getString("phoneNumber")!)
          .then((res) {
        Get.offAllNamed("/main");
      }).catchError((e) {
        prefs.clear();
        Get.offAllNamed("/sign.in");
        throw e;
      });
    }).catchError((e) {
      Get.offAllNamed("/sign.in");
      throw e;
    }).catchError((e) {
      Get.offAllNamed("/sign.in");
    });
  }

  Future monitorNetwork() async {
    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) async {
      print(" ==== onConnectivityChanged ==== ");
      await Utils.isNetworkAvailable().then((res) {
        if (res) {
          _connectivitySubscription.cancel();
          checkAuth();
        } else {
          Get.offAllNamed("/splash");
        }
      });
    });
  }
}
