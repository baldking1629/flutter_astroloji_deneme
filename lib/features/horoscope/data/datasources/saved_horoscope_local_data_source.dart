import 'package:dreamscope/features/horoscope/data/models/saved_horoscope_model.dart';
import 'package:sembast/sembast.dart';

abstract class SavedHoroscopeLocalDataSource {
  Future<List<SavedHoroscopeModel>> getAllSavedHoroscopes();
  Future<List<SavedHoroscopeModel>> getHoroscopesByFolder(String folderId);
  Future<SavedHoroscopeModel?> getSavedHoroscope(String id);
  Future<void> saveHoroscope(SavedHoroscopeModel horoscope);
  Future<void> deleteHoroscope(String id);
  Future<void> updateHoroscopeFolder(
      String id, String? folderId, String? folderName);
}

class SembastSavedHoroscopeLocalDataSource
    implements SavedHoroscopeLocalDataSource {
  final Database _database;
  final StoreRef<String, Map<String, dynamic>> _store;

  SembastSavedHoroscopeLocalDataSource(this._database)
      : _store = stringMapStoreFactory.store('saved_horoscopes');

  @override
  Future<List<SavedHoroscopeModel>> getAllSavedHoroscopes() async {
    final snapshots = await _store.find(_database);
    return snapshots
        .map((snapshot) => SavedHoroscopeModel.fromJson(snapshot.value))
        .toList();
  }

  @override
  Future<List<SavedHoroscopeModel>> getHoroscopesByFolder(
      String folderId) async {
    final allHoroscopes = await getAllSavedHoroscopes();
    return allHoroscopes.where((h) => h.folderId == folderId).toList();
  }

  @override
  Future<SavedHoroscopeModel?> getSavedHoroscope(String id) async {
    final snapshot = await _store.record(id).get(_database);
    if (snapshot != null) {
      return SavedHoroscopeModel.fromJson(snapshot);
    }
    return null;
  }

  @override
  Future<void> saveHoroscope(SavedHoroscopeModel horoscope) async {
    await _store.record(horoscope.id).put(_database, horoscope.toJson());
  }

  @override
  Future<void> deleteHoroscope(String id) async {
    await _store.record(id).delete(_database);
  }

  @override
  Future<void> updateHoroscopeFolder(
      String id, String? folderId, String? folderName) async {
    final horoscope = await getSavedHoroscope(id);
    if (horoscope != null) {
      final updatedHoroscope = horoscope.copyWith(
        folderId: folderId,
        folderName: folderName,
      );
      await saveHoroscope(updatedHoroscope);
    }
  }
}
