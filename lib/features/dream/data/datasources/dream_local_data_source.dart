import 'package:dreamscope/features/dream/data/models/dream_model.dart';
import 'package:sembast/sembast.dart';

abstract class DreamLocalDataSource {
  Future<List<DreamModel>> getAllDreams();
  Future<DreamModel?> getDream(String id);
  Future<void> saveDream(DreamModel dream);
  Future<void> deleteDream(String id);
}

class SembastDreamLocalDataSource implements DreamLocalDataSource {
  final Database _database;
  final StoreRef<String, Map<String, dynamic>> _store;

  SembastDreamLocalDataSource(this._database)
      : _store = stringMapStoreFactory.store('dreams');

  @override
  Future<void> deleteDream(String id) async {
    await _store.record(id).delete(_database);
  }

  @override
  Future<List<DreamModel>> getAllDreams() async {
    final snapshots = await _store.find(_database);
    return snapshots
        .map((snapshot) => DreamModel.fromJson(snapshot.value))
        .toList();
  }

  @override
  Future<DreamModel?> getDream(String id) async {
    final snapshot = await _store.record(id).get(_database);
    if (snapshot != null) {
      return DreamModel.fromJson(snapshot);
    }
    return null;
  }

  @override
  Future<void> saveDream(DreamModel dream) async {
    await _store.record(dream.id).put(_database, dream.toJson());
  }
}
