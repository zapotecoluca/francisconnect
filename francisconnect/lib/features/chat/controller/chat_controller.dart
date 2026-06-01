import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:francisconnect/features/auth/controller/auth_controller.dart';
import 'package:francisconnect/features/chat/repository/chat_repository.dart';

final chatControllerProvider =
    StateNotifierProvider<ChatController, bool>((ref) {
  return ChatController(
      chatRepository: ref.read(chatRepositoryProvider), ref: ref);
});

final userChatsProvider = StreamProvider.family((ref, String uid) {
  return ref.read(chatRepositoryProvider).getUserChats(uid);
});

final messagesProvider = StreamProvider.family((ref, String chatId) {
  return ref.read(chatRepositoryProvider).getMessages(chatId);
});

final isOnlineProvider = StreamProvider.family((ref, String uid) {
  return ref.read(chatRepositoryProvider).isUserOnline(uid);
});

class ChatController extends StateNotifier<bool> {
  final ChatRepository _chatRepository;
  final Ref _ref;

  ChatController({
    required ChatRepository chatRepository,
    required Ref ref,
  }) : _chatRepository = chatRepository,
    _ref = ref,
    super(false);

  Future<String> getOrCreateChat(String otherUid) async {
    final myUid = _ref.read(userProvider)!.uid;
    return await _chatRepository.getOrCreateChat(myUid, otherUid);
  }

  void sendMessage({
    required String chatId,
    required String texto,
    required String receiverUid,
    required BuildContext context,
  }) async {
    final myUid = _ref.read(userProvider)!.uid;
    await _chatRepository.sendMessage(
      chatId: chatId, 
      texto: texto, 
      senderUid: myUid, 
      receiverUid: receiverUid
    );
  }

  void markAsRead (String chatId, String uid) async {
    await _chatRepository.markAsRead(chatId, uid);
  }

  void updatePresence() async {
    final uid = _ref.read(userProvider)?.uid;
    if(uid != null) await _chatRepository.updateLastSeen(uid);
  }
}