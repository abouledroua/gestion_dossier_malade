import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'core/constant/color.dart';
import 'core/constant/data.dart';
import 'core/services/settingservice.dart';
import 'routes.dart';
import 'view/screens/welcome.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initialService();
  if (AppData.isAndroidAppMobile) {
    debugPrint("i'm in the Android Platform");

    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  } else {
    debugPrint("i'm not in Android platform");
  }
  runApp(const MyApp());
}

Future initialService() async {
  await Get.putAsync(() => SettingServices().init());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    String? fontFamily = GoogleFonts.abhayaLibre().fontFamily;
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Gestion Commercial',
        routes: routes,
        home: const WelcomePage(),
        theme: ThemeData(
            primaryColor: Colors.red,
            appBarTheme:
                AppBarTheme(backgroundColor: Theme.of(context).primaryColor),
            textTheme: TextTheme(
                headlineLarge: TextStyle(
                    color: AppColor.black,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    fontFamily: fontFamily),
                displayLarge: TextStyle(
                    color: AppColor.black,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    fontFamily: fontFamily),
                titleLarge: TextStyle(
                    color: AppColor.black,
                    fontSize: 24,
                    fontFamily: fontFamily,
                    fontWeight: FontWeight.bold),
                titleMedium: TextStyle(
                    color: AppColor.black,
                    fontSize: 18,
                    fontFamily: fontFamily),
                titleSmall: TextStyle(
                    color: AppColor.greyblack,
                    fontSize: 14,
                    fontFamily: fontFamily),
                labelSmall: TextStyle(
                    color: AppColor.greyblack,
                    fontSize: 12,
                    fontFamily: fontFamily),
                bodySmall: TextStyle(
                    color: AppColor.black,
                    fontSize: 11,
                    fontFamily: fontFamily),
                displayMedium: TextStyle(
                    color: AppColor.black,
                    fontSize: 24,
                    fontFamily: fontFamily),
                displaySmall: TextStyle(
                    color: AppColor.black,
                    fontSize: 20,
                    fontFamily: fontFamily),
                headlineMedium: TextStyle(
                    color: AppColor.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: fontFamily),
                headlineSmall: TextStyle(
                    color: AppColor.grey,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: fontFamily),
                bodyLarge: TextStyle(
                    color: AppColor.black,
                    fontSize: 16,
                    fontFamily: fontFamily),
                bodyMedium: TextStyle(
                    color: AppColor.black,
                    fontSize: 12,
                    fontFamily: fontFamily),
                labelLarge: const TextStyle(
                    fontWeight: FontWeight.bold, fontFamily: "Traditional"))));
  }
}
