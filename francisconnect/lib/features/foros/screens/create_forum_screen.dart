import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:francisconnect/core/common/loader.dart';
import 'package:francisconnect/core/constants/constants.dart';
import 'package:francisconnect/features/foros/controller/forum_controller.dart';
import 'package:francisconnect/theme/palette.dart';
import 'package:image_picker/image_picker.dart';
import 'package:routemaster/routemaster.dart';


class CreateForumScreen extends ConsumerStatefulWidget{
  const CreateForumScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CreateForumScreenState();

} 

class _CreateForumScreenState extends ConsumerState<CreateForumScreen> {
  final forumNameController= TextEditingController();
  final forumDescriptionController= TextEditingController();
  File? _bannerFile;

  @override
  void dispose() {
    forumNameController.dispose();
    forumDescriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickBanner() async{
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) setState(() => _bannerFile = File(picked.path));
  }

  void createForum() async {
    if (forumNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('El nombre no puede estar vacío'))
      );
    }
    ref.read(forumControllerProvider.notifier).createForum(
      forumNameController.text.trim(),
      forumDescriptionController.text,
      _bannerFile,
      context);
  }
  
  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(forumControllerProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Routemaster.of(context).pop(), 
          icon: const Icon(Icons.arrow_back_ios)
        ),
        title: Image.asset(Constants.blackLogoPath, height: 50),
        backgroundColor: Palette.whiteColor,
        centerTitle: true,
        elevation: 1,
      ),
      body: isLoading? const Loader()
      : Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Palette.tertiary,
                borderRadius:  const BorderRadius.only(
                  topRight: Radius.circular(30),
                  bottomRight: Radius.circular(30)
                )
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 12
              ),
              child: const Text('Crea tu propio espacio',
                style: TextStyle(
                  color: Palette.whiteColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w700
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8)
              ),
              child: TextField(
                controller: forumNameController,
                decoration: const InputDecoration(
                  hintText: 'Nombre',
                  filled: true,
                  border: InputBorder.none,
                ),
                maxLength: 25,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8)
              ),
              child: TextField(
                controller: forumDescriptionController,
                decoration: const InputDecoration(
                  hintText: 'Descripción',
                  hintStyle: TextStyle(color: Colors.grey),
                  filled: true,
                  border: InputBorder.none,
                ),
                maxLength: 100,
              ),
            ),
            const SizedBox(height: 10,),
            GestureDetector(
              onTap: _pickBanner,
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8)
                ),
                child: Row(
                  children: [
                    const Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 14
                        ),
                        child: Text('Banner',
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    ),
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(8),
                        bottomRight: Radius.circular(8),
                      ),
                      child: SizedBox(
                        width: 100,
                        height: 100,
                        child: _bannerFile != null
                          ? Image.file(_bannerFile!, fit: BoxFit.cover)
                          : Image.asset(Constants.defaultBanner, fit: BoxFit.cover
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: createForum, 
                style: ElevatedButton.styleFrom(
                  backgroundColor: Palette.tertiary,
                  foregroundColor: Palette.whiteColor,
                  shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)
                  )
                ),
                child: const Text('Crear foro',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    color: Palette.whiteColor
                  ),
                ),
            ),
            )
          ],
        ),
      ),
    );
  }
  
}