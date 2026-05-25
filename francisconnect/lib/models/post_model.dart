import 'package:flutter/foundation.dart';

class Post {
  final String id;
  final String titulo;
  final String? link;
  final String? descripcion;
  final String forumName;
  final List<String> likes;
  final int commentCount;
  final String usuario;
  final String carrera;
  final String uid;
  final String type;
  final DateTime creadoEn;
  Post({
    required this.id,
    required this.titulo,
    this.link,
    this.descripcion,
    required this.forumName,
    required this.likes,
    required this.commentCount,
    required this.usuario,
    required this.carrera,
    required this.uid,
    required this.type,
    required this.creadoEn,
  });

  Post copyWith({
    String? id,
    String? titulo,
    String? link,
    String? descripcion,
    String? forumName,
    List<String>? likes,
    int? commentCount,
    String? usuario,
    String? carrera,
    String? uid,
    String? type,
    DateTime? creadoEn,
  }) {
    return Post(
      id: id ?? this.id, 
      titulo: titulo ?? this.titulo,
      forumName: forumName ?? this.forumName,
      likes: likes ?? this.likes,
      commentCount: commentCount ?? this.commentCount, 
      usuario: usuario ?? this.usuario,
      carrera: carrera ?? this.carrera,
      uid: uid ?? this.uid,
      type: type ?? this.type,
      creadoEn: creadoEn ?? this.creadoEn
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'link' : link,
      'descripcion': descripcion,
      'forumName': forumName,
      'likes': likes,
      'commentCount': commentCount,
      'usuario': usuario,
      'carrera': carrera,
      'uid': uid,
      'type': type,
      'creadoEn': creadoEn.millisecondsSinceEpoch,
    };
  }

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      id: map['id'] ?? '', 
      titulo: map['titulo'] ?? '',
      link: map['link'] ?? '',
      descripcion: map['descripcion'] ?? '',
      forumName: map['forumName'] ?? '', 
      likes: map['likes'] ?? '', 
      commentCount: map['commentCount'] ?? '', 
      usuario: map['usuario'] ?? '', 
      carrera: map['carrera'] ?? '',
      uid: map['uid'] ?? '', 
      type: map['type'] ?? '', 
      creadoEn: map['creadoEn'] ?? ''
    );
  }

  @override
  String toString() {
    return 'Post(id: $id, titulo: $titulo, link: $link, descripcion: $descripcion, forumName: $forumName, likes: $likes, commentCount: $commentCount, usuario: $usuario, carrera: $carrera, uid: $uid, type: $type, creadoEn: $creadoEn)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Post &&
    other.id == id &&
    other.titulo == titulo &&
    other.link == link &&
    other.descripcion == descripcion &&
    other.forumName == forumName &&
    listEquals(other.likes, likes) &&
    other.commentCount == commentCount &&
    other.usuario == usuario &&
    other.carrera == carrera &&
    other.uid == uid &&
    other.type == type &&
    other.creadoEn == creadoEn;
  }

  @override

  int get hashCode {
    return id.hashCode ^
      titulo.hashCode ^
      link.hashCode ^
      descripcion.hashCode ^
      forumName.hashCode ^
      likes.hashCode ^
      commentCount.hashCode ^
      usuario.hashCode ^
      carrera.hashCode ^
      uid.hashCode ^
      type.hashCode ^
      creadoEn.hashCode;
  }


}