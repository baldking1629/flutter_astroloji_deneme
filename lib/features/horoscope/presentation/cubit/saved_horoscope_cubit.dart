import 'package:bloc/bloc.dart';
import 'package:dreamscope/features/horoscope/domain/entities/saved_horoscope.dart';
import 'package:dreamscope/features/horoscope/domain/usecases/get_all_saved_horoscopes.dart';
import 'package:dreamscope/features/horoscope/domain/usecases/delete_saved_horoscope.dart';
import 'package:equatable/equatable.dart';

part 'saved_horoscope_state.dart';

class SavedHoroscopeCubit extends Cubit<SavedHoroscopeState> {
  final GetAllSavedHoroscopes getAllSavedHoroscopes;
  final DeleteSavedHoroscope deleteSavedHoroscope;

  SavedHoroscopeCubit({
    required this.getAllSavedHoroscopes,
    required this.deleteSavedHoroscope,
  }) : super(SavedHoroscopeInitial());

  Future<void> loadSavedHoroscopes() async {
    emit(SavedHoroscopeLoading());
    try {
      final horoscopes = await getAllSavedHoroscopes();
      emit(SavedHoroscopeLoaded(horoscopes));
    } catch (e) {
      emit(SavedHoroscopeError(e.toString()));
    }
  }

  Future<void> deleteHoroscope(String id) async {
    try {
      await deleteSavedHoroscope(id);
      await loadSavedHoroscopes();
    } catch (e) {
      emit(SavedHoroscopeError(e.toString()));
    }
  }
}
