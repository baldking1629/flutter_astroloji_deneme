import 'package:dreamscope/features/horoscope/domain/entities/horoscope.dart';

abstract class HoroscopeRepository {
  Future<Horoscope> getHoroscope({
    required String sign,
    String? ascendant,
    required String period,
    required String languageCode,
    required DateTime date,
  });
}
