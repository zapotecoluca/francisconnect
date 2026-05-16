import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:francisconnect/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:francisconnect/core/constants/constants.dart';

class CreateProfileScreen extends StatefulWidget{
  const CreateProfileScreen({super.key});

  @override
  CreateProfileScreenState createState() => CreateProfileScreen();
}

class CreateProfileScreenState extends State<CreateProfileScreen> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _apellidoController = TextEditingController();
  final TextEditingController _nombreUsuarioController = TextEditingController();
  final TextEditingController _facultadController= TextEditingController();
  final TextEditingController _carreraController = TextEditingController();
  
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final formKey = GlobalKey<FormState>();

  @override

   void dispose() {
    _nombreController.dispose();
    _apellidoController.dispose();
    _nombreUsuarioController.dispose();
    _facultadController.dispose;
    _carreraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(Constants.blackLogoPath,
        height: 70,),
        centerTitle: true,
      ),
      backgroundColor: Palette.lightGreyColor,
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 30),
            const Text('Crear Perfil', style: TextStyle(
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
                      controller: _nombreController,
                      decoration: const InputDecoration(
                        labelText: 'Nombre',
                        border: OutlineInputBorder()
                      ),                      
                    ),
                    const SizedBox(height: 10,),
                    TextFormField(
                      controller: _apellidoController,
                      decoration: const InputDecoration(
                        labelText: 'Apellido',
                        border: OutlineInputBorder()
                      ),                      
                    ),
                    const SizedBox(height: 10,),
                    TextFormField(
                      controller: _nombreUsuarioController,
                      decoration: const InputDecoration(
                        labelText: 'Nombre de usuario',
                        border: OutlineInputBorder()
                      ),                      
                    ),
                    const SizedBox(height: 10,),
                    TextFormField(
                      controller: _facultadController,
                      decoration: const InputDecoration(
                        labelText: 'Facultad',
                        border: OutlineInputBorder()
                      ),                      
                    ),
                    const SizedBox(height: 10,),
                    TextFormField(
                      controller: _apellidoController,
                      decoration: const InputDecoration(
                        labelText: 'Carrera',
                        border: OutlineInputBorder()
                      ),                      
                    ),
                  ],
                ),
              )
            ),
            SizedBox(height: 30,),
            ElevatedButton(onPressed: (){
              
            }, child: child)
          ],
        ),
      ),
    );
  }
  
}