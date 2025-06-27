import 'package:dreamscope/features/dream/domain/repositories/folder_repository.dart';

class DeleteFolder {
  final FolderRepository repository;
  DeleteFolder(this.repository);
  Future<void> call(String id) => repository.deleteFolder(id);
}
