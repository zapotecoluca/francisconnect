import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:francisconnect/core/constants/constants.dart';
import 'package:francisconnect/features/auth/controller/auth_controller.dart';
import 'package:francisconnect/features/home/chat_screen.dart';
import 'package:francisconnect/features/home/feed.dart';
import 'package:francisconnect/features/foros/screens/forum_menu.dart';
import 'package:francisconnect/theme/palette.dart';
import 'package:routemaster/routemaster.dart';

final _navIndexProvider = StateProvider<int>((ref) => 0);

class HomeScreen extends ConsumerWidget{
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(_navIndexProvider);
    final user = ref.watch(userProvider);

    const screens = [
      FeedScreen(),
      ChatScreen(),
      ForumMenu(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Image.asset(Constants.blackLogoPath,
        height: 50,),
        centerTitle: false,
        
        actions: [
          GestureDetector(
            onTap: () => Routemaster.of(context).push('/profile'),
            child: Padding(
              padding: const EdgeInsets.only(right: 12),
              child: CircleAvatar(
                radius: 18,
                backgroundColor: Palette.primary,
                backgroundImage: (user?.pfp.isNotEmpty ?? false)
                    ? NetworkImage(user!.pfp)
                    : null,
                child: (user?.pfp.isEmpty ?? true)
                    ? const Icon(Icons.person, 
                        color: Palette.whiteColor, 
                        size:  18)
                    : null,
              ),),
          )
        ],
        backgroundColor: Palette.whiteColor,
        elevation: 1,
      ),
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) => ref.read(_navIndexProvider.notifier).state = index,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: [
          BottomNavigationBarItem(
            icon: _NavIcon(
              asset: 'assets/images/home_icon.png',
              active: currentIndex == 0,
              ),
            label: 'Inicio'
            ),
          BottomNavigationBarItem(
            icon: _NavIcon(
              asset: 'assets/images/chat_icon.png', 
              active: currentIndex == 1,
            ),
            label: 'Chat'
          ),
          BottomNavigationBarItem(
            icon: _NavIcon(
              asset: 'assets/images/forum_icon.png', 
              active: currentIndex == 2,
            ),
            label: 'Foros'
          ),
        ],
      ),
    );
  } 
}

class _NavIcon extends StatelessWidget {
  final String asset;
  final bool active;
  const _NavIcon({required this.asset, required this.active});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 28,
      height: 28,
      child: Image.asset(
        asset,
        width: 28,
        height: 28,
        fit: BoxFit.contain
      ),
    );
  }
}