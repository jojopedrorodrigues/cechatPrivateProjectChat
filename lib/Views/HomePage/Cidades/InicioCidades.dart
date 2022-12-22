import 'package:cechat/Controllers/SaveDadosLocal/savedados.dart';
import 'package:cechat/Views/HomePage/Estados/InicioEstado.dart';
import 'package:cechat/Views/HomePage/Nome/Nickname.dart';
import 'package:flutter/material.dart';

import '../../../Controllers/CustomListDelagate/CustomSearchDelagate.dart';
import '../../../Controllers/ESTADOS_MUNICIPIO_GENERATOR/estados.dart';
import '../../../Models/Colors/DefineColors.dart';

Estados? estados;
ColorAplicativo colorApp = ColorAplicativo();
List<bool> valorAtualizado = [];
Future<dynamic>? meu_cidade;
List<String> novo = [];
bool validator = false;
String? sigla;

class CustomSearchDelegate extends SearchDelegate {
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  // second overwrite to pop out of search menu
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  // third overwrite to show query result
  @override
  Widget buildResults(BuildContext context) {
    List<String> matchQuery = [];
    for (var fruit in novo) {
      if (fruit.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(fruit);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return GestureDetector(
          onTap: (() {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => NickName(
                          selectEstado: sigla!,
                          selectCidades: result.toString(),
                        )));
          }),
          child: Card(
            elevation: 3,
            child: ListTile(
              title: Text(result),
            ),
          ),
        );
      },
    );
  }

  // last overwrite to show the
  // querying process at the runtime
  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> matchQuery = [];
    for (var fruit in novo) {
      if (fruit.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(fruit);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return GestureDetector(
          onTap: (() {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => NickName(
                          selectEstado: sigla!,
                          selectCidades: result.toString(),
                        )));
          }),
          child: Card(
            elevation: 3,
            child: ListTile(
              title: Text(result),
            ),
          ),
        );
      },
    );
  }
}

// ignore: must_be_immutable
class InicioCidades extends StatefulWidget {
  String siglaEstado;
  InicioCidades({super.key, required this.siglaEstado});

  @override
  State<InicioCidades> createState() => _InicioCidadesState();
}

class _InicioCidadesState extends State<InicioCidades> {
  @override
  void initState() {
    estados = Estados(siglasEstados: widget.siglaEstado);
    meu_cidade = estados!.preencherCidades(widget.siglaEstado);
    sigla = widget.siglaEstado;
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData query = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: colorApp.corBackgroundChat(),
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: (() {
                showSearch(context: context, delegate: CustomSearchDelegate());
              }),
              icon: const Icon(Icons.search))
        ],
        backgroundColor: colorApp.corPrinciapal(),
        elevation: 9,
        shadowColor: colorApp.corPrinciapal(),
        centerTitle: true,
        title: Text(
          "Sua cidade",
          style: TextStyle(
              color: colorApp.corTitleText1(),
              wordSpacing: 2.0,
              fontWeight: FontWeight.w800),
        ),
      ),
      body: StreamBuilder<dynamic>(
          stream: meu_cidade!.asStream(),
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
                  if (validator == false) {
                    novo.add(snapshot.data[i].toString());
                  } else if (i == snapshot.data.length) {
                    validator = true;
                  }
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
                                  Icons.map_outlined,
                                  color: colorApp.corPrinciapal(),
                                ),
                                subtitle: Text(
                                  "Você está em ${snapshot.data[index]} ?",
                                  style: const TextStyle(
                                      color: Colors.grey, fontSize: 12),
                                ),
                                dense: true,
                                checkboxShape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                    side: BorderSide(
                                        width: 2,
                                        color: colorApp.corPrinciapal())),
                                activeColor: Colors.green,
                                checkColor: Colors.white,
                                value: valorAtualizado.elementAt(index),
                                onChanged: ((value) {
                                  valorAtualizado[index] = value!;

                                  setState(() {});
                                  SaveDados.save(
                                      snapshot.data[index].toString(),
                                      widget.siglaEstado.toString());
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => NickName(
                                                selectEstado:
                                                    widget.siglaEstado,
                                                selectCidades: snapshot
                                                    .data[index]
                                                    .toString(),
                                              )));
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
          }),
    );
  }
}
