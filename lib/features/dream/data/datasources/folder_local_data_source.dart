import 'package:dreamscope/features/dream/data/models/folder_model.dart';
import 'package:sembast/sembast.dart';

abstract class FolderLocalDataSource {
  Future<List<FolderModel>> getAllFolders();
  Future<FolderModel?> getFolder(String id);
  Future<void> saveFolder(FolderModel folder);
  Future<void> deleteFolder(String id);
}

class SembastFolderLocalDataSource implements FolderLocalDataSource {
  final Database _database;
  final StoreRef<String, Map<String, dynamic>> _store;

  SembastFolderLocalDataSource(this._database)
      : _store = stringMapStoreFactory.store('folders');

  @override
  Future<List<FolderModel>> getAllFolders() async {
    final snapshots = await _store.find(_database);
    return snapshots
        .map((snapshot) => FolderModel.fromJson(snapshot.value))
        .toList();
  }

  @override
  Future<FolderModel?> getFolder(String id) async {
    final snapshot = await _store.record(id).get(_database);
    if (snapshot != null) {
      return FolderModel.fromJson(snapshot);
    }
    return null;
  }

  @override
  Future<void> saveFolder(FolderModel folder) async {
    await _store.record(folder.id).put(_database, folder.toJson());
  }

  @override
  Future<void> deleteFolder(String id) async {
    await _store.record(id).delete(_database);
  }
}
