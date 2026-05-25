import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:francisconnect/core/common/error_text.dart';
import 'package:francisconnect/core/common/loader.dart';
import 'package:francisconnect/features/foros/controller/forum_controller.dart';
import 'package:francisconnect/models/forum_model.dart';
import 'package:francisconnect/theme/palette.dart';
import 'package:routemaster/routemaster.dart';

class ForumMenu extends ConsumerWidget {
  const ForumMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final forumsAsync = ref.watch(userForumsProvider);

    return forumsAsync.when(
      data: (forums) => ListView(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        children: [
          const Text('Foros Inscritos',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12,),
          
          if(forums.isEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Center(
                child: Text('Aún no te has inscrito en ningún foro. \nExplora y únete a uno.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Palette.darkGreyColor,
                    fontSize: 15
                  ),
                ),
              ),
            ),
          ] else ...[
            ...forums.map((forum) => _ForumBannerCard (
              forum: forum,
              onTap: () => Routemaster.of(context).push('/fc-${forum.id}')
            ))
          ],
          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () => Routemaster.of(context).push('/explore-forums'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Palette.tertiary,
                foregroundColor: Palette.whiteColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)
                ),
              ), 
              child: const Text('Explorar',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)
              ),
            ),
          ),
          SizedBox(height: 12),

          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () => Routemaster.of(context).push('/create-forum'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Palette.accent2,
                foregroundColor: Palette.whiteColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)
                ),
              ), 
              child: const Text('Crear foro',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)
              ),
            ),
          ),
          SizedBox(height: 24),
        ],
      ), 
      error: (e, _) => ErrorText(error: e.toString()), 
      loading: () => const Loader()
    );
  }
  
}

class _ForumBannerCard extends StatelessWidget {
  final Forum forum;
  final VoidCallback onTap;

  const _ForumBannerCard({required this.forum, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        height: 100,
        decoration: BoxDecoration( borderRadius: BorderRadius.circular(8)),
        clipBehavior: Clip.hardEdge,
        child: Stack(
          fit: StackFit.expand,
          children: [
            forum.banner.startsWith('http')
              ? Image.network(forum.banner, fit: BoxFit.cover)
              : Image.asset(forum.banner, fit: BoxFit.cover),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Palette.blackColor.withValues(alpha: 0.55),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
            Positioned(
              left: 12,
              bottom: 12,
              child: Text(
                forum.nombre,
                style: const TextStyle(
                  color: Palette.whiteColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  shadows: [Shadow(blurRadius: 4, color: Palette.blackColor)],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}