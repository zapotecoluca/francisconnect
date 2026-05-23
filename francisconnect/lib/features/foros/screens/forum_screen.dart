import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:francisconnect/core/common/error_text.dart';
import 'package:francisconnect/core/common/loader.dart';
import 'package:francisconnect/core/constants/constants.dart';
import 'package:francisconnect/features/foros/controller/forum_controller.dart';

class ForumScreen extends ConsumerWidget {
  final String nombre;
  const ForumScreen({super.key, required this.nombre});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: ref.watch(getForumByNameProvider(nombre)).when(
        data: (forum) => NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                expandedHeight: 200,
                floating: true,
                snap: true,
                flexibleSpace: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.network(
                        forum.banner, 
                        fit: BoxFit.cover
                      )
                    )
                  ],
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('fc-${forum.nombre}', 
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w600
                            ),
                          ),
                          OutlinedButton(
                            onPressed: () {}, 
                            child: const Text('Unirse'),
                          )
                        ],
                      )
                    ]
                  )
                ),
              )
            ];
          }, 
          body: const Text('Mostrando posts')
        ), 
        error: (error, stackTrace) => ErrorText(error: error.toString()), 
        loading: () => const Loader()
      ),
    );
  }
}