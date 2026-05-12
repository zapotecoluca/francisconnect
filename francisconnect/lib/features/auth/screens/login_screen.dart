
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:francisconnect/core/common/buttons.dart';
import 'package:francisconnect/core/constants/constants.dart';
import 'package:francisconnect/features/auth/screens/forgot_password_screen.dart';
import 'package:francisconnect/features/auth/screens/home_screen.dart';
import 'package:francisconnect/theme/palette.dart';

class LoginSreen extends StatefulWidget {
  const LoginSreen({super.key});

  @override
  LoginSreenState createState() => LoginSreenState();
  
}

class LoginSreenState extends State<LoginSreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isloading = false;

  void _login() async {
    setState(() {
      _isloading = true;
    });

    try {
      await _auth.signInWithEmailAndPassword(email: emailController.text.trim(), 
      password: passwordController.text.trim()
      );
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Ingreso exitoso')));
      goToHome(context);
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context,
      ).showSnackBar(SnackBar(content: Text(e.message ??'Ingreso fallido')));
    } finally {
      setState(() {
        _isloading = false;
      });
    }
  }

  goToHome(BuildContext context) {
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
            const Text('Inicia sesión', style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,            
              ), 
            ),
            SizedBox(height: 40,),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Correo electrónico',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height:10),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Contraseña',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: (){
                  Navigator.push(
                    context,
                     MaterialPageRoute(builder: (context) => ForgotPasswordScreen()));
                  }, 
                child: Text('¿Olvidaste la contraseña?', style: TextStyle(
                  fontSize: 13,
                  color: Palette.darkGreyColor
                ),)),
            ),
            SizedBox(height: 20),
            _isloading
              ? CircularProgressIndicator()
              : SizedBox(width: 900,
                height: 50,
                child: ElevatedButton(
                onPressed: _login,
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
                  child: const Text('Iniciar sesión', style: TextStyle(color: Palette.whiteColor),),
                )
              ),
              SizedBox(height: 20),
              const goToSignInBtn(),
              SizedBox(height: 35),              
            ],
        ),
      ),
    );
  }

  
}