import 'package:dreamscope/features/horoscope/domain/entities/saved_horoscope.dart';

abstract class SavedHoroscopeRepository {
  Future<List<SavedHoroscope>> getAllSavedHoroscopes();
  Future<List<SavedHoroscope>> getHoroscopesByFolder(String folderId);
  Future<SavedHoroscope?> getSavedHoroscope(String id);
  Future<void> saveHoroscope(SavedHoroscope horoscope);
  Future<void> deleteHoroscope(String id);
  Future<void> updateHoroscopeFolder(
      String id, String? folderId, String? folderName);
}
