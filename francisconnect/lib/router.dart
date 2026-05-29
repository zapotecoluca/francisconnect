import 'package:flutter/material.dart';
import 'package:francisconnect/features/auth/screens/create_profile_screen.dart';
import 'package:francisconnect/features/foros/screens/create_forum_screen.dart';
import 'package:francisconnect/features/foros/screens/explore_forums_screen.dart';
import 'package:francisconnect/features/foros/screens/forum_screen.dart';
import 'package:francisconnect/features/home/home_screen.dart';
import 'package:francisconnect/features/user_profile/screens/edit_profile_screen.dart';
import 'package:francisconnect/features/user_profile/screens/user_profile_screen.dart';
import 'package:routemaster/routemaster.dart';
import 'package:francisconnect/features/auth/screens/login_screen.dart';
import 'package:francisconnect/features/auth/screens/signup_screen.dart';

final loggedOutRoute = RouteMap(routes:
  {
    '/': (_) => const MaterialPage(child: LoginScreen()),
    '/signup': (_) => const MaterialPage(child: SignupScreen())

  }
);

final loggedInRoute = RouteMap(routes: 
  {
    '/': (_) => const MaterialPage(child: HomeScreen()),
    '/create-forum': (_) => const MaterialPage(child: CreateForumScreen()),
    '/explore-forums': (_) => const MaterialPage(child: ExploreForumsScreen()),
    '/create-profile': (_) => MaterialPage(child: CreateProfileScreen()),
    '/fc/:nombre': (route) => MaterialPage(child: ForumScreen(
      nombre: route.pathParameters['nombre']!)),
    '/profile': (_) => const MaterialPage(child: UserProfileScreen()),
    '/edit-profile': (_) => const MaterialPage(child: EditProfileScreen())
  }
);