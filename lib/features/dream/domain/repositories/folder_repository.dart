import 'package:dreamscope/features/dream/domain/entities/folder.dart';

abstract class FolderRepository {
  Future<List<Folder>> getAllFolders();
  Future<Folder?> getFolder(String id);
  Future<void> saveFolder(Folder folder);
  Future<void> updateFolder(Folder folder);
  Future<void> deleteFolder(String id);
}
