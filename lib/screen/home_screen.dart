
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/folder_lock_provider.dart';
import '../providers/folder_provider.dart';
import '../widgets/folder_item.dart';
import 'folder_details_screen.dart';
import 'lock_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    final folderProv = Provider.of<FolderProvider>(context, listen: false);
    final lockProv = Provider.of<FolderLockProvider>(context, listen: false);

    folderProv.loadFolders().then((_) {
      lockProv.loadLocks(folderProv.folders.map((f) => f.id).toList());
    });
  }

  void _showAddFolderDialog() {
    final nameController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("New Folder"),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(hintText: "Folder Name"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              if (nameController.text.trim().isNotEmpty) {
                Provider.of<FolderProvider>(context, listen: false)
                    .addFolder(nameController.text.trim());
              }
              Navigator.pop(ctx);
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final folderData = Provider.of<FolderProvider>(context);
    final folders = folderData.folders;
    final lockProv = Provider.of<FolderLockProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text("My Folders")),
      body: GridView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: folders.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10,
        ),
        itemBuilder: (ctx, i) => GestureDetector(
          onTap: () async {

            final folderId = folders[i].id;
            if (lockProv.isLocked(folderId)) {
              final ok = await LockDialog.show(context, folderId, folderName: folders[i].name);
              if (!ok) return;
            }
            // proceed to open folder
            Navigator.push(context, MaterialPageRoute(builder: (context) => FolderDetailScreen(folderId: folderId),));
          },
            onLongPress: () {
              final lockProv = Provider.of<FolderLockProvider>(context, listen: false);

              showModalBottomSheet(
                context: context,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                ),
                backgroundColor: Colors.white,
                builder: (ctx) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 50,
                        height: 5,
                        margin: const EdgeInsets.only(bottom: 15),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),

                      // Rename
                      ListTile(
                        leading: Container(
                          decoration: BoxDecoration(
                            color: Colors.blue.shade100,
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(8),
                          child: const Icon(Icons.edit, color: Colors.blue),
                        ),
                        title: const Text(
                          "    Rename",
                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                        ),
                        onTap: () {
                          Navigator.pop(ctx);
                          _showRenameDialog(context, folders[i].id, folders[i].name);
                        },
                        horizontalTitleGap: 0,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                      ),

                      const Divider(height: 1),

                      // Lock / Unlock
                      ListTile(
                        leading: Container(
                          decoration: BoxDecoration(
                            color: Colors.orange.shade100,
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(8),
                          child: Icon(
                            lockProv.isLocked(folders[i].id)
                                ? Icons.lock_open
                                : Icons.lock,
                            color: Colors.orange,
                          ),
                        ),
                        title: Text(
                          lockProv.isLocked(folders[i].id)
                              ? "    Remove Lock"
                              : "    Set Lock",
                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                        ),
                        onTap: () async {
                          Navigator.pop(ctx);
                          if (lockProv.isLocked(folders[i].id)) {
                            await lockProv.removePassword(folders[i].id);
                          } else {
                            final controller = TextEditingController();
                            showDialog(
                              context: context,
                              builder: (dCtx) {
                                return AlertDialog(
                                  title: const Text('Set folder password'),
                                  content: TextField(
                                    controller: controller,
                                    obscureText: true,
                                    decoration: const InputDecoration(
                                      hintText: 'Enter password',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(dCtx),
                                      child: const Text("Cancel"),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        final pass = controller.text.trim();
                                        if (pass.isNotEmpty) {
                                          await lockProv.setPassword(
                                              folders[i].id, pass);
                                          Navigator.pop(dCtx);
                                        }
                                      },
                                      child: const Text("Save"),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                        horizontalTitleGap: 0,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                      ),

                      const Divider(height: 1),

                      // Delete
                      ListTile(
                        leading: Container(
                          decoration: BoxDecoration(
                            color: Colors.red.shade100,
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(8),
                          child: const Icon(Icons.delete, color: Colors.red),
                        ),
                        title: const Text(
                          "    Delete",
                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                        ),
                        onTap: () {
                          Navigator.pop(ctx);
                          showDialog(
                            context: context,
                            builder: (ctx2) => AlertDialog(
                              title: const Text("Delete Folder"),
                              content: Text(
                                  "Are you sure you want to delete '${folders[i].name}'?"),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx2),
                                  child: const Text("Cancel"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Provider.of<FolderProvider>(context, listen: false)
                                        .deleteFolder(folders[i].id);
                                    Navigator.pop(ctx2);
                                  },
                                  child: const Text(
                                    "Delete",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        horizontalTitleGap: 0,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                      ),

                      const SizedBox(height: 15),
                    ],
                  ),
                ),
              );
            },
          child: FolderItem(
            folder: folders[i],
            locked: lockProv.isLocked(folders[i].id),  // <-- pass lock state here
          ),
        ),

      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddFolderDialog,
        child: const Icon(Icons.create_new_folder),
      ),
    );
  }

  void _showRenameDialog(BuildContext context, String folderId, String currentName) {
    final nameController = TextEditingController(text: currentName);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.grey[100],
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Rename Folder",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[800],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 15),
              TextField(
                controller: nameController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: "Enter new folder name",
                  hintStyle: TextStyle(color: Colors.grey[500]),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue.shade300),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue.shade700, width: 2),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                ),
                maxLength: 30,
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.grey[700],
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    ),
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text(
                      "Cancel",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[700],
                      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      if (nameController.text.trim().isNotEmpty) {
                        Provider.of<FolderProvider>(context, listen: false)
                            .renameFolder(folderId, nameController.text.trim());
                        Navigator.pop(ctx);
                      }
                    },
                    child: const Text(
                      "Save",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

}

