
import 'package:flutter/cupertino.dart';
import 'package:flutter_practice/models/folder_model.dart';

class FolderProvider with ChangeNotifier {

  final List<FolderModel> _folders = [
    FolderModel(
      id: '1',
      name: 'Sports',
      images: [
        'https://picsum.photos/200/300',
        'https://picsum.photos/200/301',
        'https://picsum.photos/200/301',
      ],
    ),
    FolderModel(
      id: '2',
      name: 'Music',
      images: [
        'https://picsum.photos/200/300',
      ],
    ),
    FolderModel(
      id: '3',
      name: 'Travel',
      images: [],
    ),
  ];

  List<FolderModel> get folders => _folders;

  FolderModel getFolderById(String id) {
    return _folders.firstWhere((folder) => folder.id == id);
  }

  void addFolder(String name) {
    _folders.add(FolderModel(
      id: DateTime.now().toString(),
      name: name, 
      images: [],
    ));
    notifyListeners();
  }

  void addImageToFolder(String folderId, String imageUrl) {
    final folder = getFolderById(folderId);
    folder.images.add(imageUrl);
    notifyListeners();
  }

}