import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:francisconnect/core/constants/constants.dart';
import 'package:francisconnect/features/auth/controller/auth_controller.dart';
import 'package:francisconnect/features/chat/controller/chat_controller.dart';
import 'package:francisconnect/theme/palette.dart';
import 'package:routemaster/routemaster.dart';
import 'package:francisconnect/features/auth/repository/auth_repository.dart';

class OtherUserProfileScreen extends ConsumerWidget {
  final String uid;
  const OtherUserProfileScreen({super.key, required this.uid});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final otherAsync = ref.watch(getUserDataProvider(uid));
    final myUid = ref.watch(userProvider)?.uid ?? '';

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Routemaster.of(context).pop(),
        ),
        title: Image.asset(Constants.blackLogoPath, height: 50),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: otherAsync.when(
        data: (other) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 8),
              const Text('Perfil',
                  style: TextStyle(
                      fontSize: 26, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),

              CircleAvatar(
                radius: 54,
                backgroundColor: Colors.grey.shade300,
                backgroundImage: other.pfp.isNotEmpty
                    ? NetworkImage(other.pfp)
                    : const AssetImage(Constants.defaultPfp)
                        as ImageProvider,
              ),
              const SizedBox(height: 20),

              // Full name
              _InfoTile(text: other.nombreCompleto),
              const SizedBox(height: 10),
              _InfoTile(text: other.facultad),
              const SizedBox(height: 10),
              _InfoTile(text: other.carrera),
              const SizedBox(height: 28),

              // Enviar mensaje button
              SizedBox(
                width: double.infinity,
                height: 46,
                child: ElevatedButton(
                  onPressed: () async {
                    final chatId = await ref
                        .read(chatControllerProvider.notifier)
                        .getOrCreateChat(other.uid);
                    if (context.mounted) {
                      Routemaster.of(context)
                          .push('/chat/$chatId/${other.uid}');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Palette.accent2,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Enviar mensaje',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 12),

              // Conectar button
              SizedBox(
                width: double.infinity,
                height: 46,
                child: OutlinedButton(
                  onPressed: () {
                    // Store connection in Firestore
                    ref
                        .read(authRepositoryProvider)
                        .addConnection(myUid, other.uid);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(
                              'Conectado con ${other.nombre}')),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Palette.tertiary,
                    side: BorderSide(color: Palette.tertiary),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Conectar',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final String text;
  const _InfoTile({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(text, style: const TextStyle(fontSize: 15)),
    );
  }
}