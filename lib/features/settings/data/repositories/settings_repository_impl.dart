import 'package:dreamscope/features/settings/data/datasources/settings_local_data_source.dart';
import 'package:dreamscope/features/settings/data/datasources/theme_local_data_source.dart';
import 'package:dreamscope/features/settings/domain/repositories/settings_repository.dart';
import 'package:flutter/material.dart';
import 'package:dreamscope/presentation/app_blocs/theme/theme_cubit.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsLocalDataSource localDataSource;
  final ThemeLocalDataSource themeLocalDataSource;

  SettingsRepositoryImpl(
      {required this.localDataSource, required this.themeLocalDataSource});

  @override
  Future<Locale> getLocale() async {
    final localeString = await localDataSource.getLocale();
    return Locale(localeString);
  }

  @override
  Future<void> saveLocale(Locale locale) async {
    await localDataSource.saveLocale(locale.languageCode);
  }

  Future<void> saveTheme(AppThemeMode mode) async {
    await themeLocalDataSource.saveTheme(mode);
  }

  Future<AppThemeMode> getTheme() async {
    return await themeLocalDataSource.getTheme();
  }
}
