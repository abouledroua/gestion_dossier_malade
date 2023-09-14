import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:launch_review/launch_review.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

// import '../../controller/login_controller.dart';
// import '../class/active.dart';
// import '../class/user.dart';
// import '../services/settingservice.dart';
import 'color.dart';
// import 'image_asset.dart';
import 'routes.dart';
import 'sizes.dart';
// import 'sizes.dart';

class AppData {
  static const bool testMode = false,
      showSignaleOnly = false,
      showAbonneExterne = false,
      showmyAbonne = false;

  static const String _www = "WWW", numProduit = '5G';
  static late String storageLocation;
  static String dossier = "",
      miniDossier = "",
      _serverName = "",
      _serverIP = "$_serverName/COMMERCIAL",
      privacyAppName = 'Gestion Commercial';

  static double webVersion = 3.4, padBottom = 30;
  static const int widthSmallImage = 100, heightSmallImage = 100;
  static const Duration _timeOut = Duration(seconds: 10),
      searchDuration = Duration(seconds: 1);
  static Timer? internetLoginTimer;
  static final bool isAndroidAppMobile =
      (defaultTargetPlatform == TargetPlatform.android && !kIsWeb);

  static String getServerIP() => _serverIP;
  static Duration getTimeOut() => _timeOut;

  static String getServerName() => _serverName;

  static setServerName(String server) {
    _serverName = server;
    _serverIP = "$_serverName/COMMERCIAL";
  }

  // static chargeServerName() {
  //   SettingServices c = Get.find();
  //   _serverName = c.sharedPrefs.getString('ServerName') ?? "";
  //   AppData.setServerName(_serverName);
  //   if (kDebugMode) {
  //     AppData.setServerName("atlasschool.dz");
  //     // AppData.setServerName("hacenebouzebda-revet.dz");
  //     c.sharedPrefs.setString('ServerName', _serverName);
  //   }
  // }

