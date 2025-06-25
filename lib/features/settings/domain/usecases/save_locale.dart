import 'package:dreamscope/features/settings/domain/repositories/settings_repository.dart';
import 'package:flutter/material.dart';

class SaveLocale {
  final SettingsRepository repository;
  SaveLocale(this.repository);

  Future<void> call(Locale locale) async {
    await repository.saveLocale(locale);
  }
}
