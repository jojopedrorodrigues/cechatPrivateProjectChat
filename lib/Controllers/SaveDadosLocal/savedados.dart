import 'package:shared_preferences/shared_preferences.dart';

class SaveDados{
  static save(String cidade, String estados)async{ 
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('cidade', cidade);
    await prefs.setString('estado', estados);
  }
 static delete()async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('cidade', "null");
    await prefs.setString('estado', "null");
  }
}