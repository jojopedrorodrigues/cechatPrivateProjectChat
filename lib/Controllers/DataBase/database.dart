import 'package:cechat/Views/HomePage/Chat/chat.dart';
import 'package:cechat/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../Models/Usuarios/usuario.dart';

class Database {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> criarChat(Map<String, dynamic> task, String uid) async {
    String estado = task["estado"].toString();
    String cidade = task["cidade"].toString();
    String data = task["data"].toString();
    await _db
        .collection('cidades')
        .doc(estado)
        .collection(cidade)
        .doc(data)
        .collection("ids")
        .doc(data + uid)
        .set(task);
  }
   Future<void> delete(Map<String, dynamic> task, String uid) async {
    String estado = task["estado"].toString();
    String cidade = task["cidade"].toString();
    String data = task["data"].toString();
    await _db
        .collection('cidades')
        .doc(estado)
        .collection(cidade)
        .doc(data)
        .collection("ids")
        .doc(data + uid)
        .delete();
  }
  processo(Map<String, dynamic> task, String uid, bool verif,
      BuildContext context, Usuario user) {
    String estado = task["estado"].toString();
    String cidade = task["cidade"].toString();
    String data = task["data"].toString();
    String quantidade;
    String quantidade2;
    String check1;
    String check2;
    int validador;
    var pro = _db
        .collection("cidades")
        .doc(estado)
        .collection(cidade)
        .doc(data)
        .collection("ids")
        .get();
    pro.then((value) {
      if (value.docs.isNotEmpty) {
        quantidade = value.docs.elementAt(0)["uid1"].toString();
        quantidade2 = value.docs.elementAt(0)["uid2"].toString();
        check1 = value.docs.elementAt(0)["seta1"].toString();
        check2 = value.docs.elementAt(0)["seta2"].toString();
        validador = value.docs.elementAt(0)["validador"];
        if (quantidade == "null" && check1 == "null") {
          print("Entrou 1  = " + uid);
          task["uid1"] = uid;
          task["seta1"] = uid;
          _db
              .collection('cidades')
              .doc(estado)
              .collection(cidade)
              .doc(data)
              .collection("ids")
              .doc(value.docs.elementAt(0).id)
              .set(task);

          processo(task, uid, verif, context, user);
        } else if (quantidade2 == "null" &&
            quantidade != "null" &&
            uid != quantidade) {
          print("Entrou quantidade 2  = " + uid);
          task["uid1"] = quantidade;
          task["seta1"] = quantidade;
          task["uid2"] = uid;
          task["seta2"] = uid;
          _db
              .collection('cidades')
              .doc(estado)
              .collection(cidade)
              .doc(data)
              .collection("ids")
              .doc(value.docs.elementAt(0).id)
              .set(task);

          processo(task, uid, verif, context, user);
        } else if (quantidade == uid &&
            uid != quantidade2 &&
            check2 != "null" &&
            verif == false) {
          print("Entrou quantidade 1  = " + uid);
          task["uid1"] = quantidade;
          task["seta1"] = quantidade;
          task["uid2"] = quantidade2;
          task["seta2"] = quantidade2;
          task["validador"] = 1;
          _db
              .collection('cidades')
              .doc(estado)
              .collection(cidade)
              .doc(data)
              .collection("ids")
              .doc(value.docs.elementAt(0).id)
              .set(task);

          processo(task, uid, true, context, user);
        } else if (quantidade2 == uid &&
            uid != quantidade &&
            verif == false &&
            validador == 1) {
          print("Entrou quantidade 2 2   = " + uid);
          task["uid1"] = quantidade;
          task["seta1"] = quantidade;
          task["uid2"] = quantidade2;
          task["seta2"] = quantidade2;
          task["validador"] = 2;
          _db
              .collection('cidades')
              .doc(estado)
              .collection(cidade)
              .doc(data)
              .collection("ids")
              .doc(value.docs.elementAt(0).id)
              .set(task)
              .whenComplete(() {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => Chat(
                          usuario: user,
                          chatId: quantidade + quantidade2,
                        )));
          });
        } else if (quantidade == uid &&
            uid != quantidade2 &&
            verif == true &&
            validador == 2) {
          _db
              .collection('cidades')
              .doc(estado)
              .collection(cidade)
              .doc(data)
              .collection("ids")
              .doc(value.docs.elementAt(0).id)
              .delete();
          print("entrou finish 10000 ");
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => Chat(
                        usuario: user,
                        chatId: quantidade + quantidade2,
                      )));
        } else {
          processo(task, uid, verif, context, user);
        }

        //IGNORA AQUI POR PARTE - INICIA A CRIAÇÃO DOS IDS.
      } else {
        criarChat(task, uid);
        processo(task, uid, verif, context, user);
      }
    });
  }
}
