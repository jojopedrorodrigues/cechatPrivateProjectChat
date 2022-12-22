import 'package:cechat/Controllers/SaveDadosLocal/savedados.dart';
import 'package:cechat/Models/Usuarios/usuario.dart';
import 'package:cechat/Views/HomePage/Estados/InicioEstado.dart';
import 'package:cechat/Views/Procura/Procura.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../../Controllers/AdManager/AdHelper.dart';
import '../../../Models/Colors/DefineColors.dart';
import 'package:shared_preferences/shared_preferences.dart';

InterstitialAd? _interstitialAd;
String contador = "null";
late AndroidDeviceInfo androidInfo;
ColorAplicativo colorApp = ColorAplicativo();
String? palavra;
BannerAd _bannerAd = BannerAd(
    size: AdSize.largeBanner,
    adUnitId: AdHelper.bannerAdUnitId,
    listener: BannerAdListener(
      onAdLoaded: (ad) {},
      onAdFailedToLoad: (ad, err) {
        print('Failed to load a banner ad: ${err.message}');
        ad.dispose();
      },
    ),
    request: const AdRequest());

class NickName extends StatefulWidget {
  String selectCidades;
  String selectEstado;
  NickName(
      {super.key, required this.selectEstado, required this.selectCidades});

  @override
  State<NickName> createState() => _NickNameState();
}

class _NickNameState extends State<NickName> {
  @override
  void initState() {
    void _loadInterstitialAd() async {
      final prefs = await SharedPreferences.getInstance();
      InterstitialAd.load(
        adUnitId: AdHelper.interstitialAdUnitId,
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) {
            ad.fullScreenContentCallback = FullScreenContentCallback(
              onAdDismissedFullScreenContent: (ad) {
                if (widget.selectCidades.isNotEmpty &&
                    widget.selectEstado.isNotEmpty &&
                    palavra != null &&
                    palavra != " " &&
                    palavra != "") {
                  Usuario user = Usuario(
                      uid: androidInfo.androidId!,
                      nome: palavra!,
                      estado: widget.selectEstado,
                      cidade: widget.selectCidades);
                  contador = "0";
                  prefs.setString("contador", contador);
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Procura(user: user)));
                }
              },
              onAdClicked: (ad) {
                if (widget.selectCidades.isNotEmpty &&
                    widget.selectEstado.isNotEmpty &&
                    palavra != null &&
                    palavra != " " &&
                    palavra != "") {
                  Usuario user = Usuario(
                      uid: androidInfo.androidId!,
                      nome: palavra!,
                      estado: widget.selectEstado,
                      cidade: widget.selectCidades);
                  contador = "0";
                  prefs.setString("contador", contador);
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Procura(user: user)));
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
    _bannerAd.load();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData query = MediaQuery.of(context);
    TextEditingController controller = TextEditingController();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: colorApp.corBackgroundChat(),
      appBar: AppBar(
        backgroundColor: colorApp.corPrinciapal(),
        elevation: 9,
        shadowColor: colorApp.corPrinciapal(),
        centerTitle: true,
        title: Text(
          "Seu nome ou Apelido",
          style: TextStyle(
              color: colorApp.corTitleText1(),
              wordSpacing: 2.0,
              fontWeight: FontWeight.w800),
        ),
      ),
      body: SizedBox(
          width: query.size.width,
          height: query.size.height,
          child: Column(
            children: [
              const Padding(padding: EdgeInsets.only(top: 22)),
              const Padding(padding: EdgeInsets.only(top: 5)),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                shadowColor: colorApp.corPrinciapal(),
                elevation: 2,
                child: SizedBox(
                  width: query.size.width - 50,
                  height: 100,
                  child: Center(
                    child: SizedBox(
                      width: query.size.width - 80,
                      child: TextFormField(
                        onChanged: (newValue) {
                          palavra = newValue;
                        },
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: 'Nome',
                          hintText: "Nome",
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20.0)),
                            borderSide: BorderSide(
                                color: colorApp.corPrinciapal(), width: 2.0),
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
                  ),
                ),
              ),
              const Padding(padding: EdgeInsets.only(top: 5)),
              SizedBox(
                width: query.size.width - 50,
                height: 40,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    primary: colorApp.corPrinciapal(),
                    fixedSize: const Size.fromWidth(80),
                    padding: const EdgeInsets.all(10),
                  ),
                  child: const Text("Editar a localidade"),
                  onPressed: () async {
                    SaveDados.delete();
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const InicioEstado()));
                  },
                ),
              ),
              const Padding(padding: EdgeInsets.only(top: 13)),
              Container(
                color: Colors.transparent,
                width: _bannerAd.size.width.toDouble(),
                height: _bannerAd.size.height.toDouble(),
                child: AdWidget(ad: _bannerAd),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: query.size.height - 430,
                ),
                child: SizedBox(
                  width: query.size.width - 80,
                  height: 60,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      primary: colorApp.corPrinciapal(),
                      fixedSize: const Size.fromWidth(80),
                      padding: const EdgeInsets.all(10),
                    ),
                    child: const Text("Buscar"),
                    onPressed: () async {
                      androidInfo = await deviceInfo.androidInfo;
                      final prefs = await SharedPreferences.getInstance();
                      contador = prefs.getString("contador").toString();
                      print("valor cont = " + contador);
                      if (contador != "null") {
                        if (contador == "2") {
                          //anuncioaqui

                          _interstitialAd!.show();
                        } else {
                          int a = int.parse(contador);
                          a++;
                          contador = a.toString();
                          prefs.setString("contador", contador);
                          if (widget.selectCidades.isNotEmpty &&
                              widget.selectEstado.isNotEmpty &&
                              palavra != null &&
                              palavra != " " &&
                              palavra != "") {
                            Usuario user = Usuario(
                                uid: androidInfo.androidId!,
                                nome: palavra!,
                                estado: widget.selectEstado,
                                cidade: widget.selectCidades);
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Procura(user: user)));
                          }
                        }
                      } else {
                        prefs.setString("contador", "0");
                        if (widget.selectCidades.isNotEmpty &&
                            widget.selectEstado.isNotEmpty &&
                            palavra != null &&
                            palavra != " " &&
                            palavra != "") {
                          Usuario user = Usuario(
                              uid: androidInfo.androidId!,
                              nome: palavra!,
                              estado: widget.selectEstado,
                              cidade: widget.selectCidades);
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Procura(user: user)));
                        }
                      }

                      //Code Here
                    },
                  ),
                ),
              )
            ],
          )),
    );
  }
}
