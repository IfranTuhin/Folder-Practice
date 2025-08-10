
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/folder_provider.dart';

class FolderDetailScreen extends StatelessWidget {
  final String folderId;
  const FolderDetailScreen({super.key, required this.folderId});

  @override
  Widget build(BuildContext context) {

    final folderProvider = Provider.of<FolderProvider>(context);
    final folder = folderProvider.getFolderById(folderId);

    return Scaffold(
      appBar: AppBar(
        title: Text(folder.name),
      ),
      body: folder.images.isEmpty ? Center(child: Text('No images yet')) : GridView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: folder.images.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // 2 per row
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (ctx, i) => Image.network(
          folder.images[i],
          fit: BoxFit.cover,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          folderProvider.addImageToFolder(folderId, 'https://picsum.photos/200/30${folder.images.length}');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
