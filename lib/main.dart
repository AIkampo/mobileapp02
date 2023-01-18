import 'package:ai_kampo_app/controller_bindings.dart';
import 'package:ai_kampo_app/generated/locales.g.dart';
import 'package:ai_kampo_app/screens/auth/sign.up/check_phone_number_screen.dart';
import 'package:ai_kampo_app/screens/auth/sign.up/service_agreement_screen.dart';
import 'package:ai_kampo_app/screens/auth/sign.up/sign_up_steps_screen.dart';
import 'package:ai_kampo_app/screens/auth/sign_in_screen.dart';
import 'package:ai_kampo_app/screens/auth/verify_code_screen.dart';
import 'package:ai_kampo_app/screens/common/loading_screen.dart';
import 'package:ai_kampo_app/screens/healthy.guide/healthy_guide_screen.dart';
import 'package:ai_kampo_app/screens/info.center/my.points/my_points_screen.dart';
import 'package:ai_kampo_app/screens/main_screen.dart';
import 'package:ai_kampo_app/screens/headset.connection/headset_connection_screen.dart';

import 'package:ai_kampo_app/screens/splash_screen.dart';
import 'package:ai_kampo_app/screens/sub.accounts/add_sub_account_screen.dart';
import 'package:ai_kampo_app/screens/subscribe/payment/payment_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await Firebase.initializeApp();
  runApp(AIKampoApp());
}

class AIKampoApp extends StatelessWidget {
  const AIKampoApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: '智能漢方',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Color(0xFF7890C8),
          secondary: Color(0xFFB6ADDE),
        ),
      ),
      initialBinding: ControllerBindings(),
      initialRoute: "/splash",
      getPages: [
        GetPage(
          name: "/splash",
          page: () => SplahScreen(),
        ),
        GetPage(name: "/sign.in", page: () => SignInScreen()),
        GetPage(name: "/sign.up", page: () => SignUpStepsScreen()),
        GetPage(
            name: "/sign.up.check.phone", page: () => CheckPhoneNumberScreen()),
        GetPage(
          name: "/main",
          page: () => MainScreen(),
        ),
        GetPage(
          name: "/my.points",
          page: () => MyPointsScreen(),
        ),
        GetPage(name: "/payment", page: () => PaymentScreen()),
        GetPage(name: "/loading", page: () => LoadingScreen()),
        GetPage(name: "/healthy.guide", page: () => HealthyGuideScreen()),
        // GetPage(
        //   name: "/headset.connecting",
        //   page: () => HeadsetConnectingScreen(),
        // ),
        GetPage(name: "/verify.code", page: () => VerifyCodeScreen()),
        GetPage(
            name: "/service.agreement", page: () => ServiceAgreementScreen()),
        GetPage(name: "/add.sub.account", page: () => AddSubAccountScreen()),
        GetPage(
            name: "/headset.connection", page: () => HeadsetConnectionScreen())
      ],
      translationsKeys: AppTranslation.translations,
      locale: Locale('zh', 'TW'),
      localizationsDelegates: [FormBuilderLocalizations.delegate],

      //SplahScreen()
    );
  }
}
