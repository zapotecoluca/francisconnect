import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:francisconnect/core/providers/firebase_providers.dart';
import 'package:francisconnect/models/chat_model.dart';
import 'package:francisconnect/models/message_model.dart';
import 'package:francisconnect/models/user_model.dart';

final chatRepositoryProvider = Provider((ref) =>
  ChatRepository(firestore: ref.read(firestoreProvider)));

class ChatRepository {
  final FirebaseFirestore _firestore;
  ChatRepository({required FirebaseFirestore firestore})
    : _firestore = firestore;
  
  CollectionReference get _chats => _firestore.collection('chats');
  CollectionReference get _users => _firestore.collection('users');

  Future<String> getOrCreateChat(String myUid, String otherUid) async {
    final id = ChatModel.chatId(myUid, otherUid);
    final doc = await _chats.doc(id).get();
    if (!doc.exists) {
      await _chats.doc(id).set({
        'id': id,
        'participantes': [myUid, otherUid],
        'ultimoMensaje': '',
        'ultimoMensajeEn': DateTime.now().millisecondsSinceEpoch,
        'noLeidos': {myUid: 0, otherUid: 0}
      });
    }
    return id;
  }

  Future<void> sendMessage({
    required String chatId,
    required String texto,
    required String senderUid,
    required String receiverUid,
  }) async {
    final msgRef = _chats.doc(chatId).collection('messages').doc();
    final msg = MessageModel(
      id: msgRef.id, 
      texto: texto, 
      senderUid: senderUid, 
      enviadoEn: DateTime.now()
      );
    final batch = _firestore.batch();
    batch.set(msgRef, msg.toMap());
    batch.update(_chats.doc(chatId), {
      'ultimoMensaje': texto,
      'ultimoMensajeEn': DateTime.now().millisecondsSinceEpoch,
      'noLeidos.$receiverUid': FieldValue.increment(1)
    });
    await batch.commit();
  }

  Future<void> markAsRead(String chatId, String uid) async {
    await _chats.doc(chatId).update({'noLeidos.$uid': 0});
  }

  Stream<List<ChatModel>> getUserChats(String uid) {
    return _chats
      .where('participantes', arrayContains: uid)
      .orderBy('ultimoMensajeEn', descending: true)
      .snapshots()
      .map((snap) => snap.docs
        .map((d) => ChatModel.fromMap(d.data() as Map<String, dynamic>))
        .toList());
      
  }

  Stream<List<MessageModel>> getMessages(String chatId) {
    return _chats
        .doc(chatId)
        .collection('messages')
        .orderBy('enviadoEn', descending: false)
        .snapshots()
        .map((snap) => snap.docs
            .map((d) => MessageModel.fromMap(d.data()))
            .toList());
  }

  Future<UserModel> getUSerById(String uid) async {
    final doc = await _users.doc(uid).get();
    return UserModel.fromMap(doc.data() as Map<String, dynamic>);
  }

  Stream<bool> isUserOnline(String uid) {
    return _users.doc(uid).snapshots().map((snap) {
      final data = snap.data() as Map<String, dynamic>?;
      if (data == null) return false;
      final lastSeen = data['lastSeen'] as int? ?? 0;
      return DateTime.now().microsecondsSinceEpoch - lastSeen < 120000;
    });
  }

  Future<void> updateLastSeen(String uid) async {
    await _users.doc(uid).update({
      'lastSeen': DateTime.now().millisecondsSinceEpoch
    });
  }
  
}