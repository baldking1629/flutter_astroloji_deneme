import 'package:dreamscope/features/dream/domain/entities/folder.dart';
import 'package:dreamscope/features/dream/domain/repositories/folder_repository.dart';

class GetAllFolders {
  final FolderRepository repository;
  GetAllFolders(this.repository);

  Future<List<Folder>> call() async {
    return repository.getAllFolders();
  }
}
