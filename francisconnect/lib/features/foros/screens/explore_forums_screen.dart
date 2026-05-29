import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:francisconnect/core/common/error_text.dart';
import 'package:francisconnect/core/common/loader.dart';
import 'package:francisconnect/core/constants/constants.dart';
import 'package:francisconnect/features/foros/controller/forum_controller.dart';
import 'package:francisconnect/features/foros/delegate/search_forum_delegate.dart';
import 'package:francisconnect/models/forum_model.dart';
import 'package:francisconnect/theme/palette.dart';
import 'package:routemaster/routemaster.dart';

class ExploreForumsScreen extends ConsumerWidget {
  const ExploreForumsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final forumsAsync = ref.watch(notInForumsProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Routemaster.of(context).pop(),
        ),
        title: Image.asset(Constants.blackLogoPath, height: 50),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              showSearch(
                context: context, 
                delegate: SearchForumDelegate(ref)
              );
            }, 
            icon: const Icon(Icons.search)
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: forumsAsync.when(
        data: (forums) => forums.isEmpty
        ? const Center(child: Text('Nada que ver por aquí'))
        : ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          itemCount: forums.length,
          itemBuilder: (context, index) {
            final forum = forums[index];
            return _ForumBannerCard(forum: forum);
          },
        ), 
        error: (e, _) => ErrorText(error: e.toString()), 
        loading: () => const Loader()),
    );
  }
}

class _ForumBannerCard extends ConsumerWidget {
  final Forum forum;
  const _ForumBannerCard({required this.forum});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => Routemaster.of(context).push('/fc/${forum.id}'),
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
            ),

            Positioned(
              right: 10,
              bottom: 10,
              child: GestureDetector(
                onTap: () => ref.read(forumControllerProvider.notifier).joinForum(forum.id, context),
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: const BoxDecoration(
                    color: Palette.primary,
                    shape: BoxShape.circle
                  ),
                  child: const Icon(Icons.add, 
                    color: Palette.whiteColor, 
                    size: 20
                  ),
                ),
              ))
          ],
        ),
      ),
    );
  }
}