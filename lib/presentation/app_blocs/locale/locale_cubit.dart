import 'package:dreamscope/features/settings/domain/usecases/get_locale.dart';
import 'package:dreamscope/features/settings/domain/usecases/save_locale.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'locale_state.dart';

class LocaleCubit extends Cubit<LocaleState> {
  final GetLocale getLocale;
  final SaveLocale saveLocale;

  LocaleCubit({required this.getLocale, required this.saveLocale})
    : super(const LocaleState(locale: Locale('en')));

  Future<void> loadLocale() async {
    final locale = await getLocale();
    emit(LocaleState(locale: locale));
  }

  Future<void> changeLocale(Locale newLocale) async {
    await saveLocale(newLocale);
    emit(LocaleState(locale: newLocale));
  }
}
