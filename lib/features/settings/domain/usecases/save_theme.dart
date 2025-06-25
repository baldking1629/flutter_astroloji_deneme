import 'package:dreamscope/features/settings/data/datasources/theme_local_data_source.dart';
import 'package:dreamscope/presentation/app_blocs/theme/theme_cubit.dart';

class SaveTheme {
  final ThemeLocalDataSource localDataSource;
  SaveTheme(this.localDataSource);

  Future<void> call(AppThemeMode mode) async {
    await localDataSource.saveTheme(mode);
  }
}
