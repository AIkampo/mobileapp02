import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplahScreen extends StatelessWidget {
  const SplahScreen({super.key});

  @override
  Widget build(BuildContext context) {
    checkAuth();
    return const Image(
      fit: BoxFit.cover,
      image: AssetImage(
        "assets/images/splash_background.png",
      ),
    );
  }

  Future<void> checkAuth() async {
    print("********checkAuth()");

    final prefs = await SharedPreferences.getInstance();

    print(
        "********prefs.getString(phoneNumber)!:${prefs.getString("phoneNumber") != null}");
    print("********prefs.getString(userDocId):${prefs.getString("userDocId")}");

    Timer(const Duration(seconds: 1), () {
      Get.toNamed(prefs.getString("phoneNumber") != null &&
              prefs.getString("userDocId") != null
          ? "/main"
          : "/sign.in");
    });
  }
}
