import 'dart:async';
import 'package:cechat/Controllers/NovasMenssagens/novasmensagens.dart';
import 'package:cechat/Models/Usuarios/usuario.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import '../../../Controllers/AdManager/AdHelper.dart';
import '../../../Models/Colors/DefineColors.dart';
import '../../../Models/Menssagens/mensagens.dart';
import 'package:firebase_database/firebase_database.dart';

import '../../Procura/Procura.dart';

String ultimaMensagem = "";
ColorAplicativo colorApp = ColorAplicativo();
Map<String, dynamic> novaMensagem =
    ({"mensagem": "", "uid": "", "chatuid": ""});
List<Map<String, dynamic>>? dataMensagens;
String? palavra;
bool command = true;
bool nameBol = false;
String nome = "Mude o chat:";
List<ChatMessage> message = ChatMensagensReturn().messages;
Listener scrollOf = Listener();
InterstitialAd? _interstitialAd;

class Chat extends StatefulWidget {
  Chat({Key? key, required this.usuario, required this.chatId});

  String chatId;
  Usuario usuario;

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> with TickerProviderStateMixin {
  TextEditingController controller = TextEditingController();

  AnimationController? _iconController;

  @override
  void dispose() {
    _iconController!.dispose();
    String novoChatId = widget.chatId;
    final database = FirebaseDatabase.instance.ref().child('chat/$novoChatId');
    database.remove();
    
    super.dispose();
  }

  @override
  void initState() {
    void _loadInterstitialAd() async {
      String novoChatId = widget.chatId;
      final database =
          FirebaseDatabase.instance.ref().child('chat/$novoChatId');

      InterstitialAd.load(
        adUnitId: AdHelper.interstitialAdUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) {
            ad.fullScreenContentCallback = FullScreenContentCallback(
              
              onAdDismissedFullScreenContent: (ad) {
                if (widget.usuario.cidade.isNotEmpty &&
                    widget.usuario.cidade.isNotEmpty &&
                    // ignore: unnecessary_null_comparison
                    widget.usuario.nome != null &&
                    widget.usuario.nome != " " &&
                    widget.usuario.nome != "") {
                  database.remove();
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Procura(user: widget.usuario)));
                }
              },
              onAdClicked: (ad) {
                if (widget.usuario.cidade.isNotEmpty &&
                    widget.usuario.cidade.isNotEmpty &&
                    widget.usuario.nome != null &&
                    widget.usuario.nome != " " &&
                    widget.usuario.nome != "") {
                  database.remove();
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Procura(user: widget.usuario)));
                }
              },
            );

