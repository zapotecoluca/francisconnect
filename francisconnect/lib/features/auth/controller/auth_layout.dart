import 'package:flutter/material.dart';
import 'package:francisconnect/features/auth/repository/auth_repository.dart';
import 'package:francisconnect/features/auth/screens/app_load.dart';
import 'package:francisconnect/features/auth/screens/home_screen.dart';
import 'package:francisconnect/features/auth/screens/login_screen.dart';

class AuthLayout extends StatelessWidget{
  const AuthLayout({super.key, this.pageIfNotConnected});

  final Widget? pageIfNotConnected;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: authRepository, 
      builder: (context, authRepository, child) {
        
        return StreamBuilder(
          stream: authRepository.authStateChanges, 
          builder: (context, snapshot) {
            Widget widget;
            if(snapshot.connectionState == ConnectionState.waiting) {
              widget = const AppLoad();
            } else if (snapshot.hasData) {
              widget = const HomeScreen();
            } else {
              widget = pageIfNotConnected ?? const LoginSreen();
            }
            return widget;
          }
        );
      });
  }
  
}