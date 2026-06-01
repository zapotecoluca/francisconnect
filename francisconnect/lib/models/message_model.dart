class MessageModel {
  final String id;
  final String texto;
  final String senderUid;
  final DateTime enviadoEn;

  MessageModel({
    required this.id,
    required this.texto,
    required this.senderUid,
    required this.enviadoEn
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'texto': texto,
    'senderUid': senderUid,
    'enviadoEn': enviadoEn.millisecondsSinceEpoch
  };

  factory MessageModel.fromMap(Map<String, dynamic> map) => MessageModel(
    id: map['id'] ?? '',
    texto: map['texto'] ?? '',
    senderUid: map['senderUid'] ?? '',
    enviadoEn: DateTime.fromMillisecondsSinceEpoch(map['enviadoEn'] ?? 0),
  );

}