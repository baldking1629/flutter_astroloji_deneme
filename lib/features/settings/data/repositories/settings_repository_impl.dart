import 'package:dreamscope/features/settings/data/datasources/settings_local_data_source.dart';
import 'package:dreamscope/features/settings/domain/repositories/settings_repository.dart';
import 'package:flutter/material.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsLocalDataSource localDataSource;

  SettingsRepositoryImpl({required this.localDataSource});

  @override
  Future<Locale> getLocale() async {
    final localeString = await localDataSource.getLocale();
    return Locale(localeString);
  }

  @override
  Future<void> saveLocale(Locale locale) async {
    await localDataSource.saveLocale(locale.languageCode);
  }
}
