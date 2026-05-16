
import 'package:flutter/material.dart';
import 'package:francisconnect/features/auth/screens/signup_screen.dart';
import 'package:francisconnect/features/home/home_screen.dart';
import 'package:francisconnect/theme/palette.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/auth/controller/auth_controller.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/auth/screens/create_profile_screen.dart';
import 'package:francisconnect/models/user_model.dart';



void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
    );

  runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override 
  Widget build (BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FrancisCONNECT',
      theme: Palette.lightModeAppTheme,
      home: const SignupScreen(),
    );
  }
}
  
  


