import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:francisconnect/core/common/error_text.dart';
import 'package:francisconnect/core/common/loader.dart';
import 'package:francisconnect/core/constants/constants.dart';
import 'package:francisconnect/features/auth/controller/auth_controller.dart';
import 'package:francisconnect/features/foros/controller/forum_controller.dart';
import 'package:francisconnect/theme/palette.dart';
import 'package:routemaster/routemaster.dart';

class ForumScreen extends ConsumerWidget {
  final String nombre;
  const ForumScreen({super.key, required this.nombre});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final forumAsync = ref.watch(getForumByNameProvider(nombre));
    final currentUser = ref.watch(userProvider);
    final currentUid = currentUser?.uid ?? '';

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Routemaster.of(context).pop(), 
          icon: Icon(Icons.arrow_back_ios)
        ),
        title: Image.asset(Constants.blackLogoPath, height: 50),
        centerTitle: true,
        elevation: 1,
      ),
      body: forumAsync.when(
        data: (forum) {
          final isMember = forum.miembros.contains(currentUid);

          return Column(
            children: [
              Container(
                width: double.infinity,
                color: Palette.accent2,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16
                ),
                child: Text(forum.nombre,
                  style: const TextStyle(
                    color: Palette.whiteColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w700
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16
                  ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(forum.descripcion,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Palette.blackColor
                      )
                    ),
                    const SizedBox(height: 12),

                    SizedBox(
                      width: double.infinity,
                      height: 42,
                      child: ElevatedButton(
                        onPressed: () {
                          if (isMember) {
                            ref.read(forumControllerProvider.notifier).leaveForum(forum.id, context);
                          } else {
                            ref.read(forumControllerProvider.notifier).joinForum(forum.id, context);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isMember ? Palette.accent5 : Palette.tertiary,
                          foregroundColor: Palette.whiteColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)
                          ),
                        ),
                        child: Text(
                          isMember ? 'Dejar foro' : 'Unirse',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15
                          ),
                        ),
                      ),
                    ),
                    if (isMember) ...[
                        const SizedBox(height: 12),
                        GestureDetector(
                          onTap: () => Routemaster.of(context).push('/create-post/${forum.id}'),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: Palette.lightGreyColor),
                              borderRadius: BorderRadius.circular(8)
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Expresa lo que piensas...', 
                                  style: TextStyle(
                                    color: Palette.darkGreyColor,
                                    fontSize: 14
                                  ),
                                ),
                                Icon(Icons.edit_outlined, color: Colors.grey[500]),
                              ],
                            ),
                          ),
                        )
                      ]
                    ],
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: Center(
                    child: Text('posts placeholder'),
                  )
                )
            ],
          );
        }, 
        error: (e, _) => ErrorText(error: e.toString()), 
        loading: () => const Loader())
    );
  }
}