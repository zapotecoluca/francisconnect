import 'package:flutter/foundation.dart';

class UserModel {
  final String name;
  final String lastname;
  final String username;
  final String profilePic;
  final String uid;
  final String email;
  

  UserModel({
    required this.name,
    required this.lastname,
    required this.username,
    required this.profilePic,
    required this.uid,
    required this.email,
  });

  UserModel copyWith({
    String? name,
    String? lastname,
    String? username,
    String? profilePic,
    String? uid,
    String? email,
  }) {
    return UserModel(
      name: name ?? this.name, 
      lastname: lastname?? this.lastname,
      username: username?? this.username,
      profilePic: profilePic?? this.profilePic,
      uid: uid?? this.uid,
      email: email?? this.email,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'lastname': lastname,
      'username': username,
      'profilePic': profilePic,
      'uid': uid,
      'email': email,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? '', 
      lastname: map['lastname'] ?? '', 
      username: map['username'] ?? '', 
      profilePic: map['profilePic'] ?? '', 
      uid: map['uid'] ?? '', 
      email: map['email']?? ''
    );
  }


  @override
  String toString() {
    return 'Usermodel(name: $name, lastname: $lastname, username: $username, profilePic: $profilePic, uid: $uid, email: $email)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModel &&
      other.name == name &&
      other.lastname == lastname &&
      other.username == username &&
      other.profilePic == profilePic &&
      other.uid == uid &&
      other.email == email;
  }

  @override

  int get hashCode {
    return name.hashCode ^
        lastname.hashCode ^
        username.hashCode ^
        profilePic.hashCode ^
        uid.hashCode ^
        email.hashCode;
  }
}