import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:francisconnect/core/constants/constants.dart';
import 'package:francisconnect/features/auth/controller/auth_controller.dart';
import 'package:francisconnect/theme/palette.dart';
import 'package:routemaster/routemaster.dart';

class UserProfileScreen extends ConsumerWidget{
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);

    if(user == null) return const SizedBox();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Routemaster.of(context).pop(), 
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: Image.asset(Constants.blackLogoPath, height: 50),
        centerTitle: true,
        backgroundColor: Palette.whiteColor,
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 8),
            const Text(
              'Perfil',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w700
              ),
            ),
            SizedBox(height: 20),
            CircleAvatar(
              radius: 54,
              backgroundColor: Palette.lightGreyColor,
              backgroundImage: user.pfp.isNotEmpty
                ? NetworkImage(user.pfp)
                : const AssetImage(Constants.defaultPfp) as ImageProvider,
            ),
            const SizedBox(height: 10),
            Text(
              user.email,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey
              ),            
            ),
            const SizedBox(height: 20),
            _InfoTile(text: '${user.nombreCompleto}'),
            const SizedBox(height: 10,),
            _InfoTile(text: user.facultad),
            const SizedBox(height: 10,),
            _InfoTile(text: user.carrera),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton(
                onPressed: () => Routemaster.of(context).push('/edit-profile'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Palette.tertiary,
                  foregroundColor: Palette.whiteColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)
                  )
                ), 
                child: const Text('Editar perfil',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700
                  ),
                )
              ),
            ),
            const SizedBox(height: 12,),
            TextButton(
              onPressed: () {
                ref.read(authControllerProvider.notifier).signOut();
                Routemaster.of(context).replace('/');
              },
              child: Text(
                'Cerrar sesión',
                style: TextStyle(
                  color: Palette.tertiary,
                  fontWeight: FontWeight.w600,
                  fontSize: 15
                ),
              )
            )
            
          ],
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget{
  final String text;
  const _InfoTile({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8)
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 15),
      ),
    );
  }
}