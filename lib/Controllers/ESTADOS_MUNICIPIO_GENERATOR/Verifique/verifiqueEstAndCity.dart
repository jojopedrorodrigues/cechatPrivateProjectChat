class VerificarEstadosCity {
  verificarEstados(String estado) {
    if (estado.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  verificarCidade(String cidade) {
    if(cidade.isNotEmpty){
      return true;
    }
    else{
      return false;
    }
  }
}
