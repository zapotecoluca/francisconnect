import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:francisconnect/core/providers/firebase_providers.dart';
import 'package:francisconnect/models/user_model.dart';
import 'package:francisconnect/theme/palette.dart';
import 'package:routemaster/routemaster.dart';

final _userSearchQueryProvider = StateProvider<String>((ref) => '');

final userSearchResultsProvider =
    StreamProvider.family((ref, String query) {
  if (query.trim().isEmpty) {
    return Stream.value(<UserModel>[]);
  }
  final q = query.trim().toLowerCase();
  return ref
      .read(firestoreProvider)
      .collection('users')
      .where('nombre', isGreaterThanOrEqualTo: q)
      .where('nombre', isLessThanOrEqualTo: '$q\uf8ff')
      .limit(10)
      .snapshots()
      .map((snap) => snap.docs
          .map((d) => UserModel.fromMap(d.data()))
          .toList());
});

class FeedScreen extends ConsumerWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final query = ref.watch(_userSearchQueryProvider);
    final searchResults = ref.watch(userSearchResultsProvider(query));

    return Column(
      children: [
        // ── Search bar ───────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
          child: TextField(
            onChanged: (val) =>
                ref.read(_userSearchQueryProvider.notifier).state = val,
            decoration: InputDecoration(
              hintText: 'Buscar estudiante...',
              hintStyle: TextStyle(color: Colors.grey[400]),
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              filled: true,
              fillColor: Colors.grey.shade100,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
            ),
          ),
        ),

        // ── Search results overlay ────────────────────────────────────
        if (query.isNotEmpty)
          searchResults.when(
            data: (users) => users.isEmpty
                ? const Padding(
                    padding: EdgeInsets.all(12),
                    child: Text('Sin resultados'),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: users.length,
                    itemBuilder: (context, i) {
                      final u = users[i];
                      return ListTile(
                        onTap: () => Routemaster.of(context)
                            .push('/profile/${u.uid}'),
                        leading: CircleAvatar(
                          backgroundImage: u.pfp.isNotEmpty
                              ? NetworkImage(u.pfp)
                              : null,
                          child:
                              u.pfp.isEmpty ? const Icon(Icons.person) : null,
                        ),
                        title: Text(u.nombreCompleto),
                        subtitle: Text(u.carrera),
                      );
                    },
                  ),
            loading: () => const Padding(
              padding: EdgeInsets.all(12),
              child: LinearProgressIndicator(),
            ),
            error: (_, __) => const SizedBox(),
          ),

        if (query.isEmpty)
          const Expanded(
            child: Center(child: Text('Feed próximamente')),
          ),
      ],
    );
  }
}