import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gestion_dossier_malade/core/constant/data.dart';

class AppSizes {
  static double maxWidth = 800;
  static late double widthScreen, heightScreen;

  static setSizeScreen(context) {
    widthScreen = MediaQuery.of(context).size.width;
    maxWidth = AppData.isAndroidAppMobile ? 800 : widthScreen;
    widthScreen = min(widthScreen, maxWidth);

    heightScreen = MediaQuery.of(context).size.height;
  }
}
