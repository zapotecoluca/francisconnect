class Comment {
  final String id;
  final String text;
  final DateTime creadoEn;
  final String postId;
  final String nombreCompleto;
  final String carrera;
  final String pfp;
  Comment({
    required this.id,
    required this.text,
    required this.creadoEn,
    required this.postId,
    required this.nombreCompleto,
    required this.carrera,
    required this.pfp,
  });

  Comment copyWith({
    String? id,
    String? text,
    DateTime? creadoEn,
    String? postId,
    String? nombreCompleto,
    String? carrera,
    String? pfp
  }) {
    return Comment(
      id: id ?? this.id, 
      text: text ?? this.text, 
      creadoEn: creadoEn ?? this.creadoEn, 
      postId: postId ?? this.postId, 
      nombreCompleto: nombreCompleto ?? this.nombreCompleto, 
      carrera: carrera ?? this.carrera,
      pfp: pfp ?? this.pfp
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id, 
      'text': text, 
      'creadoEn': creadoEn, 
      'postId': postId, 
      'nombreCompleto': nombreCompleto, 
      'carrera': carrera,
      'pfp': pfp
    };
  }

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      id: map['id'] ?? '',
      text: map['text'] ?? '',
      creadoEn: map['creadoEn'] ?? '',
      postId: map['postId'] ?? '',
      nombreCompleto: map['nombreCompleto'] ?? '',
      carrera: map['carrera'] ?? '',
      pfp: map['pfp'] ?? ''
    );
  }

  @override
  String toString() {
    return 'Comment(id: $id, text: $text, creadoEn: $creadoEn, postId: $postId, nombreCompleto: $nombreCompleto, carrera: $carrera, pfp: $pfp)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Comment &&
      other.id == id &&
      other.text == text &&
      other.creadoEn == creadoEn &&
      other.postId == postId &&
      other.nombreCompleto == nombreCompleto &&
      other.carrera == carrera &&
      other.pfp == pfp;
  }

  @override

  int get hashCode {
    return id.hashCode ^
      text.hashCode ^
      creadoEn.hashCode ^
      postId.hashCode ^
      nombreCompleto.hashCode ^
      carrera.hashCode ^
      pfp.hashCode;
  }
}