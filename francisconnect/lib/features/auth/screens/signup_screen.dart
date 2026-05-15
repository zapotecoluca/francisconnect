import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:francisconnect/core/common/buttons.dart';
import 'package:francisconnect/core/constants/constants.dart';
import 'package:francisconnect/features/auth/repository/auth_repository.dart';
import 'package:francisconnect/features/auth/screens/home_screen.dart';
import 'package:francisconnect/theme/palette.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  SignupScreenState createState() => SignupScreenState();
  
}

class SignupScreenState extends State<SignupScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final formKey = GlobalKey<FormState>();
  String errorMessage = '';
 
  @override
   void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  
  void signUp() async {
    try {
      await authRepository.value.createAccount(email: emailController.text, 
      password: passwordController.text);
      popPage(context);
      goToHome(context);
    } on FirebaseAuthException catch (e) {
      
      setState(() {
        errorMessage = e.message ??'Registro fallido';
      });
    } 
  }

  void popPage(BuildContext context) {
    Navigator.pop(context);
  }

  void goToHome(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(Constants.blackLogoPath,
        height: 70,),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 30),
            const Text('Regístrate', style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,            
              ), 
            ),
            SizedBox(height: 50),
            Form(
              key: formKey,
              child: Center(
                child: Column(
                  children: [
                    TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        labelText: 'xxxxx@ufg.edu.sv',
                        border: OutlineInputBorder()
                      ),
                      validator: (String? value) {
                        if (value == null ) {
                          return 'No olvides tu correo';
                        } if ( value.trim().isEmpty) {
                          return 'No olvides tu correo';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10,),
                    TextFormField(
                      controller: passwordController,
                      decoration: const InputDecoration(
                        labelText: 'Contraseña',
                        border: OutlineInputBorder()
                      ),
                      obscureText: true,
                      validator: (String? value) {
                        if (value == null ) {
                          return 'No olvides colocar la contraseña';
                        } if ( value.trim().isEmpty) {
                          return 'No olvides colocar la contraseña';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              )
            ),
            SizedBox(height: 30,),
            SizedBox(
              width: 900,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    signUp();
                  }
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Palette.redColor,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                    ),
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white
                      ),
                    ),
                    child: const Text('Registrarse', style: TextStyle(color: Palette.whiteColor),),
                  )
            ),  
            SizedBox(height: 20),
            const goToLoginBtn()
          ],
        ),
      ),
    );
  }

  
}