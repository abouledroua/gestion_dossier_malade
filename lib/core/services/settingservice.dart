// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SettingServices extends GetxService {
  late SharedPreferences sharedPrefs;
  late PackageInfo packageInfo;
  FlutterSecureStorage storage = const FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true));

  Future<SettingServices> init() async {
    SharedPreferences.setMockInitialValues({});
    sharedPrefs = await SharedPreferences.getInstance();
    packageInfo = await PackageInfo.fromPlatform();
    return this;
  }
}
