import 'package:flutter/material.dart';

import 'core/constant/routes.dart';
import 'view/screens/homepage.dart';
import 'view/screens/login.dart';

Map<String, Widget Function(BuildContext)> routes = {
  AppRoute.login: (context) => const LoginPage(),
  AppRoute.homePage: (context) => const HomePage(),
  // AppRoute.privacy: (context) => const PrivacyPolicy(),
  // AppRoute.apropos: (context) => const AProposView(),
  // AppRoute.activation: (context) => const FicheActivation(),
  // AppRoute.ficheDonnee: (context) => const FicheDonnee(),
  // AppRoute.fichePersonne: (context) => const FichePersonne(),
  // AppRoute.ficheProduit: (context) => const FicheProduit(),
  // AppRoute.ficheDossier: (context) => const FicheDossier(),
  // AppRoute.ficheFacture: (context) => const FicheFacture(),
  // AppRoute.detailsPersonne: (context) => const DetailsPersonneView(),
  // AppRoute.detailsProduit: (context) => const DetailsProduitView(),
  // AppRoute.listDonnee: (context) => const ListDonnee(),
  // AppRoute.listPersonne: (context) => const ListPersonne(),
  // AppRoute.listProduit: (context) => const ListProduits(),
  // AppRoute.listFactures: (context) => const ListFactures(),
  // AppRoute.listDossier: (context) => const ListDossier(),
  // AppRoute.ficheServerName: (context) => const FicheServerName(),
  // AppRoute.connectDossier: (context) => const ConnectDossier()
};
