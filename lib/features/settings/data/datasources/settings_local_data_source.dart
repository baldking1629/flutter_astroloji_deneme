import 'package:sembast/sembast.dart';

abstract class SettingsLocalDataSource {
  Future<void> saveLocale(String localeCode);
  Future<String> getLocale();
}

class SembastSettingsLocalDataSource implements SettingsLocalDataSource {
  final Database _database;
  final StoreRef<String, String> _store;
  static const String _localeKey = 'user_locale';

  SembastSettingsLocalDataSource(this._database)
      : _store = StoreRef<String, String>('settings');

  @override
  Future<String> getLocale() async {
    final locale = await _store.record(_localeKey).get(_database);
    return locale ?? 'en'; // Default to English
  }

  @override
  Future<void> saveLocale(String localeCode) async {
    await _store.record(_localeKey).put(_database, localeCode);
  }
}
