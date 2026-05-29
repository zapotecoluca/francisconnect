import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:francisconnect/core/common/loader.dart';
import 'package:francisconnect/core/constants/constants.dart';
import 'package:francisconnect/features/auth/controller/auth_controller.dart';
import 'package:francisconnect/theme/palette.dart';
import 'package:image_picker/image_picker.dart';
import 'package:routemaster/routemaster.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileSreenState();

}

class _EditProfileSreenState extends ConsumerState<EditProfileScreen> {
  late TextEditingController _nombreController;
  late TextEditingController _apellidoController;
  File? _newPfpFile;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if(!_initialized) {
      final user = ref.read(userProvider);
      _nombreController = TextEditingController(text: user?.nombre ?? '');
      _apellidoController = TextEditingController(text: user?.apellido ?? '');
      _initialized = true;
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _apellidoController.dispose();
    super.dispose();
  }

   Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) setState(() => _newPfpFile = File(picked.path));
  }


  void _save() {
    if (_nombreController.text.trim().isEmpty ||
        _apellidoController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('El nombre no puede estar vacío')),
      );
      return;
    }
    ref.read(authControllerProvider.notifier).saveProfile(
          nombre: _nombreController.text,
          apellido: _apellidoController.text,
          facultad: ref.read(userProvider)?.facultad ?? '',
          carrera: ref.read(userProvider)?.carrera ?? '',
          pfpFile: _newPfpFile,
          context: context,
        );
     Routemaster.of(context).push('/profile');
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authControllerProvider);
    final user =ref.watch(userProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Routemaster.of(context).pop(),
          icon: const Icon(Icons.arrow_back_ios)
        ),
        title: Image.asset(Constants.blackLogoPath, height: 50),
        centerTitle: true,
        backgroundColor: Palette.whiteColor,
        elevation: 1,
      ),
      body: isLoading
        ? const Center(child: Loader())
        :SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Text('Editar perfil',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700
                ),
              ),
              const SizedBox(height: 24),
              GestureDetector(
                onTap: _pickImage,
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 54,
                      backgroundColor: Colors.grey.shade300,
                      backgroundImage: _newPfpFile != null
                        ?FileImage(_newPfpFile!)
                        :(user?.pfp.isNotEmpty ?? false)
                          ? NetworkImage(user!.pfp) as ImageProvider
                          : const AssetImage(Constants.defaultPfp),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Palette.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.camera_alt, 
                          color: Palette.whiteColor,
                          size: 18
                        ),
                      )
                    )
                  ],
                ),
              ),
              const SizedBox(height: 8),
              const Text('¿Quieres cambiar la foto?'),
              const SizedBox(height: 24),
              TextField(
                controller: _nombreController,
                decoration: InputDecoration(
                  labelText: 'Nombre',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8)
                  )
                ),
              ),
              const SizedBox(height: 14,),
              TextField(
                controller: _apellidoController,
                decoration: InputDecoration(
                  labelText: 'Apellido',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8)
                  )
                ),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                height: 46,
                child: ElevatedButton(
                  onPressed: _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Palette.tertiary,
                    foregroundColor: Palette.whiteColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)
                    )
                  ), 
                  child: const Text('Guardar',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700
                    ),
                  )
                ),
              )
            ],
          ),
        ),
    );
  }
}