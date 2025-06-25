import 'package:dreamscope/features/settings/data/datasources/theme_local_data_source.dart';
import 'package:dreamscope/presentation/app_blocs/theme/theme_cubit.dart';

class GetTheme {
  final ThemeLocalDataSource localDataSource;
  GetTheme(this.localDataSource);

  Future<AppThemeMode> call() async {
    return await localDataSource.getTheme();
  }
}
