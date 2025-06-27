import 'package:dreamscope/features/horoscope/data/datasources/saved_horoscope_local_data_source.dart';
import 'package:dreamscope/features/horoscope/data/models/saved_horoscope_model.dart';
import 'package:dreamscope/features/horoscope/domain/entities/saved_horoscope.dart';
import 'package:dreamscope/features/horoscope/domain/repositories/saved_horoscope_repository.dart';

class SavedHoroscopeRepositoryImpl implements SavedHoroscopeRepository {
  final SavedHoroscopeLocalDataSource localDataSource;

  SavedHoroscopeRepositoryImpl({required this.localDataSource});

  @override
  Future<List<SavedHoroscope>> getAllSavedHoroscopes() async {
    final models = await localDataSource.getAllSavedHoroscopes();
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<List<SavedHoroscope>> getHoroscopesByFolder(String folderId) async {
    final models = await localDataSource.getHoroscopesByFolder(folderId);
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<SavedHoroscope?> getSavedHoroscope(String id) async {
    final model = await localDataSource.getSavedHoroscope(id);
    return model?.toEntity();
  }

  @override
  Future<void> saveHoroscope(SavedHoroscope horoscope) async {
    final model = SavedHoroscopeModel.fromEntity(horoscope);
    await localDataSource.saveHoroscope(model);
  }

  @override
  Future<void> deleteHoroscope(String id) async {
    await localDataSource.deleteHoroscope(id);
  }

  @override
  Future<void> updateHoroscopeFolder(
      String id, String? folderId, String? folderName) async {
    await localDataSource.updateHoroscopeFolder(id, folderId, folderName);
  }
}
