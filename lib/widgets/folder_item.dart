
import 'package:flutter/material.dart';
import '../models/folder_model.dart';

class FolderItem extends StatelessWidget {
  final FolderModel folder;
  const FolderItem({super.key, required this.folder});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.folder, size: 50, color: Colors.blue),
          const SizedBox(height: 10),
          Text(folder.name, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
