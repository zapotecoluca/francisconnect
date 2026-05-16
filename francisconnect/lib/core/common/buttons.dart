import 'package:flutter/material.dart';
import 'package:francisconnect/features/auth/screens/login_screen.dart';
import 'package:francisconnect/theme/palette.dart';
import 'package:francisconnect/features/auth/screens/signup_screen.dart';

//para ir a inicio de sesion
class goToLoginBtn extends StatelessWidget {
  const goToLoginBtn({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: () {
        Navigator.push(context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
        
      },
      label: const Text('¿Ya tienes una cuenta?', style: TextStyle(color: Palette.darkGreyColor),),
      icon: Text('Inicia sesión aquí', style: TextStyle(
        color: Palette.tertiary,
      ),),
      iconAlignment: IconAlignment.end,
      style: TextButton.styleFrom(
        backgroundColor: Colors.transparent,
        elevation: 0
      )
    );
  }
}

//registrarse
/*
class SignUpBtn extends StatelessWidget{
  const SignUpBtn({super.key});
  
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 900,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          SignupScreenState().signUp();
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
        );
  }

  
}

*/
//para ir a registrarse

class goToSignUpBtn extends StatelessWidget {
  const goToSignUpBtn({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: () {
        Navigator.push(context,
          MaterialPageRoute(builder: (context) => SignupScreen()),
        );
      },
      label: const Text('¿No tienes una cuenta?', style: TextStyle(color: Palette.darkGreyColor)),
      icon: Text('Crea una aquí', style: TextStyle(
        color: Palette.tertiary,
      ),),
      iconAlignment: IconAlignment.end,
      style: TextButton.styleFrom(
        backgroundColor: Colors.transparent,
        elevation: 0
      )
    );
  }
}