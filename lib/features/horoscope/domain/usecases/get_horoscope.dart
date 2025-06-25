import 'package:dreamscope/features/horoscope/domain/entities/horoscope.dart';
import 'package:dreamscope/features/horoscope/domain/repositories/horoscope_repository.dart';
import 'package:equatable/equatable.dart';

class GetHoroscope {
  final HoroscopeRepository repository;
  GetHoroscope(this.repository);

  Future<Horoscope> call(GetHoroscopeParams params) async {
    return repository.getHoroscope(
      sign: params.sign,
      period: params.period,
      languageCode: params.languageCode,
    );
  }
}

class GetHoroscopeParams extends Equatable {
  final String sign;
  final String period;
  final String languageCode;

  const GetHoroscopeParams({
    required this.sign,
    required this.period,
    required this.languageCode,
  });

  @override
  List<Object?> get props => [sign, period, languageCode];
}
