import 'package:sembast/sembast.dart';
import 'package:dreamscope/presentation/app_blocs/theme/theme_cubit.dart';

abstract class ThemeLocalDataSource {
  Future<void> saveTheme(AppThemeMode mode);
  Future<AppThemeMode> getTheme();
}

class SembastThemeLocalDataSource implements ThemeLocalDataSource {
  final Database db;
  static const String _key = 'theme_mode';
  SembastThemeLocalDataSource(this.db);

  @override
  Future<void> saveTheme(AppThemeMode mode) async {
    final store = StoreRef.main();
    await store.record(_key).put(db, mode.index);
  }

  @override
  Future<AppThemeMode> getTheme() async {
    final store = StoreRef.main();
    final index = await store.record(_key).get(db) as int?;
    if (index == null) {
      return AppThemeMode.system;
    }
    return AppThemeMode.values[index];
  }
}
