import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:francisconnect/theme/palette.dart';
import 'package:image_picker/image_picker.dart';
import '../controller/auth_controller.dart';

const Map<String, List<String>> carrerasDeFacultad = {
  'Facultad de Ciencias Sociales y Jurídicas': [
    'Ciencias Jurídicas',
    'Ciencias Políticas',
    'Criminología',
    'Psicología',
  ],
  'Facultad de Arte y diseño': [
    'Diseño Gráfico Publicitario',
    'Diseño de Modas',
    'Arquitectura',
    'Animación Digital y Videojuegos',
  ],
  'Facultad de Ingeniería y Sistemas': [
    'Sistemas y Ciberseguridad',
    'Ingeniería Industrial',
    'Ciencias de la computación',
    'Diseño y desarrollo de software'
  ],
  'Facultad de Ciencias Económicas': [
    'Administración de empresas',
    'Comercio y negocios internacionales',
    'Comunicación corporativa',
    'Contaduría pública'
  ]
};

class CreateProfileScreen extends ConsumerStatefulWidget {
  const CreateProfileScreen({super.key});

  @override
  ConsumerState<CreateProfileScreen> createState() =>
      _CreateProfileScreenState();
}

class _CreateProfileScreenState extends ConsumerState<CreateProfileScreen> {
  final _nombreController = TextEditingController();
  final _apellidoController = TextEditingController();
  String? _facultadSeleccionada;
  String? _carreraSeleccionada;
  File? _pfpFile;

  @override
  void dispose() {
    _nombreController.dispose();
    _apellidoController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _pfpFile = File(picked.path));
    }
  }


  void _submit() {
    if (_nombreController.text.trim().isEmpty ||
        _apellidoController.text.trim().isEmpty ||
        _facultadSeleccionada == null ||
        _carreraSeleccionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor completa todos los campos')),
      );
      return;
    }

    ref.read(authControllerProvider.notifier).saveProfile(
          nombre: _nombreController.text,
          apellido: _apellidoController.text,
          facultad: _facultadSeleccionada!,
          carrera: _carreraSeleccionada!,
          pfpFile: _pfpFile,
          context: context,
        );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Personalizar Perfil')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  
                  GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Palette.lightGreyColor,
                      backgroundImage: _pfpFile != null
                          ? FileImage(_pfpFile!)
                          : null,
                      child: _pfpFile == null
                          ? const Icon(Icons.camera_alt, size: 36)
                          : null,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text('Foto de perfil (opcional)'),
                  const SizedBox(height: 24),

                  TextField(
                    controller: _nombreController,
                    decoration:
                        const InputDecoration(labelText: 'Nombre'),
                  ),
                  const SizedBox(height: 12),

                  TextField(
                    controller: _apellidoController,
                    decoration:
                        const InputDecoration(labelText: 'Apellido'),
                  ),
                  const SizedBox(height: 12),
                  
                  DropdownButtonFormField<String>(
                    decoration:
                        const InputDecoration(labelText: 'Facultad'),
                    initialValue: _facultadSeleccionada,
                    items: carrerasDeFacultad.keys
                        .map((f) =>
                            DropdownMenuItem(value: f, child: Text(f)))
                        .toList(),
                    onChanged: (val) {
                      setState(() {
                        _facultadSeleccionada = val;
                        _carreraSeleccionada = null; 
                      });
                    },
                  ),
                  const SizedBox(height: 12),

                  DropdownButtonFormField<String>(
                    decoration:
                        const InputDecoration(labelText: 'Carrera'),
                    initialValue: _carreraSeleccionada,
                    items: _facultadSeleccionada == null
                        ? []
                        : (carrerasDeFacultad[_facultadSeleccionada!] ?? [])
                            .map((u) =>
                                DropdownMenuItem(value: u, child: Text(u)))
                            .toList(),
                    onChanged: _facultadSeleccionada == null
                        ? null
                        : (val) =>
                            setState(() => _carreraSeleccionada = val),
                  ),
                  const SizedBox(height: 32),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _submit,
                      child: const Text('Guardar'),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

