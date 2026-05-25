import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:francisconnect/core/constants/firebase_constants.dart';
import 'package:francisconnect/core/failure.dart';
import 'package:francisconnect/core/providers/firebase_providers.dart';
import 'package:francisconnect/core/type_defs.dart';
import 'package:francisconnect/models/forum_model.dart';

final forumRepositoryProvider = Provider((ref) {
  return ForumRepository(firestore: ref.watch(firestoreProvider));
});

class ForumRepository {
  final FirebaseFirestore _firestore;
  ForumRepository({required FirebaseFirestore firestore}): _firestore = firestore;

  FutureVoid createForum(Forum forum) async {
    try {
      var forumDoc = await _forums.doc(forum.nombre).get();
      if (forumDoc.exists) {
        throw 'Ya existe un foro con ese nombre';
      }
      return right(_forums.doc(forum.nombre).set(forum.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<Forum>> getUserForums(String uid) {
    return _forums.where('miembros', arrayContains: uid).snapshots().map((event) {
      List<Forum> forums = [];
      for(var doc in event.docs) {
        forums.add(Forum.fromMap(doc.data() as Map<String, dynamic>));
      }
      return forums;
    });
  }
  
 Stream<Forum> getForumById(String id) {
    return _forums.doc(id).snapshots().map((event) 
    => Forum.fromMap(event.data() as Map<String, dynamic>));
  }

  Stream<Forum> getForumByName(String nombre) {
    return _forums.doc(nombre).snapshots().map((event) 
    => Forum.fromMap(event.data() as Map<String, dynamic>));
  }

  Stream<List<Forum>> getAllForums() {
    return _forums.snapshots().map((event)
    => event.docs.map((doc)
    => Forum.fromMap(doc.data() as Map<String, dynamic>)).toList());
  }

  FutureVoid joinForum(String forumId, String uid) async {
    try {
      await _forums.doc(forumId).update({
        'miembros': FieldValue.arrayUnion([uid])
      });
      return right(null);
    } on FirebaseException catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureVoid leaveForum(String forumId, String uid) async {
    try {
      await _forums.doc(forumId).update({
          'miembros': FieldValue.arrayRemove([uid]),
      });
      return right(null);
    } on FirebaseException catch (e) {
      return left(Failure(e.message!));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

 

  CollectionReference get _forums => _firestore.collection(FirebaseConstants.forumsCollection);
}

