import 'package:dreamscope/features/horoscope/domain/entities/horoscope.dart';
import 'package:dreamscope/features/horoscope/domain/repositories/horoscope_repository.dart';
import 'package:equatable/equatable.dart';

class GetHoroscope {
  final HoroscopeRepository repository;
  GetHoroscope(this.repository);

  Future<Horoscope> call(GetHoroscopeParams params) async {
    return repository.getHoroscope(
      sign: params.sign,
      ascendant: params.ascendant,
      period: params.period,
      languageCode: params.languageCode,
      date: params.date,
    );
  }
}

class GetHoroscopeParams extends Equatable {
  final String sign;
  final String? ascendant;
  final String period;
  final String languageCode;
  final DateTime date;

  const GetHoroscopeParams({
    required this.sign,
    this.ascendant,
    required this.period,
    required this.languageCode,
    required this.date,
  });

  @override
  List<Object?> get props => [sign, ascendant, period, languageCode, date];
}
