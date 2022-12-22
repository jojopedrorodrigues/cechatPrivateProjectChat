import 'package:cechat/Controllers/ESTADOS_MUNICIPIO_GENERATOR/estados.dart';
import 'package:cechat/Models/Colors/DefineColors.dart';
import 'package:cechat/Views/HomePage/Cidades/InicioCidades.dart';
import 'package:flutter/material.dart';

ColorAplicativo colorApp = ColorAplicativo();
Future<dynamic>? meu_estado;
bool _value = false;
List<bool> valorAtualizado = [];
String? sigla;

class InicioEstado extends StatefulWidget {
  const InicioEstado({super.key});

  @override
  State<InicioEstado> createState() => _InicioEstadoState();
}

class _InicioEstadoState extends State<InicioEstado> {
  Estados estados = Estados(siglasEstados: "MG");
  @override
  void initState() {
    meu_estado = estados.preencherEstados();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData query = MediaQuery.of(context);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: colorApp.corPrinciapal(),
          elevation: 9,
          shadowColor: colorApp.corPrinciapal(),
          centerTitle: true,
          title: Text(
            "Seu Estado",
            style: TextStyle(
                color: colorApp.corTitleText1(),
                wordSpacing: 2.0,
                fontWeight: FontWeight.w800),
          ),
        ),
        backgroundColor: colorApp.corBackgroundChat(),
        body: StreamBuilder<dynamic>(
            stream: meu_estado!.asStream(),
            builder: (context, snapshot) {
              return Builder(builder: ((context) {
                if (snapshot.data == null) {
                  return Center(
                      child: CircularProgressIndicator(
                    color: colorApp.corPrinciapal(),
                  ));
                }
                if (snapshot.data != null) {
                  for (int i = 0; i < snapshot.data!.length; i++) {
                    valorAtualizado.add(false);
                  }
                  return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return SizedBox(
                        width: query.size.width - 22,
                        child: Column(
                          children: [
                            const Padding(padding: EdgeInsets.only(top: 10)),
                            SizedBox(
                              width: query.size.width - 10,
                              height: 85,
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                    side: BorderSide(
                                        width: 0.7,
                                        color: colorApp.corPrinciapal())),
                                elevation: 2,
                                child: CheckboxListTile(
                                  secondary: Icon(
                                    Icons.maps_home_work_outlined,
                                    color: colorApp.corPrinciapal(),
                                  ),
                                  subtitle: Text(
                                    "Você está em ${snapshot.data[index]} ?",
                                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                                  ),
                                  dense: true,
                                  checkboxShape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                     side: BorderSide(
                                        width: 0.1,
                                        color: colorApp.corPrinciapal())
                                  ),
                                  activeColor: Colors.green,
                                  checkColor: Colors.white,
                                  value: valorAtualizado.elementAt(index),
                                  onChanged: ((value) {
                                    valorAtualizado[index] = value!;
                                    sigla = snapshot.data[index].toString();
                                    for (int i = 0;
                                        i < snapshot.data!.length;
                                        i++) {
                                      valorAtualizado.add(false);
                                    }
                                    setState(() {});
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => InicioCidades(
                                              siglaEstado: sigla!)),
                                    );
                                  }),
                                  title: Text(
                                    snapshot.data[index].toString(),
                                    style: TextStyle(
                                        color: colorApp.corPrinciapal(),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }
                return Column();
              }));
            }));
  }
}
