import 'package:dreamscope/features/dream/domain/entities/folder.dart';
import 'package:dreamscope/features/dream/domain/repositories/folder_repository.dart';

class SaveFolder {
  final FolderRepository repository;
  SaveFolder(this.repository);

  Future<void> call(Folder folder) async {
    return repository.saveFolder(folder);
  }
}
