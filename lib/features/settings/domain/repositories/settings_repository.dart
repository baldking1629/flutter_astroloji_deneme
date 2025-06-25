import 'package:flutter/material.dart';
import 'package:dreamscope/presentation/app_blocs/theme/theme_cubit.dart';

abstract class SettingsRepository {
  Future<void> saveLocale(Locale locale);
  Future<Locale> getLocale();
  Future<void> saveTheme(AppThemeMode mode);
  Future<AppThemeMode> getTheme();
}
