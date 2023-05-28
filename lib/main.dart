import 'package:ai_kampo_app/controller/controller_bindings.dart';
import 'package:ai_kampo_app/generated/locales.g.dart';
import 'package:ai_kampo_app/screens/auth/sign.up/service_agreement_screen.dart';
import 'package:ai_kampo_app/screens/auth/sign.up/sign_up_steps_screen.dart';
import 'package:ai_kampo_app/screens/auth/sign_in_screen.dart';
import 'package:ai_kampo_app/screens/auth/verify_code_screen.dart';
import 'package:ai_kampo_app/screens/common/loading_screen.dart';
import 'package:ai_kampo_app/screens/healthy.guidance/healthy_guide_screen.dart';
import 'package:ai_kampo_app/screens/info.center/my.points/my_points_screen.dart';
import 'package:ai_kampo_app/screens/main/main_screen.dart';
import 'package:ai_kampo_app/screens/headset.connection/headset_connection_screen.dart';
import 'package:ai_kampo_app/screens/physical.examination/examination_tips_screen.dart';
import 'package:ai_kampo_app/screens/splash_with_checking_screen.dart';
import 'package:ai_kampo_app/screens/sub.accounts/add.sub.account/add_sub_account_steps_screen.dart';
import 'package:ai_kampo_app/screens/sub.accounts/sub_accounts_screen.dart';
import 'package:ai_kampo_app/screens/examination.report/examination_report_screen.dart';
import 'package:ai_kampo_app/screens/subscribe/subscribe_screen.dart';
import 'package:ai_kampo_app/tcm.nine.constitutions/tcm_nine_constitutions_screen.dart';
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

  runApp(const AIKampoApp());
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
          primary: const Color(0xFF7890C8),
          secondary: const Color(0xFFB6ADDE),
        ),
      ),
      initialBinding: ControllerBindings(),
      initialRoute: "/splash",
      getPages: [
        GetPage(
          name: "/splash",
          page: () => SplashWithCheckingScreen(),
        ),
        GetPage(name: "/sign.in", page: () => const SignInScreen()),
        GetPage(name: "/sign.up", page: () => SignUpStepsScreen()),
        GetPage(
          name: "/main",
          page: () => const MainScreen(),
        ),
        GetPage(
          name: "/my.points",
          page: () => const MyPointsScreen(),
        ),
        GetPage(name: "/subscribe", page: () => const SubscribeScreen()),
        GetPage(name: "/loading", page: () => const LoadingScreen()),
        GetPage(name: "/healthy.guide", page: () => const HealthyGuideScreen()),
        GetPage(name: "/verify.code", page: () => VerifyCodeScreen()),
        GetPage(name: "/service.agreement", page: () => const ServiceAgreementScreen()),
        GetPage(name: "/sub.accounts", page: () => const SubAccountsScreen()),
        GetPage(name: "/add.sub.account", page: () => AddSubAccountStepsScreen()),
        GetPage(name: "/headset.connection", page: () => const HeadsetConnectionScreen()),
        GetPage(name: "/examination.report", page: () => ExaminationReportScreen()),
        GetPage(name: "/examination.tips", page: () => ExaminationTipsScreen()),
        GetPage(name: "/tcm.nine.constitutions", page: () => const TcmNineConstitutionsScreen())
      ],

      translationsKeys: AppTranslation.translations,
      locale: const Locale('zh', 'TW'),
      localizationsDelegates: const [FormBuilderLocalizations.delegate],

    );
  }
}
