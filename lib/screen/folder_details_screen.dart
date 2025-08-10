
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../providers/folder_provider.dart';

class FolderDetailScreen extends StatelessWidget {
  final String folderId;
  const FolderDetailScreen({super.key, required this.folderId});

  Future<void> _pickImage(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      Provider.of<FolderProvider>(context, listen: false)
          .addImageToFolder(folderId, pickedFile.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    final folderData = Provider.of<FolderProvider>(context);
    final folder = folderData.getFolderById(folderId);

    return Scaffold(
      appBar: AppBar(title: Text(folder.name)),
      body: folder.images.isEmpty
          ? const Center(child: Text("No images yet"))
          : GridView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: folder.images.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10,
        ),
        itemBuilder: (ctx, i) => Stack(
          children: [
            Image.file(
              File(folder.images[i]),
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
            Positioned(
              top: 5,
              right: 5,
              child: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text("Delete Image"),
                      content: const Text("Are you sure you want to delete this image?"),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text("Cancel"),
                        ),
                        TextButton(
                          onPressed: () {
                            Provider.of<FolderProvider>(context, listen: false)
                                .deleteImageFromFolder(folderId, folder.images[i]);
                            Navigator.pop(ctx);
                          },
                          child: const Text("Delete"),
                        ),
                      ],
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.delete, color: Colors.white, size: 18),
                ),
              ),
            ),
          ],
        ),

      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _pickImage(context),
        child: const Icon(Icons.add_a_photo),
      ),
    );
  }
}