            setState(() {
              _interstitialAd = ad;
            });
          },
          onAdFailedToLoad: (err) {
            print('Failed to load an interstitial ad: ${err.message}');
          },
        ),
      );
    }

    _loadInterstitialAd();
    _iconController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    message = ChatMensagensReturn().messages;
    recarregar();

    super.initState();
  }

  void recarregar() {
    Future.delayed(const Duration(seconds: 12), (() {
      if (command == true) {
        setState(() {});
      }

      recarregar();
    }));
  }

  @override
  Widget build(BuildContext context) {
    String novoChatId = widget.chatId;
    final database = FirebaseDatabase.instance.ref().child('chat/$novoChatId');

    MediaQueryData query = MediaQuery.of(context);
    ScrollController controller = ScrollController()
      ..addListener(() {
        scrollOf.onPointerDown;
      });
    TextEditingController controllerDigito = TextEditingController();

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: colorApp.corBackgroundChat(),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            iconSize: 25,
            color: Colors.white,
            onPressed: (() {
              showCupertinoModalBottomSheet(
                context: context,
                builder: (context) => Container(
                  width: query.size.width,
                  height: query.size.height - 500,
                  color: Colors.white,
                  child: Scaffold(
                    body: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 15),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                    padding: EdgeInsets.only(
                                        left: query.size.width - 275)),
                                Image.asset(
                                  "img/men.png",
                                  width: 130,
                                  height: 130,
                                ),
                              ],
                            ),
                          ],
                        ),
                        const Padding(padding: EdgeInsets.only(top: 12)),
                        const Center(
                          child: Text(
                            "Deseja trocar de bate-papo? ",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 18,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                        const Padding(padding: EdgeInsets.only(top: 16)),
                        Center(
                          child: SizedBox(
                            width: query.size.width - 80,
                            height: 60,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ), backgroundColor: colorApp.corPrinciapal(),
                                fixedSize: const Size.fromWidth(80),
                                padding: const EdgeInsets.all(10),
                              ),
                              child: const Text("Buscar Novo Chat (AD)"),
                              onPressed: () async {
                                //adqui
                                _interstitialAd!.show();
                                //Code Here
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
              _iconController!.reset();
            }),
            icon: const Icon(Icons.arrow_circle_right_outlined),
          )
        ],
        backgroundColor: colorApp.corPrinciapal(),
        shadowColor: colorApp.corPrinciapal(),
        centerTitle: true,
        title: Text(nome),
      ),
      body: StreamBuilder<dynamic>(
        stream: database.get().asStream().asBroadcastStream(),
        builder: ((context, snapshot) {
          if (snapshot.data != null) {}
          if (snapshot.hasData) {
            DataSnapshot a = snapshot.data;
            if (command == false) {
              Future.delayed(const Duration(seconds: 16), (() {
                command = true;
              }));
            }

            return SingleChildScrollView(
              controller: controller,
              child: SizedBox(
                width: query.size.width,
                height: query.size.height - 70,
                child: Column(
                  children: [
                    SizedBox(
                      width: query.size.width,
                      height: query.size.height - 130,
                      child: Stack(children: [
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: a.children.length,
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                          physics: AlwaysScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Container(
                              padding: const EdgeInsets.only(
                                  left: 14, right: 14, top: 10, bottom: 10),
                              child: Align(
                                alignment: (a.children
                                            .elementAt(index)
                                            .child("id")
                                            .value
                                            .toString() ==
                                        widget.usuario.uid
                                    ? Alignment.topLeft
                                    : Alignment.topRight),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: (a.children
                                                .elementAt(index)
                                                .child("id")
                                                .value
                                                .toString() ==
                                            widget.usuario.uid
                                        ? Colors.grey.shade300
                                        : colorApp.corPrinciapal()),
                                  ),
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    children: [
                                      Text(
                                        a.children
                                                .elementAt(index)
                                                .child("hr")
                                                .value
                                                .toString() +
                                            " :",
                                        style: const TextStyle(
                                            fontSize: 11,
                                            fontStyle: FontStyle.italic,
                                            color: Colors.grey),
                                      ),
                                      const Padding(padding: EdgeInsets.all(5)),
                                      Text(
                                        a.children
                                            .elementAt(index)
                                            .child("mensagem")
                                            .value
                                            .toString(),
                                        style: const TextStyle(fontSize: 15),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ]),
                    ),
                    Row(
                      children: [
                        const Padding(padding: EdgeInsets.only(left: 10)),
                        SizedBox(
                          width: query.size.width - 75,
                          height: 60,
                          child: TextFormField(
                            onTap: () {
                              setState(() {
                                command = false;
                              });
                            },
                            controller: controllerDigito,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              labelText: 'Digite algo...',
                              hintText: "Digite algo...",
                              enabledBorder: OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(20.0)),
                                borderSide: BorderSide(
                                    color: colorApp.corPrinciapal(),
                                    width: 2.0),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0)),
                                borderSide:
                                    BorderSide(color: Colors.black, width: 2.0),
                              ),
                            ),
                          ),
                        ),
                        const Padding(padding: EdgeInsets.only(left: 7)),
                        SizedBox(
                            height: 52,
                            width: 52,
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24.0),
                              ),
                              color: colorApp.corPrinciapal(),
                              elevation: 2,
                              child: Center(
                                child: IconButton(
                                    onPressed: (() {
                                      setState(() {
                                        palavra = controllerDigito.text;
                                        command = true;
                                      });
                                      database.push().set({
                                        'mensagem': palavra!,
                                        'id': widget.usuario.uid,
                                        'hr': widget.usuario.nome
                                      });

                                      controller.animateTo(0,
                                          duration:
                                              const Duration(milliseconds: 300),
                                          curve: Curves.linear);
                                      FocusScope.of(context).unfocus();
                                      controller.jumpTo(
                                          controller.position.maxScrollExtent);
                                    }),
                                    icon: const Icon(
                                      Icons.send,
                                      color: Colors.white,
                                      size: 25,
                                    )),
                              ),
                            ))
                      ],
                    )
                  ],
                ),
              ),
            );
          }
          return Column();
        }),
      ),
    );
  }
}
