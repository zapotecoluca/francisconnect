import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:francisconnect/models/post_model.dart';
import 'package:francisconnect/features/auth/controller/auth_controller.dart';
import 'package:francisconnect/theme/palette.dart';
import 'package:routemaster/routemaster.dart';

class PostCard extends ConsumerWidget{
  final Post post;
  final bool showForum;
  final bool isMember;

  const PostCard({
    super.key,
    required this.post,
    required this.showForum,
    this.isMember = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUid = ref.watch(userProvider)?.uid ?? '';
    final liked = post.likes.contains(currentUid);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: Colors.grey.shade300,
                backgroundImage: post.pfp.isNotEmpty
                  ? NetworkImage(post.pfp)
                  : null,
                child: post.pfp.isEmpty
                  ? const Icon(Icons.person, color: Palette.whiteColor)
                  : null,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    showForum
                      ? RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 14,
                            color: Palette.blackColor
                          ),
                          children: [
                            TextSpan(
                              text: post.nombreCompleto,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700
                              )
                            ), 
                            const TextSpan(text: ' ▸ '),
                            TextSpan(
                              text: post.forumName,
                              style: TextStyle(
                                color: Palette.accent2,
                                fontWeight: FontWeight.w600,
                              )
                            )
                          ]
                        )
                      )
                      : Text(
                        post.nombreCompleto,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 14
                        ),
                      ),
                    Text(
                      post.carrera,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(post.descripcion ?? post.titulo,
            style: const TextStyle(fontSize: 14)
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              GestureDetector(
                onTap: isMember ? () {} : null,
                child: Icon(
                  liked ? Icons.favorite : Icons.favorite_border,
                  color: liked ? Palette.accent3 : Colors.grey,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: () => Routemaster.of(context).push('/post/${post.id}'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Sé parte de la conversación',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600
                      ),
                    ),
                  ),
                )
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => Routemaster.of(context).push('/post/${post.id}'),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Palette.accent2,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: Image.asset('assets/images/comment_icon.png', color: Palette.whiteColor),
                  ),
                ),
              )
            ],
          ),
          const Divider(height: 20)
        ],
      ),
    );
  }
}