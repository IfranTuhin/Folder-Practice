class FolderModel {
  final String id;
  final String name;
  final List<String> images; // Image URLs or local paths

  FolderModel({
    required this.id,
    required this.name,
    required this.images,
  });
}