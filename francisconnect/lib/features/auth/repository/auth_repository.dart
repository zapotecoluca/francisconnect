import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
//import 'package:francisconnect/core/constants/firebase_constants.dart';
import '../../../core/providers/firebase_providers.dart';
import '../../../models/user_model.dart';
import 'package:fpdart/fpdart.dart';



final authRepositoryProvider = Provider((ref)=> AuthRepository(
  firestore: ref.read(firestoreProvider),
  auth: ref.read(authProvider),
));

class AuthRepository {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  AuthRepository({
    required FirebaseAuth auth,
    required FirebaseFirestore firestore,
  }) : _auth = auth,
       _firestore = firestore;

  Stream<User?> get authStateChange => _auth.authStateChanges();

  CollectionReference get _users => _firestore.collection('users');

  bool _isValidEmail(String email) {
    return email.trim().toLowerCase().endsWith('@ufg.edu.sv');
  }


  //Registro 
  Future<Either<String, UserCredential>> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    try{
      if (!_isValidEmail(email)) {
        return left('Ingresa tu correo institucional');
      }

      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(), 
        password: password,
      );

      await _users.doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'email': email.trim().toLowerCase(),
        'nombre': '',
        'apellido': '',
        'facultad': '',
        'carrera': '',
        'pfp': '',
        'isProfileComplete': false,
      });

      return right(userCredential);

    } on FirebaseAuthException catch (e) {

      switch(e.code) {
        case 'email-already-in-use':
          return left('Este correo ya tiene una cuenta registrada');
        case 'weak-password':
          return left('La contraseña debe tener al menos 6 caracteres');
        default:
          return left(e.message ?? 'Error al crear la cuenta');
      }
    }
  }

  //Inicio de sesión

  Future<Either<String, UserCredential>> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      if (!_isValidEmail(email)) {
        return left('Utiliza tu cuenta institucional');
      }

      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email.trim(), 
        password: password);
      return right(userCredential);

    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
        case 'wrong-password':
        case 'invalid-credential':
          return left('Correo o contraseña incorrectos.');
        default:
          return left(e.message ?? 'Error al iniciar sesión');
      }
    }
  }

  //Cerrar sesión

  Future<void> signOut() async {
    await _auth.signOut();
  }

  //Get info de usuario

  Stream<UserModel> getUserData(String uid) {
    return _users.doc(uid).snapshots().map(
      (event) => UserModel.fromMap(event.data() as Map<String, dynamic>),
      );
  }

 

  //guardar perfil

  Future<Either<String,void>> saveUserProfile({
    required String uid,
    required String nombre,
    required String apellido,
    required String facultad,
    required String carrera,
    required String pfpUrl,
  }) async {
    try {

      await _users.doc(uid).update({
        'nombre': nombre.trim(),
        'apellido':apellido.trim(),
        'facultad':facultad,
        'carrera': carrera,
        'pfp': pfpUrl,
        'isProfileComplete': true,
      });
      return right(null);

    } catch (e) {
      return left('Error al guardar el perfil');
    }
  }

  //agregar connexión

  Future<void> addConnection(String myUid, String otherUid) async {
  final id = [myUid, otherUid]..sort();
  await _firestore.collection('connections').doc('${id[0]}_${id[1]}').set({
    'uids': [myUid, otherUid],
    'creadoEn': DateTime.now().millisecondsSinceEpoch,
  }, SetOptions(merge: true));
}
}