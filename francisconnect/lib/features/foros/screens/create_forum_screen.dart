import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:francisconnect/core/common/loader.dart';
import 'package:francisconnect/core/constants/constants.dart';
import 'package:francisconnect/features/foros/controller/forum_controller.dart';
import 'package:francisconnect/theme/palette.dart';



class CreateForumScreen extends ConsumerStatefulWidget{
  const CreateForumScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CreateForumScreenState();

} 

class _CreateForumScreenState extends ConsumerState<CreateForumScreen> {
  final forumNameController= TextEditingController();
  final forumDescriptionController= TextEditingController();

  @override
  void dispose() {
    super.dispose();
    forumNameController.dispose();
    forumDescriptionController.dispose();
  }

  void createForum() async {
    ref.read(forumControllerProvider.notifier).createForum(
      forumNameController.text.trim(),
      forumDescriptionController.text,
      context);
  }
  
  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(forumControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Image.asset(Constants.blackLogoPath,
        height: 50,),
        centerTitle: true,
      ),
      body: isLoading? const Loader()
      : Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Align(
                alignment: Alignment.centerLeft,
                child: const Text('Crea un nuevo foro',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 20
                  ),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: forumNameController,
              decoration: const InputDecoration(
                hintText: 'Nombre',
                filled: true,
                border: InputBorder.none,
              ),
              maxLength: 25,
            ),
            const SizedBox(height: 5),
            TextField(
              controller: forumDescriptionController,
              decoration: const InputDecoration(
                hintText: 'Descripción',
                filled: true,
                border: InputBorder.none,
              ),
              maxLength: 100,
            ),
            const SizedBox(height: 10,),
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