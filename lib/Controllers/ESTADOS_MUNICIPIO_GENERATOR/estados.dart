import 'package:estados_municipios/estados_municipios.dart';

class Estados {
  List<String> est = [];
  List<String> cit = [];
  String ?siglaEstado;
  Estados ({required String siglasEstados});
  preencherEstados() async {
    final controller = EstadosMunicipiosController();
    final estados = await controller.buscaTodosEstados();
    for (var element in estados) {
      est.add(element.sigla.toString());
    }
   return est;
  }
  preencherCidades(String siglaEstado)async{
     final controller = EstadosMunicipiosController();
    final cidades = await controller.buscaMunicipiosPorEstado(siglaEstado);
    for (var element in cidades) {
      cit.add(element.nome.toString());
    }
    return cit;
  }
}
