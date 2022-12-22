import '../../Models/Menssagens/mensagens.dart';

class ChatMensagensReturn {
  List<ChatMessage> messages = [
    ChatMessage(messageContent: "Digite algo para começar...", messageType: "Digite algo para começar..."),

  ];
   get mensagens => messages;
}