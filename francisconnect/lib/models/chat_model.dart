class ChatModel {
  final String id;
  final List<String> participantes;
  final String ultimoMensaje;
  final DateTime ultimoMensajeEn;
  final Map<String, int> noLeidos;

  ChatModel({
    required this.id,
    required this.participantes,
    required this.ultimoMensaje,
    required this.ultimoMensajeEn,
    required this.noLeidos
  });

  static String chatId(String uid1, String uid2) {
    final sorted = [uid1, uid2]..sort();
    return '${sorted[0]}_${sorted[1]}';
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'participantes': participantes,
    'ultimoMensaje': ultimoMensaje,
    'ultimoMensajeEn': ultimoMensajeEn,
    'noLeidos': noLeidos
  };

  factory ChatModel.fromMap(Map<String, dynamic> map) => ChatModel(
    id: map['id'] ?? '', 
    participantes: map['participantes'] ?? '', 
    ultimoMensaje: map['ultimoMensaje'] ?? '',  
    ultimoMensajeEn: map['ultimoMensajeEn'] ?? '',  
    noLeidos: map['noLeidos'] ?? '', 
  );
}