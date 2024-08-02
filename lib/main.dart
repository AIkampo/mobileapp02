import 'package:ai_kampo_app/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'firebase_options.dart';
import 'package:ai_kampo_app/controller/initial_bindings.dart';
import 'package:ai_kampo_app/generated/locales.g.dart';
import 'package:ai_kampo_app/screens/auth/sign.up/service_agreement_screen.dart';
import 'package:ai_kampo_app/screens/auth/sign.up/sign_up_steps_screen.dart';
import 'package:ai_kampo_app/screens/auth/sign_in_screen.dart';
import 'package:ai_kampo_app/screens/common/loading_screen.dart';
import 'package:ai_kampo_app/screens/info.center/my.points/my_points_screen.dart';
import 'package:ai_kampo_app/screens/main/main_screen.dart';
import 'package:ai_kampo_app/screens/headset.connection/headset_connection_screen.dart';
import 'package:ai_kampo_app/screens/physical.examination/examination_tips_screen.dart';
import 'package:ai_kampo_app/screens/splash_with_checking_screen.dart';
import 'package:ai_kampo_app/screens/sub.accounts/sub_accounts_screen.dart';
import 'package:ai_kampo_app/screens/examination.report/examination_report_screen.dart';
import 'package:ai_kampo_app/screens/subscribe/subscribe_screen.dart';
import 'package:ai_kampo_app/tcm.nine.constitutions/tcm_nine_constitutions_screen.dart';import 'package:ai_kampo_app/screens/physical.examination/confirm_points.dart';
import 'package:ai_kampo_app/screens/sub.accounts/add.sub.account.temp/add_sub_account.dart';


Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // for emulators
  // await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  // FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
  // String host = defaultTargetPlatform == TargetPlatform.android?
  // '10.0.2.2' : 'localhost'; // Switch host based on platform.
  // FirebaseFirestore.instance.settings = Settings(
  //   host: '$host:8080', sslEnabled: false, persistenceEnabled: false
  // );
  // FirebaseFunctions.instanceFor(region: 'asia-east1')
  //   .useFunctionsEmulator(host, 5001);
  // await FirebaseStorage.instance.useStorageEmulator(host, 9199);

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
      theme: kampoTheme,
      initialBinding: InitialBindings(),
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
        GetPage(name: "/service.agreement", page: () => const ServiceAgreementScreen()),
        GetPage(name: "/sub.accounts", page: () => const SubAccountsScreen()),
        GetPage(name: "/add.sub.account", page: () => const AddSubAccountStepsScreen()),
        GetPage(name: "/headset.connection", page: () => const HeadsetConnectionScreen()),
        GetPage(name: "/examination.report", page: () => ExaminationReportScreen()),
        GetPage(name: "/examination.tips", page: () => ExaminationTipsScreen()),
        GetPage(name: "/confirm.points", page: () => ConfirmPointScreen()),
        GetPage(name: "/tcm.nine.constitutions", page: () => const TcmNineConstitutionsScreen()),
      ],
      translationsKeys: AppTranslation.translations,
      locale: const Locale('zh', 'TW'),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}
