import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cechat/Controllers/DataBase/database.dart';
import 'package:cechat/Models/Usuarios/usuario.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../Models/Colors/DefineColors.dart';

DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
var varial;
DateTime data = DateTime.now();
var dados;
int delay = 5000; // delay de 5 seg.
int interval = 1000; // intervalo de 1 seg.
Database db = Database();
ColorAplicativo colorApp = ColorAplicativo();
String? valor;

class Procura extends StatefulWidget {
  Usuario user;

  Procura({Key? key, required this.user});

  @override
  State<Procura> createState() => _ProcuraState();
}

class _ProcuraState extends State<Procura> {
  @override
  void dispose() {
    Future.delayed(const Duration(seconds: 1), (() async {
      Map<String, dynamic> task = ({
        "estado": widget.user.estado,
        "cidade": widget.user.cidade,
        "data": data.day + data.month + data.year,
        "uid1": "null",
        "uid2": "null",
        "validador": 0,
        "seta1": "null",
        "seta2": "null"
      });
      varial = db.delete(task, widget.user.uid.toString());
    }));
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    Map<String, dynamic> task = ({
      "estado": widget.user.estado,
      "cidade": widget.user.cidade,
      "data": data.day + data.month + data.year,
      "uid1": "null",
      "uid2": "null",
      "validador": 0,
      "seta1": "null",
      "seta2": "null"
    });

    Future.delayed(const Duration(seconds: 5), (() async {
      varial = await db.processo(
          task, widget.user.uid.toString(), false, context, widget.user);
      if (varial != null) {
        print("valor = " + varial.toString());
      }
    }));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorApp.corPrinciapal(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: LoadingAnimationWidget.inkDrop(
              color: Colors.white,
              size: 60,
            ),
          ),
          const Padding(padding: EdgeInsets.only(top: 30)),
          Center(
            child: DefaultTextStyle(
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 18),
              child: AnimatedTextKit(
                totalRepeatCount: 50,
                animatedTexts: [
                  TypewriterAnimatedText('Estamos procurando alguém'),
                  TypewriterAnimatedText('Lembre-se, respeito acima de tudo'),
                  TypewriterAnimatedText('Vamos conectar você com alguém'),
                  TypewriterAnimatedText('hmmm... alguém aí? '),
                  TypewriterAnimatedText(
                      'Respira, já já aparece alguém pra tc'),
                  TypewriterAnimatedText('Respeito é respeito hein !'),
                  TypewriterAnimatedText('Caso não goste, basta mudar !'),
                  TypewriterAnimatedText('Oi, tudo bem?'),
                ],
                onTap: () {},
              ),
            ),
          )
        ],
      ),
    );
  }
}
