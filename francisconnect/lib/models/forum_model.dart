import 'package:flutter/foundation.dart';

class Forum {
  final String id;
  final String nombre;
  final String admin;
  final String banner;
  final String descripcion;
  final List<String> miembros;
  Forum({
    required this.id,
    required this.nombre,
    required this.admin,
    required this.banner,
    required this.descripcion,
    required this.miembros,
  });

  Forum copyWith({
    String? id,
    String? nombre,
    String? admin,
    String? banner,
    String? descripcion,
    List<String>? miembros,
  }) {
    return Forum(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      admin: admin ?? this.admin, 
      banner: banner ?? this.banner, 
      descripcion: descripcion ?? this.descripcion, 
      miembros: miembros ?? this.miembros,
      );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'admin': admin,
      'banner': banner,
      'descripcion': descripcion,
      'miembros': miembros,
    };
  }

  factory Forum.fromMap(Map<String, dynamic> map) {
    return Forum(
      id: map['id'] ?? '', 
      nombre: map['nombre'] ?? '', 
      admin: map['admin'] ?? '',
      banner: map['banner'] ?? '', 
      descripcion: map['descripcion'] ?? '', 
      miembros: List<String>.from(map['miembros']),
    );
  }

  @override
  String toString() {
    return 'Forum(id: $id, nombre: $nombre, asdmin: $admin, banner: $banner, descripcion: $descripcion, miembros: $miembros)';
  }

  @override
  bool operator == (Object other) {
    if (identical(this, other)) return true;

    return other is Forum &&
      other.id == id &&
      other.nombre == nombre &&
      other.admin == admin &&
      other.banner == banner &&
      other.descripcion == descripcion &&
      listEquals(other.miembros, miembros);
  }

  @override
  int get hashCode {
    return id.hashCode ^ nombre.hashCode ^admin.hashCode ^banner.hashCode ^ descripcion.hashCode ^ miembros.hashCode;
  }

}
