import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../../core/providers/firebase_providers.dart';
import '../../../models/user_model.dart';
import 'package:francisconnect/features/auth/repository/auth_repository.dart';

final userProvider = StateProvider<UserModel?>((ref) => null);

final authControllerProvider = StateNotifierProvider<AuthController, bool>(
  (ref) {return AuthController(
    authRepository: ref.watch(authRepositoryProvider),
    ref: ref,
  );
  });

final authStateChangeProvider = StreamProvider((ref) {
  return ref.read(authProvider).authStateChanges();
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
      required String facultad,
      required String carrera,
      File? pfpFile, 
      required BuildContext context,
    }) async {
      state = true;
      final uid = _ref.read(authProvider).currentUser!.uid;

      String profilePicUrl = '';

      if (pfpFile != null) {
        try {
          final ref = _ref
            .read(storageProvider)
            .ref()
            .child('pfps')
            .child(uid);
        await ref.putFile(pfpFile);
        profilePicUrl = await ref.getDownloadURL();
        } catch (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text(
                'No se pudo subir la foto, inténtalo más tarde'
              ))
            );
          }
          profilePicUrl = '';
        }
      }

      final result = await _authRepository.saveUserProfile(
        uid: uid,
        nombre: nombre,
        apellido: apellido,
        facultad: facultad,
        carrera: carrera,
        pfpUrl: profilePicUrl,
      );
      state = false;

      result.fold(
        (error) {
          if (context.mounted) _showSnackbar(context, error);
        },
        (_) {
          if (context.mounted) {
            Navigator.pushReplacementNamed(context, '/home');
          }
        }
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