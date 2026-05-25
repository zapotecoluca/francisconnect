import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:francisconnect/core/constants/utils.dart';
import 'package:routemaster/routemaster.dart';
import 'package:francisconnect/core/constants/constants.dart';
import 'package:francisconnect/features/auth/controller/auth_controller.dart';
import 'package:francisconnect/features/foros/repository/forum_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:francisconnect/models/forum_model.dart';

final userForumsProvider = StreamProvider((ref) {
  final forumController = ref.watch(forumControllerProvider.notifier);
  return forumController.getUserForums();
});

final notInForumsProvider = StreamProvider((ref) {
  return ref.watch(forumControllerProvider.notifier).getUnsubscribedForums();
});

final getForumByIdProvider = StreamProvider.family((ref, String id) {
  return ref.watch(forumControllerProvider.notifier).getForumById(id);
});

final forumControllerProvider = StateNotifierProvider<ForumController, bool>((ref) {
  final forumRepository = ref.watch(forumRepositoryProvider);
  return ForumController(forumRepository: forumRepository, ref: ref);
});

final getForumByNameProvider = StreamProvider.family((ref, String nombre) {
  return ref.watch(forumControllerProvider.notifier).getForumByName(nombre);
});

class ForumController extends StateNotifier<bool> {  

  final ForumRepository _forumRepository;
  final Ref _ref;
  ForumController({
    required ForumRepository forumRepository,
    required Ref ref
  }): _forumRepository = forumRepository,
      _ref = ref, 
      super(false);
  
  void createForum(String nombre, String descripcion, BuildContext context) async{
    state = true;
    final uid = _ref.read(userProvider)?.uid ?? '';
    Forum forum = Forum(
      id: nombre, 
      nombre: nombre,
      admin: nombre, 
      banner: Constants.defaultBanner, 
      descripcion: descripcion,
      miembros: [uid]
    );

    final res = await _forumRepository.createForum(forum);
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) {
      showSnackBar(context, 'Foro creado exitosamente');
      Routemaster.of(context).pop();
    });
  }

  Stream<List<Forum>> getUserForums() {
    final uid =_ref.read(userProvider)!.uid;
    return _forumRepository.getUserForums(uid);
  }

  Stream<List<Forum>> getUnsubscribedForums() {
    final uid = _ref.read(userProvider)!.uid;
    return _forumRepository
          .getAllForums()
          .map((forums) => forums.where((f) => !f.miembros.contains(uid)).toList());
  }

  Stream<Forum> getForumByName(String nombre) {
    return _forumRepository.getForumByName(nombre);
  }

  Stream<Forum> getForumById(String id) {
    return _forumRepository.getForumById(id);
  }

  void joinForum(String forumId, BuildContext context) async {
    final uid = _ref.read(userProvider)?.uid ?? '';
    final res = await _forumRepository.joinForum(forumId, uid);
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) => showSnackBar(context, 'Ahora eres miembro de este foro')
    );
  }

  void leaveForum(String forumId, BuildContext context) async {
    final uid = _ref.read(userProvider)?.uid ?? '';
    final res = await _forumRepository.leaveForum(forumId, uid);
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) => showSnackBar(context, 'Ya no eres miembro de este foro'));
  }
}