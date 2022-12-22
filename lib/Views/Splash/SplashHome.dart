import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:cechat/Views/HomePage/Estados/InicioEstado.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Models/Colors/DefineColors.dart';
import '../HomePage/Nome/Nickname.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    FirebaseMessaging.instance.getToken().then((value) {
      if(value!.isNotEmpty){
        print("valor = "+value.toString());
      }
    });
 
    Future.delayed(const Duration(milliseconds: 1200), (() async {
      String estado;
      String cidade;
      final prefs = await SharedPreferences.getInstance();
      estado = await prefs.getString("estado").toString();
      cidade = await prefs.getString("cidade").toString();
      print("valor = "+estado);
      if (estado != "null" && cidade != "null") {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => NickName(
                      selectEstado: estado,
                      selectCidades: cidade,
                    )));
      }
    }));
    super.initState();
  }

  ColorAplicativo colorApp = ColorAplicativo();
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      backgroundColor: colorApp.corPrinciapal(),
      duration: 2100,
      splashIconSize: 200,
      splash: 'img/logo.png',
      nextScreen: const InicioEstado(),
      splashTransition: SplashTransition.fadeTransition,
    );
  }
}
