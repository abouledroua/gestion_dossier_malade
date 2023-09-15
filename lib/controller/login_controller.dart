import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../core/class/user.dart';
import '../core/constant/color.dart';
import '../core/constant/data.dart';
import '../core/constant/routes.dart';
import '../core/constant/sizes.dart';
import '../core/services/settingservice.dart';

class LoginController extends GetxController {
  late TextEditingController userController, passController;
  String erreur = "";
  int type = 0;
  bool valider = false, wrongCredent = false, erreurServeur = false;

  Future<bool> onWillPop() async =>
      (await showDialog(
          context: Get.context!,
          builder: (context) => AlertDialog(
                  title: Row(children: [
                    Icon(Icons.exit_to_app_sharp, color: AppColor.red),
                    const Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Text('Etes-vous sur ?'))
                  ]),
                  content: const Text(
                      "Voulez-vous vraiment annuler l'authetification dans ce dossier ?"),
                  actions: <Widget>[
                    TextButton(
                        onPressed: () => Get.back(result: false),
                        child:
                            Text('Non', style: TextStyle(color: AppColor.red))),
                    TextButton(
                        onPressed: () {
                          // Get.offAllNamed(AppRoute.listDossier);
                        },
                        child: Text('Oui',
                            style: TextStyle(color: AppColor.green)))
                  ]))) ??
      false;

  setValider(pValue) {
    valider = pValue;
    update();
  }

  updateType(int value) {
    type = value;
    update();
  }

  onValidate() {
    setValider(true);
    debugPrint("valider=$valider");
    String serverDir = AppData.getServerDirectory();
    var url = "$serverDir/EXIST_USER.php";
    debugPrint("url=$url");
    String userName = AppData.removeEspace(userController.text.toUpperCase());
    String password = AppData.removeEspace(passController.text.toUpperCase());
    Uri myUri = Uri.parse(url);
    http
        .post(myUri, body: {"USERNAME": userName, "PASSWORD": password})
        .timeout(AppData.getTimeOut())
        .then((response) async {
          if (response.statusCode == 200) {
            debugPrint("responsebody=${response.body}");
            debugPrint("response=${response.toString()}");
            erreurServeur = false;
            wrongCredent = false;
            erreur = "";
            var responsebody = jsonDecode(response.body);
            User.idUser = 0;
            for (var m in responsebody) {
              createVarUser(
                  idUser: AppData.getInt(m, 'ID_USER'),
                  achat: AppData.getInt(m, 'ACHAT') == 1,
                  vente: AppData.getInt(m, 'VENTE') == 1,
                  tresorerie: AppData.getInt(m, 'TRESORERIE_STATISTIQUE') == 1,
                  reglement: AppData.getInt(m, 'REGLEMENT') == 1,
                  prixAchat: AppData.getInt(m, 'PRIX_ACHAT') == 1,
                  parametre: AppData.getInt(m, 'PARAM') == 1,
                  password: password,
                  userName: userName);
            }
            if (User.idUser == 0) {
              effacerLastUser();
              String msg = "Nom d' 'utilisateur ou mot de passe invalide !!!";
              wrongCredent = true;
              debugPrint(msg);
              setValider(false);
              AppData.mySnackBar(
                  title: 'Login', message: msg, color: AppColor.red);
            }
            setValider(false);
          } else {
            erreur = " seurveur 1";
            erreurServeur = true;
            AppData.mySnackBar(
                title: 'Login',
                message: "Probleme lors de la connexion avec le serveur !!!",
                color: AppColor.red);
            debugPrint("Probleme lors de la connexion avec le serveur !!!");
            setValider(false);
          }
        })
        .catchError((error) {
          erreur = error.toString();
          erreurServeur = true;
          debugPrint("erreur onValidate: $error");
          debugPrint("Probleme de Connexion avec le serveur 33 !!!");
          setValider(false);
          debugPrint("error : ${error.toString()}");
        });
  }

  createVarUser(
      {required int idUser,
      required String userName,
      required String password,
      required bool achat,
      required reglement,
      required tresorerie,
      required prixAchat,
      required parametre,
      required vente}) async {
    User.idUser = idUser;
    User.username = userName;
    User.password = password;
    User.achat = achat;
    User.reglement = reglement;
    User.tresorerie = tresorerie;
    User.prixAchat = prixAchat;
    User.parametre = parametre;
    User.vente = vente;

    debugPrint("Its Ok ----- Connected ----------------");

    SettingServices c = Get.find();
    c.sharedPrefs.setString('LastUser', userName);
    c.sharedPrefs.setString('LastPass', password);
    c.sharedPrefs.setBool('LastConnected', true);
    String privacy = c.sharedPrefs.getString('Privacy${User.idUser}') ?? "";
    userController.text = "";
    passController.text = "";
    valider = false;
    if (privacy.isEmpty) {
      debugPrint("Going to Privacy");
      await Get.toNamed(AppRoute.privacy);
    }
    Get.offAllNamed(AppRoute.homePage);
  }

  @override
  void onInit() {
    WidgetsFlutterBinding.ensureInitialized();
    initConnect();
    super.onInit();
  }

  initConnect() {
    AppSizes.setSizeScreen(Get.context);
    AppData.reparerBDD(showToast: false);
    type = 0;
    //Get.reset();
    userController = TextEditingController();
    passController = TextEditingController();
    erreurServeur = false;
    wrongCredent = false;
    SettingServices c = Get.find();
    //effacerLastUser();
    String userPref = c.sharedPrefs.getString('LastUser') ?? "";
    String passPref = c.sharedPrefs.getString('LastPass') ?? "";
    bool connect = c.sharedPrefs.getBool('LastConnected') ?? false;
    if (userPref.isNotEmpty && connect) {
      userController.text = userPref;
      passController.text = passPref;
      onValidate();
    }
  }

  effacerLastUser() {
    SettingServices c = Get.find();
    c.sharedPrefs.setString('LastUser', "");
    c.sharedPrefs.setString('LastPass', "");
    c.sharedPrefs.setBool('LastConnected', false);
  }

  @override
  void onClose() {
    userController.dispose();
    passController.dispose();
    super.onClose();
  }
}
