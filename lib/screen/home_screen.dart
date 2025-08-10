
import 'package:flutter/material.dart';
import 'package:flutter_practice/providers/folder_provider.dart';
import 'package:flutter_practice/widgets/folder_item.dart';
import 'package:provider/provider.dart';

import 'folder_details_screen.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final folderProvider = Provider.of<FolderProvider>(context);
    final folders = folderProvider.folders;

    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
      ),
      body: SafeArea(
        child: GridView.builder(
          padding: const EdgeInsets.all(10),
          itemCount: folders.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 2 per row
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemBuilder: (context, index) => GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => FolderDetailScreen(folderId: folders[index].id),
                ),
              );
            },
            child: FolderItem(
              folder: folders[index],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          folderProvider.addFolder('New Folder');
        },
        child: const Icon(Icons.create_new_folder),
      ),

    );
  }
}
