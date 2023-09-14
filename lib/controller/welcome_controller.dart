import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/constant/data.dart';
import '../core/constant/routes.dart';
import '../core/constant/sizes.dart';

class WelcomeController extends GetxController {
  @override
  void onReady() {
    Timer(const Duration(seconds: 3), close);
    super.onReady();
  }

  close() {
    // if (AppData.getServerName().isEmpty) {
    //   Get.offAllNamed(AppRoute.ficheServerName);
    // } else {
    //   Get.offAllNamed(AppRoute.listDossier);
    // }
  }

  @override
  void onInit() async {
    WidgetsFlutterBinding.ensureInitialized();
    AppSizes.setSizeScreen(Get.context);
    super.onInit();
  }
}
