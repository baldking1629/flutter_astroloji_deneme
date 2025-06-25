import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dreamscope/injection_container.dart' as di;
import 'package:dreamscope/features/settings/domain/usecases/get_theme.dart';
import 'package:dreamscope/features/settings/domain/usecases/save_theme.dart';

part 'theme_state.dart';

enum AppThemeMode { system, light, dark }

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(const ThemeState(AppThemeMode.system)) {
    _initializeTheme();
  }

  void setTheme(AppThemeMode mode) {
    emit(ThemeState(mode));
    _saveTheme(mode);
  }

  Future<void> _initializeTheme() async {
    try {
      final theme = await di.sl<GetTheme>().call();
      if (state.mode != theme) {
        emit(ThemeState(theme));
      }
    } catch (e) {
      if (state.mode != AppThemeMode.system) {
        emit(const ThemeState(AppThemeMode.system));
      }
    }
  }

  Future<void> _saveTheme(AppThemeMode mode) async {
    try {
      await di.sl<SaveTheme>().call(mode);
    } catch (e) {
      // Handle error silently
    }
  }
}