  static Future<String> getAndroidId() async {
    String deviceBrand = '', deviceIdentifier = '', deviceModel = '';
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        deviceBrand = androidInfo.brand.toUpperCase();
        deviceModel = androidInfo.device.toUpperCase();
        deviceIdentifier = '$deviceBrand $deviceModel';
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        deviceIdentifier = iosInfo.identifierForVendor!;
      } else if (Platform.isLinux) {
        LinuxDeviceInfo linuxInfo = await deviceInfo.linuxInfo;
        deviceIdentifier = linuxInfo.machineId!;
      } else if (kIsWeb) {
        WebBrowserInfo webInfo = await deviceInfo.webBrowserInfo;
        deviceIdentifier = webInfo.vendor! +
            webInfo.userAgent! +
            webInfo.hardwareConcurrency.toString();
      }
    } catch (e) {
      deviceIdentifier = '';
    }
    return deviceIdentifier;
  }

  static String getServerDirectory([port = ""]) => ((_serverIP == "")
      ? ""
      : "http${testMode ? "" : "s"}://$_serverIP${port != "" ? ":$port" : ""}/$_www");

  static String getImage(pImage, pType) =>
      "${getServerDirectory()}/IMAGE/$pType/$pImage";

  static Future<String?> getDownloadPath() async {
    Directory? directory;
    try {
      directory = Directory('/storage/emulated/0/Download');
      // Put file in global download folder, if for an unknown reason it didn't exist, we fallback
      // ignore: avoid_slow_async_io
      if (!await directory.exists()) {
        directory = await getExternalStorageDirectory();
      }
    } catch (err) {
      debugPrint("Cannot get download folder path");
    }
    return directory?.path;
  }

  // static setServerIP(ip) async {
  //   _serverIP = ip;
  //   SettingServices c = Get.find();
  //   c.sharedPrefs.setString('ServerIp', _serverIP);
  // }

  // static Future<String?> activerDevice(
  //     {required String cd, required String ns, required String na}) async {
  //   String serverDir = AppData.getServerDirectory();
  //   var url = "$serverDir/INSERT_ACTIVATION.php";
  //   debugPrint(url);
  //   saveIdentifiant(ns: ns, na: na, cd: cd);
  //   Uri myUri = Uri.parse(url);
  //   await http
  //       .post(myUri, body: {"BDD": AppData.dossier, "NS": ns, "NA": na}).then(
  //           (response) async {
  //     if (response.statusCode == 200) {
  //       var responsebody = response.body;
  //       debugPrint("Activation Response=$responsebody");
  //       if (responsebody != "0") {
  //         return "1";
  //       } else {
  //         return "0";
  //       }
  //     } else {
  //       return "-1";
  //     }
  //   }).catchError((error) {
  //     return error;
  //   });
  //   return null;
  // }

  // static saveIdentifiant(
  //     {required String cd, required String na, required String ns}) async {
  //   SettingServices sc = Get.find();
  //   await sc.storage.write(key: 'CD', value: cd);
  //   await sc.storage.write(key: 'NS', value: ns);
  //   await sc.storage.write(key: 'NA', value: na);
  // }

  // static Future<Active> readIdentifiant() async {
  //   SettingServices sc = Get.find();
  //   String active = await sc.storage.read(key: 'ACTIVE_$dossier') ?? '-1';
  //   String cd = await sc.storage.read(key: 'CD') ?? '';
  //   String ns = await sc.storage.read(key: 'NS') ?? '';
  //   String na = await sc.storage.read(key: 'NA') ?? '';
  //   return Active(na: na, ns: ns, cd: cd, active: active);
  // }

  static mySnackBar({required title, required message, required color}) {
    Get.snackbar(title, message,
        snackPosition: SnackPosition.BOTTOM,
        maxWidth: AppSizes.widthScreen,
        margin: const EdgeInsets.symmetric(horizontal: 10),
        backgroundColor: color,
        colorText: AppColor.white);
  }

  static String printDateDayOnly(String pdate) {
    DateTime currentDate = DateTime.now();
    DateTime date = DateTime.parse(pdate);
    int yy = currentDate.year - date.year;
    String str = "";
    if (yy > 0) {
      str = DateFormat('yyyy-MM-dd').format(date);
    } else {
      int mm = currentDate.month - date.month;
      int dd = currentDate.day - date.day;
      if (mm < 0) {
        yy--;
        mm += 12;
      }
      if (dd < 0) {
        mm--;
        dd += 30;
      }
      if (dd > 6) {
        str = DateFormat('dd MMM à HH:mm').format(date);
      } else {
        switch (dd) {
          case 0:
            str = "Aujourdh'ui";
            break;
          case 1:
            str = "Hier";
            break;
          default:
            str = DateFormat('dd MMM').format(date);
            break;
        }
      }
    }
    return str;
  }

  static String printDate(DateTime? date) {
    DateTime currentDate = DateTime.now();
    int yy = currentDate.year - date!.year;
    String str = "";
    if (yy > 0) {
      str = DateFormat('yyyy-MM-dd').format(date);
    } else {
      int mm = currentDate.month - date.month;
      int dd = currentDate.day - date.day;
      int hh = currentDate.hour - date.hour;
      int min = currentDate.minute - date.minute;
      if (mm < 0) {
        yy--;
        mm += 12;
      }
      if (dd < 0) {
        mm--;
        dd += 30;
      }
      if (hh < 0) {
        dd--;
        hh += 24;
      }
      if (min < 0) {
        hh--;
        min += 60;
      }
      if (dd > 6) {
        str = DateFormat('dd MMM à HH:mm').format(date);
      } else {
        String ch = "";
        switch (dd) {
          case 0:
            if (hh > 0) {
              ch = "0$hh";
              ch = ch.substring(ch.length - 2);
              str = "Il y'a $ch heure(s)";
            } else {
              if (min > 0) {
                ch = "0$min";
                ch = ch.substring(ch.length - 2);
                str = "Il y'a $ch minute(s)";
              } else {
                str = "Il y a un instant";
              }
            }
            break;
          case 1:
            str = "Hier ${DateFormat('HH:mm').format(date)}";
            break;
          default:
            str = DateFormat('EEE à HH:mm').format(date);
            break;
        }
      }
    }
    return str;
  }

  static String calculateAge(DateTime birthDate) {
    DateTime currentDate = DateTime.now();
    int yy = currentDate.year - birthDate.year;
    int mm = currentDate.month - birthDate.month;
    int dd = currentDate.day - birthDate.day;
    if (mm < 0) {
      yy--;
      mm += 12;
    }
    if (dd < 0) {
      mm--;
      dd += 30;
    }
    String age = "";
    if (yy > 1) {
      age = "$yy an(s)";
    } else {
      mm = yy * 12 + mm;
      if (mm > 0) {
        age = "$mm mois";
      } else if (dd > 0) {
        age = "$dd jours";
      }
    }
    return age;
  }

  static void makeExternalRequest({required Uri uri}) async {
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch ${uri.path}';
    }
  }

  static String removeEspace(String pChaine) {
    if (pChaine.isEmpty) return pChaine;

    String chaine = pChaine;
    while (chaine.substring(0, 1) == " ") {
      chaine = chaine.substring(1, chaine.length);
    }
    while (chaine.substring(chaine.length - 2, chaine.length - 1) == " ") {
      chaine = chaine.substring(0, chaine.length - 1);
    }
    return chaine;
  }

  static String extension({required String filename}) =>
      ".${filename.split(".").last}";

  static reparerBDD({required bool showToast}) {
    String serverDir = getServerDirectory();
    var url = "$serverDir/REPARER_BDD.php";
    debugPrint(url);
    Uri myUri = Uri.parse(url);
    http.post(myUri, body: {}).then((response) async {
      if (response.statusCode == 200) {
        var result = response.body;
        if (result != "0") {
          if (showToast) {
            AppData.mySnackBar(
                title: 'Base de Données',
                message: "La base de données à été réparer ...",
                color: AppColor.green);
          }
        } else {
          if (showToast) {
            AppData.mySnackBar(
                title: 'Base de Données',
                message:
                    "Probleme lors de la réparation de la base de données !!!",
                color: AppColor.red);
          }
        }
      } else {
        if (showToast) {
          AppData.mySnackBar(
              title: 'Base de Données',
              message: "Probleme de Connexion avec le serveur 5!!!",
              color: AppColor.red);
        }
      }
    }).catchError((error) {
      debugPrint("erreur reparerBDD: $error");
      if (showToast) {
        AppData.mySnackBar(
            title: 'Base de Données',
            message: "Probleme de Connexion avec le serveur 6!!!",
            color: AppColor.red);
      }
    });
  }

  static TimeOfDay stringToTimeOfDay(String time) {
    int hh = 0;
    if (time.endsWith('PM')) hh = 12;
    time = time.split(' ')[0];
    return TimeOfDay(
      hour: hh +
          int.parse(time.split(":")[0]) %
              24, // in case of a bad time format entered manually by the user
      minute: int.parse(time.split(":")[1]) % 60,
    );
  }

  static String formatMoney(money) => NumberFormat.decimalPattern("uk-UA")
      .format(double.parse((money).toStringAsFixed(2)));

  static String getAlphabetNew(int num) {
    switch (num) {
      case 0:
        return 'T';
      case 1:
        return 'P';
      case 2:
        return 'L';
      case 3:
        return 'W';
      case 4:
        return 'S';
      case 5:
        return '7';
      case 6:
        return 'R';
      case 7:
        return 'Z';
      case 8:
        return '6';
      case 9:
        return '2';
      case 10:
        return 'J';
      case 11:
        return '9';
      case 12:
        return 'O';
      case 13:
        return 'Y';
      case 14:
        return 'U';
      case 15:
        return '3';
      case 16:
        return 'G';
      case 17:
        return 'X';
      case 18:
        return '1';
      case 19:
        return 'A';
      case 20:
        return 'F';
      case 21:
        return 'V';
      case 22:
        return 'E';
      case 23:
        return '0';
      case 24:
        return '5';
      case 25:
        return 'M';
      case 26:
        return 'B';
      case 27:
        return 'H';
      case 28:
        return '4';
      case 29:
        return 'N';
      case 30:
        return 'D';
      case 31:
        return '8';
      case 32:
        return 'K';
      case 33:
        return 'C';
      case 34:
        return 'I';
      case 35:
        return 'Q';
      default:
        return '';
    }
  }

  static String system36New(pnum) {
    int num = pnum;
    String reste = "";
    if (num == 0) {
      reste = getAlphabetNew(num);
    }
    int r = 0;
    String rr = '';
    while (num != 0) {
      r = num % 36;
      rr = getAlphabetNew(r);
      reste = rr + reste;
      num = num ~/ 36;
    }
    return reste;
  }

  static int getNumber(String num) {
    switch (num) {
      case '0':
        return 0;
      case '1':
        return 1;
      case '2':
        return 2;
      case '3':
        return 3;
      case '4':
        return 4;
      case '5':
        return 5;
      case '6':
        return 6;
      case '7':
        return 7;
      case '8':
        return 8;
      case '9':
        return 9;
      case 'A':
        return 10;
      case 'B':
        return 11;
      case 'C':
        return 12;
      case 'D':
        return 13;
      case 'E':
        return 14;
      case 'F':
        return 15;
      case 'G':
        return 16;
      case 'H':
        return 17;
      case 'I':
        return 18;
      case 'J':
        return 19;
      case 'K':
        return 20;
      case 'L':
        return 21;
      case 'M':
        return 22;
      case 'N':
        return 23;
      case 'O':
        return 24;
      case 'P':
        return 25;
      case 'Q':
        return 26;
      case 'R':
        return 27;
      case 'S':
        return 28;
      case 'T':
        return 29;
      case 'U':
        return 30;
      case 'V':
        return 31;
      case 'W':
        return 32;
      case 'X':
        return 33;
      case 'Y':
        return 34;
      case 'Z':
        return 35;
      default:
        return 0;
    }
  }

  static genererid() {
    String t1 = '';
    int n;
    Random rng;
    int cp = 0;
    while (t1.length != 5 && cp < 5) {
      rng = Random.secure();
      n = rng.nextInt(1048575) + 65536;
      t1 = n.toRadixString(16).toUpperCase();
      cp++;
    }
    String t2 = '';
    cp = 0;
    while (t2.length != 5 && cp < 5) {
      rng = Random.secure();
      n = rng.nextInt(1048575) + 65536;
      t2 = n.toRadixString(16).toUpperCase();
      cp++;
    }
    String t = t1 + t2;
    return t;
  }

  // static logout({question = true}) {
  //   if (question) {
  //     AwesomeDialog(
  //             context: Get.context!,
  //             dialogType: DialogType.warning,
  //             title: 'Alerte',
  //             btnOkText: "Oui",
  //             btnCancelText: "Non",
  //             width: AppSizes.widthScreen,
  //             btnCancelOnPress: () {},
  //             onDismissCallback: (type) {},
  //             btnOkOnPress: () {
  //               _closeall(true);
  //             },
  //             showCloseIcon: true,
  //             desc: "Voulez-vous vraiment déconnecter du dossier '$dossier'??")
  //         .show();
  //   } else {
  //     _closeall(true);
  //   }
  // }

  // static _closeall(bool erase) async {
  //   if (erase) {
  //     SettingServices c = Get.find();
  //     c.sharedPrefs.setBool('LastConnected-${AppData.dossier}', false);
  //   }
  //   User.idUser = 0;
  //   if (Get.isRegistered<LoginController>()) {
  //     Get.delete<LoginController>();
  //   }
  //   Get.offAllNamed(AppRoute.login);
  // }

  // static bool isNumberValide(String value) {
  //   try {
  //     final n = num.tryParse(value);
  //     if (n == null) {
  //       return false;
  //     }
  //   } catch (e) {
  //     return false;
  //   }
  //   return true;
  // }

  // static _drawerButton(
  //         {required String text,
  //         required String image,
  //         Color? textColor,
  //         required BuildContext context,
  //         required onTap}) =>
  //     InkWell(
  //         onTap: onTap,
  //         child: Ink(
  //             child: Padding(
  //                 padding: const EdgeInsets.all(4),
  //                 child: Row(
  //                     // mainAxisAlignment: MainAxisAlignment.center,
  //                     children: [
  //                       SizedBox(
  //                           height: AppSizes.heightScreen / 50,
  //                           child: Image.asset(image)),
  //                       const SizedBox(width: 10),
  //                       Text(text,
  //                           style: Theme.of(context)
  //                               .textTheme
  //                               .titleMedium!
  //                               .copyWith(
  //                                   fontWeight: FontWeight.normal,
  //                                   color: textColor ?? AppColor.black))
  //                     ]))));

  // static _labelDrawer({required String text, required BuildContext context}) =>
  //     Container(
  //         width: double.infinity,
  //         color: Colors.grey.shade300,
  //         child: Center(
  //             child: Text(text,
  //                 style: Theme.of(context).textTheme.headlineMedium)));

  // static Drawer myDrawer(BuildContext context, {Color? color}) => Drawer(
  //     child: Container(
  //         color: AppColor.white,
  //         padding: const EdgeInsets.only(bottom: 10),
  //         child: Column(children: [
  //           const SizedBox(height: 16),
  //           Padding(
  //               padding: const EdgeInsets.all(8.0),
  //               child: Row(children: [
  //                 Image.asset(AppImageAsset.folderOpen, height: 25),
  //                 const SizedBox(width: 8),
  //                 Expanded(
  //                     child: FittedBox(
  //                         child: Text('Dossier : $miniDossier',
  //                             style: Theme.of(context)
  //                                 .textTheme
  //                                 .titleMedium!
  //                                 .copyWith(color: AppColor.black))))
  //               ])),
  //           const Divider(),
  //           Expanded(
  //               child: ListView(children: [
  //             _labelDrawer(context: context, text: 'Listes'),
  //             _drawerButton(
  //                 context: context,
  //                 image: AppImageAsset.fournisseur,
  //                 onTap: () {
  //                   Get.back();
  //                   Get.toNamed(AppRoute.listPersonne, arguments: {});
  //                 },
  //                 text: "Liste des Fournisseurs"),
  //             _drawerButton(
  //                 context: context,
  //                 image: AppImageAsset.client,
  //                 onTap: () {
  //                   Get.back();
  //                   Get.toNamed(AppRoute.listPersonne, arguments: {});
  //                 },
  //                 text: "Liste des Clients"),
  //             _drawerButton(
  //                 context: context,
  //                 image: AppImageAsset.product,
  //                 onTap: () {
  //                   Get.back();
  //                   Get.toNamed(AppRoute.listProduit);
  //                 },
  //                 text: "Liste des Produits"),
  //             _drawerButton(
  //                 context: context,
  //                 image: AppImageAsset.stock,
  //                 onTap: () {
  //                   Get.back();
  //                   Get.toNamed(AppRoute.listProduit);
  //                 },
  //                 text: "Etat de Stock"),
  //             const Divider(),
  //             if (User.achat) _labelDrawer(context: context, text: 'Achat'),
  //             if (User.achat)
  //               _drawerButton(
  //                   context: context,
  //                   image: AppImageAsset.br,
  //                   onTap: () {
  //                     Get.back();
  //                   },
  //                   text: "Bon de Réception"),
  //             if (User.achat)
  //               _drawerButton(
  //                   context: context,
  //                   image: AppImageAsset.factureAchat,
  //                   onTap: () {
  //                     Get.back();
  //                   },
  //                   text: "Facture d'achat"),
  //             if (User.achat) const Divider(),
  //             if (User.vente) _labelDrawer(context: context, text: 'Vente'),
  //             if (User.vente)
  //               _drawerButton(
  //                   context: context,
  //                   image: AppImageAsset.proforma,
  //                   onTap: () {
  //                     Get.back();
  //                   },
  //                   text: "Facture Proforma"),
  //             if (User.vente)
  //               _drawerButton(
  //                   context: context,
  //                   image: AppImageAsset.bc,
  //                   onTap: () {
  //                     Get.back();
  //                   },
  //                   text: "Bon de Commande"),
  //             if (User.vente)
  //               _drawerButton(
  //                   context: context,
  //                   image: AppImageAsset.bl,
  //                   onTap: () {
  //                     Get.back();
  //                   },
  //                   text: "Bon de Livraison"),
  //             if (User.vente)
  //               _drawerButton(
  //                   context: context,
  //                   image: AppImageAsset.factureVente,
  //                   onTap: () {
  //                     Get.back();
  //                   },
  //                   text: "Facture de Vente"),
  //             if (User.vente) const Divider(),
  //             if (User.reglement || User.tresorerie)
  //               _labelDrawer(context: context, text: 'Trésorerie'),
  //             if (User.reglement)
  //               _drawerButton(
  //                   context: context,
  //                   image: AppImageAsset.paiementFournisseur,
  //                   onTap: () {
  //                     Get.back();
  //                   },
  //                   text: "Réglement Fournisseurs"),
  //             if (User.reglement)
  //               _drawerButton(
  //                   context: context,
  //                   image: AppImageAsset.paiementClient,
  //                   onTap: () {
  //                     Get.back();
  //                   },
  //                   text: "Réglement Clients"),
  //             if (User.tresorerie)
  //               _drawerButton(
  //                   context: context,
  //                   image: AppImageAsset.transaction,
  //                   onTap: () {
  //                     Get.back();
  //                   },
  //                   text: "Transactions"),
  //             if (User.tresorerie)
  //               _drawerButton(
  //                   context: context,
  //                   image: AppImageAsset.stats,
  //                   onTap: () {
  //                     Get.back();
  //                   },
  //                   text: "Statistiques"),
  //             if (User.reglement || User.tresorerie) const Divider(),
  //             _labelDrawer(context: context, text: 'Général'),
  //             _drawerButton(
  //                 context: context,
  //                 image: AppImageAsset.parametre,
  //                 onTap: () {
  //                   Get.back();
  //                 },
  //                 text: "Paramêtres"),
  //             _drawerButton(
  //                 context: context,
  //                 image: AppImageAsset.repair,
  //                 onTap: () {
  //                   Get.back();
  //                   reparerBDD(showToast: true);
  //                 },
  //                 text: "Réparer les Données"),
  //             _drawerButton(
  //                 context: context,
  //                 image: AppImageAsset.folderClose,
  //                 onTap: () {
  //                   Get.back();
  //                   AppData.changerDossier();
  //                 },
  //                 text: "Changer Dossier",
  //                 textColor: Colors.brown),
  //             _drawerButton(
  //                 context: context,
  //                 image: AppImageAsset.logout,
  //                 onTap: () {
  //                   Get.back();
  //                   logout();
  //                 },
  //                 text: "Déconnecter",
  //                 textColor: AppColor.red)
  //           ]))
  //         ])));

  static openPlayStorePgae() {
    // const url = 'https://play.google.com/store/apps/details?id=com.bouledrouaamor.gestcommercial';
    //  AppData.makeExternalRequest(uri: Uri.parse(url));
    LaunchReview.launch(androidAppId: 'com.bouledrouaamor.gestcommercial');
  }

  static launchSocial(String url, String fallbackUrl) async {
    try {
      final Uri uri = Uri.parse(url);
      await launchUrl(uri, mode: LaunchMode.platformDefault);
    } catch (e) {
      final Uri fallbackUri = Uri.parse(fallbackUrl);
      await launchUrl(fallbackUri, mode: LaunchMode.externalApplication);
    }
  }

  static void changerDossier() {
    AwesomeDialog(
            context: Get.context!,
            dialogType: DialogType.warning,
            title: 'Alerte',
            btnOkText: "Oui",
            btnCancelText: "Non",
            width: AppSizes.widthScreen,
            btnCancelOnPress: () {},
            onDismissCallback: (type) {},
            btnOkOnPress: () {
              Get.offAllNamed(AppRoute.listDossier);
            },
            showCloseIcon: true,
            desc:
                "Voulez-vous vraiment changer le dossier en cours '$dossier'??")
        .show();
  }

  static double getDouble(var m, String column) {
    try {
      return double.parse(m[column]);
    } catch (e) {
      return double.parse(m[column].toString());
    }
  }

  static int getInt(var m, String column) {
    try {
      return int.parse(m[column]);
    } catch (e) {
      return m[column];
    }
  }
}
