import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/login_controller.dart';
import '../../core/constant/color.dart';
import '../widgets/login/imageheaderlogin.dart';
import '../widgets/login/logincredentialwidget.dart';
import 'mywidget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    LoginController controller = Get.put(LoginController());
    int hour = TimeOfDay.now().hour;
    return MyWidget(
        showDemo: false,
        backgroundColor: AppColor.white,
        child: WillPopScope(
            onWillPop: controller.onWillPop,
            child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                }, // khaliha listview bah mayokhrajch erreur kitaktab bel clavier
                child: Stack(children: [
                  SingleChildScrollView(
                      child: Column(children: [
                    const SizedBox(height: 14),
                    const ImageHeaderLogin(),
                    const SizedBox(height: 14),
                    Center(
                        child: Text(hour < 13 ? 'Bonjour' : 'Bonsoir',
                            style: Theme.of(context).textTheme.headlineLarge)),
                    const SizedBox(height: 6),
                    Center(
                        child: Text('Connectez-vous à votre compte',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(color: AppColor.greyblack))),
                    const LoginCredentialWidget()
                  ]))
                ]))));
  }
}
