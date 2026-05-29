import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:francisconnect/core/common/error_text.dart';
import 'package:francisconnect/core/common/loader.dart';
import 'package:francisconnect/features/foros/controller/forum_controller.dart';
import 'package:routemaster/routemaster.dart';

class SearchForumDelegate extends SearchDelegate {
  final WidgetRef ref;
  SearchForumDelegate(this.ref);

  @override
  List <Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.close),
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return null;
  }

  @override
  Widget buildResults(BuildContext context) {
    return const SizedBox();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return ref.watch(searchForumProvider(query)).when(
      data: (forums) => ListView.builder(
        itemCount: forums.length,
        itemBuilder: (BuildContext context, int index) {
          final forum = forums[index];
          return ListTile(
            leading: Image.asset(forum.banner),
            title: Text('${forum.nombre}'),
            onTap: () => navigateToForum(context, forum.nombre),
          );
        },
      ),
      error: (error, stackTrace) => ErrorText(error: error.toString()),
      loading: () => const Loader());
  }

  void navigateToForum(BuildContext context, String forumname) {
    Routemaster.of(context).push('/fc/$forumname');
  }
}