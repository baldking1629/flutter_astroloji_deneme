import 'package:flutter/material.dart';

abstract class SettingsRepository {
  Future<void> saveLocale(Locale locale);
  Future<Locale> getLocale();
}
