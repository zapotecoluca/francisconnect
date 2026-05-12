import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:francisconnect/core/constants/constants.dart';
import 'package:francisconnect/features/auth/screens/login_screen.dart';
import 'package:francisconnect/theme/palette.dart';

class ForgotPasswordScreen extends StatefulWidget{
  const ForgotPasswordScreen({super.key});
  
  @override
   ForgotPasswordScreenState createState() => ForgotPasswordScreenState();
  
}

class ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;
  bool _isloading = false;

  void resetPassword() async {
    setState(() {
      _isloading = true;
    });

    try {
      await auth.sendPasswordResetEmail(email: emailController.text.trim());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Te enviamos un correo para que reestablezcas la contraseña'))
      );
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Ocurrió un error al enviar el correo'))
      );
    } finally {
      setState(() {
        _isloading = false;
      });
    }
  }

  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(Constants.blackLogoPath,
        height: 60,),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(context,
               MaterialPageRoute(builder: (context) => LoginSreen()),
               );
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Ingresa tu correo',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            _isloading
                ? CircularProgressIndicator()
                : SizedBox(
                    width: 900,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: resetPassword,
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
                      child: const Text('Reestablecer contraseña', 
                        style: TextStyle(color: Palette.whiteColor),),
                )
              ),
          ],
        ),),
    );
  }
}