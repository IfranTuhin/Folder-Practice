
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import '../models/folder_model.dart';

class FolderProvider with ChangeNotifier {
  List<FolderModel> _folders = [];
  final String _boxName = 'foldersBox';

  List<FolderModel> get folders => _folders;

  Future<void> loadFolders() async {
    final box = await Hive.openBox<FolderModel>(_boxName);
    _folders = box.values.toList();
    notifyListeners();
  }

  FolderModel getFolderById(String id) {
    return _folders.firstWhere((folder) => folder.id == id);
  }

  Future<void> addFolder(String name) async {
    final box = await Hive.openBox<FolderModel>(_boxName);
    final newFolder = FolderModel(
      id: DateTime.now().toString(),
      name: name,
      images: [],
    );
    await box.put(newFolder.id, newFolder);
    _folders = box.values.toList();
    notifyListeners();
  }

  Future<void> addImageToFolder(String folderId, String imagePath) async {
    final box = await Hive.openBox<FolderModel>(_boxName);
    final folder = getFolderById(folderId);
    folder.images.add(imagePath);
    await box.put(folder.id, folder);
    _folders = box.values.toList();
    notifyListeners();
  }

  Future<void> deleteFolder(String folderId) async {
    final box = await Hive.openBox<FolderModel>(_boxName);
    await box.delete(folderId);
    _folders = box.values.toList();
    notifyListeners();
  }

  Future<void> deleteImageFromFolder(String folderId, String imagePath) async {
    final box = await Hive.openBox<FolderModel>(_boxName);
    final folder = getFolderById(folderId);
    folder.images.remove(imagePath);
    await box.put(folder.id, folder);
    _folders = box.values.toList();
    notifyListeners();
  }

  Future<void> renameFolder(String folderId, String newName) async {
    final box = await Hive.openBox<FolderModel>(_boxName);
    final folder = getFolderById(folderId);
    folder.name = newName;
    await box.put(folder.id, folder);
    _folders = box.values.toList();
    notifyListeners();
  }

}
