import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../../core/providers/firebase_providers.dart';
import '../../../models/user_model.dart';
import '../repository/auth_repository.dart';

final authControllerProvider = StateNotifierProvider<AuthController, bool>(
  (ref) {return AuthController(
    authRepository: ref.read(authRepositoryProvider),
    ref: ref,
  );
  });

final authStateChangeProvider = StreamProvider((ref) {
  final controller = ref.watch(authControllerProvider.notifier);
  return controller.authStateChange;
});

final getUserDataProvider =StreamProvider.family((ref, String uid) {
  final controller = ref.watch(authControllerProvider.notifier);
  return controller.getUserData(uid);
});

class AuthController extends StateNotifier<bool>{
  final AuthRepository _authRepository;
  final Ref _ref;

  AuthController({required AuthRepository authRepository, required Ref ref})
    :_authRepository = authRepository,
    _ref = ref,
    super(false);

  Stream<UserModel> getUserData(String uid) =>
    _authRepository.getUserData(uid);

  void signUp({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    state = true;
    final result = await _authRepository.signUpWithEmail(
      email: email,
      password: password);
    state = false;
    result.fold(
      (error) => _showSnackbar(context, error),
      (userCredential) {
        Navigator.pushReplacementNamed(context, '/create-profile');
      },
    );
  }

  void signIn({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    state = true;
    final result = await _authRepository.signInWithEmail(
      email: email,
      password: password);
    state = false;
    result.fold(
      (error) => _showSnackbar(context, error),
      (userCredential) async {
        final uid = userCredential.user!.uid;
        final userDoc = await _ref
          .read(firestoreProvider)
          .collection('users')
          .doc(uid)
          .get();
        final isProfileComplete =userDoc.data()?['isProfileComplete'] ?? false;

        if (isProfileComplete) {
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          Navigator.pushReplacementNamed(context, '/create-profile');
        }
      }
    );
  }
  
  void saveProfile({
    required String nombre,
    required String apellido,
    required String usuario,
    required String facultad,
    required String carrera,
    File? pfp, 
    required BuildContext context,
  }) async {
    state = true;
    final uid = _ref.read(authProvider).currentUser!.uid;

    String profilePicUrl = '';
    if (pfp != null) {
      final ref = _ref
          .read(storageProvider)
          .ref()
          .child('pfps')
          .child(uid);
      await ref.putFile(pfp);
      profilePicUrl = await ref.getDownloadURL();
    }

     final result = await _authRepository.saveUserProfile(
      uid: uid,
      nombre: nombre,
      apellido: apellido,
      usuario: usuario,
      facultad: facultad,
      carrera: carrera,
      pfpUrl: profilePicUrl,
    );
    state = false;
    result.fold(
      (error) => _showSnackbar(context, error),
      (_) => Navigator.pushReplacementNamed(context, '/home'),
    );
  }

  void signOut() async {
    await _authRepository.signOut();
  }

  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

}