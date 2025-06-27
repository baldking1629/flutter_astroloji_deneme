import 'package:dreamscope/features/dream/data/datasources/folder_local_data_source.dart';
import 'package:dreamscope/features/dream/data/models/folder_model.dart';
import 'package:dreamscope/features/dream/domain/entities/folder.dart';
import 'package:dreamscope/features/dream/domain/repositories/folder_repository.dart';

class FolderRepositoryImpl implements FolderRepository {
  final FolderLocalDataSource localDataSource;

  FolderRepositoryImpl({required this.localDataSource});

  @override
  Future<List<Folder>> getAllFolders() async {
    final models = await localDataSource.getAllFolders();
    return models.map((e) => e.toEntity()).toList();
  }

  @override
  Future<Folder?> getFolder(String id) async {
    final model = await localDataSource.getFolder(id);
    return model?.toEntity();
  }

  @override
  Future<void> saveFolder(Folder folder) async {
    final model = FolderModel.fromEntity(folder);
    await localDataSource.saveFolder(model);
  }

  @override
  Future<void> updateFolder(Folder folder) async {
    final model = FolderModel.fromEntity(folder);
    await localDataSource.saveFolder(model);
  }

  @override
  Future<void> deleteFolder(String id) async {
    await localDataSource.deleteFolder(id);
  }
}
