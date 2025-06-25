import 'package:dreamscope/features/settings/domain/repositories/settings_repository.dart';
import 'package:flutter/material.dart';

class GetLocale {
  final SettingsRepository repository;
  GetLocale(this.repository);

  Future<Locale> call() async {
    return await repository.getLocale();
  }
}
