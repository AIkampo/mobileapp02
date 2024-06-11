import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import 'package:ai_kampo_app/utils/utils.dart';
import 'package:ai_kampo_app/widgets/kampo_dialog.dart';
import 'package:ai_kampo_app/controller/account_controller.dart';


class SplashWithCheckingScreen extends StatefulWidget {
  const SplashWithCheckingScreen({super.key});

  @override
  State<SplashWithCheckingScreen> createState() => _SplashWithCheckingScreenState();
}

class _SplashWithCheckingScreenState extends State<SplashWithCheckingScreen> {
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  final _accountController = Get.find<AccountController>();

  @override
  void initState() {
    super.initState();
    //1.Check Network
    //1-1. If network is available, then check whether  user has signed in or not.
    // 1-1-1. if user did't signed in yet → go to SignIn Screen.
    // 1-1-2. if user has sigined in → go to main screen.
    //1-2. If network is not available, then start to monitor network uitil connecting to the internet
    handleCheck();
  }

  @override
  Widget build(BuildContext context) {
    return const Image(
      fit: BoxFit.cover,
      image: AssetImage(
        "assets/images/splash_background.png",
      ),
    );
  }

  Future handleCheck() async {
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
    await _accountController.refreshAll();
    if (_accountController.userLoggedIn.value) {
      Get.offAllNamed("/main");
    }
    else {
      Get.toNamed("/sign.in");
    }
  }

  Future monitorNetwork() async {
    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen((ConnectivityResult result) async {
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
