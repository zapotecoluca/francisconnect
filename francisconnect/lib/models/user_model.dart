
class UserModel {
  final String uid;
  final String email;
  final String nombre;
  final String apellido;
  final String usuario;
  final String facultad;
  final String carrera;
  final String pfp; //profile-picture => foto de perfil
  final bool isProfileComplete;

  UserModel({
    required this.uid,
    required this.email,
    required this.nombre,
    required this.apellido,
    required this.usuario,
    required this.facultad,
    required this.carrera,
    required this.pfp,
    required this.isProfileComplete
  });

  UserModel copyWith({
    String? nombre,
    String? apellido,
    String? usuario,
    String? facultad,
    String? carrera,
    String? pfp,
    bool? isProfileComplete,
    
  }) {
    return UserModel(
      uid: uid,
      email: email,
      nombre: nombre ?? this.nombre, 
      apellido: apellido?? this.apellido,
      usuario: usuario?? this.usuario,
      facultad: facultad?? this.facultad,
      carrera: carrera?? this.carrera,
      pfp: pfp?? this.pfp,
      isProfileComplete: isProfileComplete?? this.isProfileComplete,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'nombre': nombre,
      'apellido': apellido,
      'usuario': usuario,
      'facultad': facultad,
      'carrera': carrera,
      'profilePic': pfp,
      'isProfileComplete': isProfileComplete,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      nombre: map['nombre'] ?? '', 
      apellido: map['apellido'] ?? '', 
      usuario: map['usuario'] ?? '', 
      facultad: map['facultad'] ?? '', 
      carrera: map['carrera']?? '',
      pfp: map['pfp'] ?? '',
      isProfileComplete: map['isProfileComplete'] ?? false,
    );
  }


  @override
  String toString() {
    return 'Usermodel(name: $nombre, lastname: $apellido, username: $usuario, profilePic: $pfp, uid: $facultad, carrera: $carrera)';
  }

}