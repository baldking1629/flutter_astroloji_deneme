import 'package:dreamscope/features/horoscope/domain/entities/horoscope.dart';
import 'package:dreamscope/features/horoscope/domain/usecases/get_horoscope.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'horoscope_state.dart';

class HoroscopeCubit extends Cubit<HoroscopeState> {
  final GetHoroscope getHoroscope;

  HoroscopeCubit({required this.getHoroscope}) : super(HoroscopeInitial());

  Future<void> fetchHoroscope({
    required String sign,
    required String period,
    required String languageCode,
    required DateTime date,
  }) async {
    emit(HoroscopeLoading());
    try {
      final params = GetHoroscopeParams(
        sign: sign,
        period: period,
        languageCode: languageCode,
        date: date,
      );
      final horoscope = await getHoroscope(params);
      emit(HoroscopeLoaded(horoscope));
    } catch (e) {
      emit(HoroscopeError(e.toString()));
    }
  }
}
