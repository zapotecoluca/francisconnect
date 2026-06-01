import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:francisconnect/core/common/loader.dart';
import 'package:francisconnect/core/constants/constants.dart';
import 'package:francisconnect/features/auth/controller/auth_controller.dart';
import 'package:francisconnect/features/chat/controller/chat_controller.dart';
import 'package:francisconnect/theme/palette.dart';
import 'package:routemaster/routemaster.dart';

class ConversationScreen extends ConsumerStatefulWidget {
  final String chatId;
  final String otherUid;
  const ConversationScreen({ super.key, required this.chatId, required this.otherUid});

  @override
  ConsumerState<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends ConsumerState<ConversationScreen> {
  final _msgController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final myUid = ref.read(userProvider)?.uid ?? '';
    ref.read(chatControllerProvider.notifier).markAsRead(widget.chatId, myUid);
  }
  @override
  void dispose() {
    _msgController.dispose();
    super.dispose();
  }

  void _send() {
    final text = _msgController.text.trim();
    if (text.isEmpty) return;
    ref.read(chatControllerProvider.notifier).sendMessage(
      chatId: widget.chatId, 
      texto: text, 
      receiverUid: widget.otherUid, 
      context: context);
    _msgController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final myUid = ref.watch(userProvider)?.uid ?? '';
    final otherAsync = ref.watch(getUserDataProvider(widget.otherUid));
    final messagesAsync = ref.watch(messagesProvider(widget.chatId));
    final isOnlineAsync = ref.watch(isOnlineProvider(widget.otherUid));

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Routemaster.of(context).pop(), 
          icon: const Icon(Icons.arrow_back_ios)
        ),
        title: Image.asset(Constants.blackLogoPath, height: 50,),
        centerTitle: true,
        backgroundColor: Palette.whiteColor,
        elevation: 1,
      ),
      body: Column(
        children: [
          otherAsync.when(
            data: (other) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: Palette.blu,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(30),
                    bottomRight: Radius.circular(30)
                  )
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20, vertical: 10
                ),
                child: IntrinsicWidth(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        other.nombreCompleto,
                        style:  TextStyle(
                          color: Palette.whiteColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w700
                        ),
                      ),
                      isOnlineAsync.when(
                        data: (online) => Text(
                          online ? 'Conectado' : 'Desconectado',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 11
                          ),
                        ), 
                        error: (_, __) => const SizedBox(), 
                        loading: () => const SizedBox()
                      )
                    ],
                  ),
                ),
              ),
            ), 
            error: (_, __) => const SizedBox(), 
            loading: () => const SizedBox(height: 50)
          ),
          Expanded(
            child: messagesAsync.when(
              data: (messages) => ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12, 
                  vertical: 8
                ),
                itemCount: messages.length,
                itemBuilder: (context, i) {
                  final msg = messages[i];
                  final isMe = msg.senderUid == myUid;
                  return Align(
                    alignment: isMe
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                    child: Container(
                      margin:  const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14, 
                        vertical: 10
                      ),
                      constraints: BoxConstraints(
                        maxWidth:
                            MediaQuery.of(context).size.width * 0.72,
                      ),
                      decoration: BoxDecoration(
                        color: isMe
                            ? Colors.grey.shade200
                            : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: isMe
                            ? null
                            : Border.all(color: Colors.grey.shade200),
                      ),
                      child: Text(
                        msg.texto,
                        style:  const TextStyle(fontSize: 14),
                      ),
                    ),
                  );
                },
              ), 
              error: (e, _ ) => Center(child: Text('Error: $e'),), 
              loading: () => const Loader()
            )
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey.shade200)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _msgController,
                    maxLines: null,
                    textInputAction: TextInputAction.newline,
                    decoration: InputDecoration(
                      hintText: 'Nuevo mensaje',
                      hintStyle: TextStyle(color: Colors.grey.shade400),
                      border: InputBorder.none
                    ),
                  ),
                ),
                IconButton(
                    onPressed: _send,
                    icon: Icon(Icons.send_rounded,
                      color: Palette.accent2, size: 28)
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}