import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/login_controller.dart';
import '../../../core/constant/color.dart';
import 'buttonlogin.dart';
import 'edittextlogin.dart';

class LoginCredentialWidget extends StatelessWidget {
  const LoginCredentialWidget({super.key});

  @override
  Widget build(BuildContext context) => Container(
      constraints: const BoxConstraints(maxWidth: 400),
      padding: const EdgeInsets.all(10),
      child: GetBuilder<LoginController>(
          builder: (controller) => Column(children: [
                const SizedBox(height: 16),
                Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: EditTextLogin(
                        title: "Nom d'utilisateur",
                        hintText: "nom d'utilisateur",
                        isPassword: false,
                        icon: Icons.person_outline_outlined,
                        mycontroller: controller.userController)),
                Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, top: 10),
                    child: EditTextLogin(
                        title: "Mot de passe",
                        hintText: "mot de passe",
                        isPassword: true,
                        icon: Icons.password_outlined,
                        mycontroller: controller.passController)),
                if (controller.wrongCredent) const SizedBox(height: 16),
                if (controller.wrongCredent)
                  Center(
                      child: Text(
                          "Nom d'utilisateur ou mot de passe incorrecte !!!",
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium!
                              .copyWith(color: AppColor.red))),
                if (controller.erreurServeur)
                  Center(
                      child: Text(
                          "Erreur avec le serveur !!! ${controller.erreur}",
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium!
                              .copyWith(color: AppColor.red))),
                const SizedBox(height: 16),
                Center(
                    child: ButtonLogin(
                        onPressed: controller.valider
                            ? null
                            : () {
                                controller.onValidate();
                              },
                        backcolor: AppColor.primary,
                        textcolor: AppColor.white)),
                const SizedBox(height: 16)
              ])));
}
