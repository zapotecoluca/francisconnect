import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:francisconnect/core/common/error_text.dart';
import 'package:francisconnect/core/common/loader.dart';
import 'package:francisconnect/features/foros/controller/forum_controller.dart';
import 'package:francisconnect/models/forum_model.dart';
import 'package:routemaster/routemaster.dart';

class ForumListDrawer extends ConsumerWidget {
  const ForumListDrawer({super.key});

  void navigateToCreateForum(BuildContext context) {
    Routemaster.of(context).push('/create-forum');
  }

  void navigateToForum(BuildContext context, Forum forum) {
    Routemaster.of(context).push('/fc-${forum.nombre}');
  }


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            ListTile(
              title: const Text(
                'Crear foro'
              ),
              leading: const Icon(Icons.add),
              onTap: () {
                navigateToCreateForum(context);
              },
            ),
            ref.watch(userForumsProvider).when(
              data: (forums) => Expanded (
                child: ListView.builder(
                  itemCount: forums.length,
                  itemBuilder: (BuildContext context, int index) {
                    final forum = forums[index];
                    return ListTile(
                      title: Text('${forum.nombre}'),
                      onTap: () {
                        navigateToForum(context, forum);
                      },
                    );
                  }
                ), 
              ),
              error: (error, stackTrace) => ErrorText(error: error.toString()), 
              loading: () => const Loader()
            ),
          ],
        )
        ),
    );
  }
}