import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:francisconnect/core/common/loader.dart';
import 'package:francisconnect/features/auth/controller/auth_controller.dart';
import 'package:francisconnect/features/chat/controller/chat_controller.dart';
import 'package:francisconnect/models/chat_model.dart';
import 'package:routemaster/routemaster.dart';

class ChatScreen extends ConsumerWidget {
  const ChatScreen({super.key});

   @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myUid = ref.watch(userProvider)?.uid ?? '';
    final chatsAsync = ref.watch(userChatsProvider(myUid));

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              'Mis mensajes',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: chatsAsync.when(
              data: (chats) => chats.isEmpty
                ? const Center(
                  child: Text('Nada que ver por aquí'),
                )
                : ListView.builder(
                  itemCount: chats.length,
                  itemBuilder: (context, i) => _ChatTile(chat: chats[i], myUid: myUid),
                ), 
              error: (e, _) => Center(child: Text('Error: $e'),), 
              loading: () => const Loader()))
        ],
      ),
    );
  }
}

class _ChatTile extends ConsumerWidget{
  final ChatModel chat;
  final String myUid;
  const _ChatTile({required this.chat, required this.myUid});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final otherUid = chat.participantes.firstWhere((uid) => uid != myUid);
    final userAsync = ref.watch(getUserDataProvider(otherUid));
    final unread = chat.noLeidos[myUid] ?? 0;

    return userAsync.when(
      data: (other) => ListTile(
        onTap: () => Routemaster.of(context).push('/chat/${chat.id}/$otherUid'),
        leading: CircleAvatar(
          radius: 24,
          backgroundImage: other.pfp.isNotEmpty
            ? NetworkImage(other.pfp)
            : null,
          child: other.pfp.isEmpty
            ? const Icon(Icons.person)
            : null
        ),
        title: Text(
          other.nombreCompleto,
          style: TextStyle(
            fontWeight: unread > 0 ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _formatTime(chat.ultimoMensajeEn),
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
            if (unread > 0)
              Container(
                margin: const EdgeInsets.only(top: 4),
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
              )
          ],
        ),
      ), 
      error: (_, __) => const SizedBox(),
      loading: () => const SizedBox(height: 72)
    );
  }

  String _formatTime(DateTime dt) {
    final now = DateTime.now();
    if(dt.day == now.day) {
      return'${dt.hour}:${dt.minute.toString().padLeft(2, '0')}';
    }

    return '${dt.day}';
  }
}