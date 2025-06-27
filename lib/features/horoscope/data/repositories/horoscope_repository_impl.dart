import 'package:dreamscope/features/horoscope/data/datasources/horoscope_remote_data_source.dart';
import 'package:dreamscope/features/horoscope/domain/entities/horoscope.dart';
import 'package:dreamscope/features/horoscope/domain/repositories/horoscope_repository.dart';

class HoroscopeRepositoryImpl implements HoroscopeRepository {
  final HoroscopeRemoteDataSource remoteDataSource;

  HoroscopeRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Horoscope> getHoroscope({
    required String sign,
    String? ascendant,
    required String period,
    required String languageCode,
    required DateTime date,
  }) async {
    final model = await remoteDataSource.getHoroscope(
      sign: sign,
      ascendant: ascendant,
      period: period,
      languageCode: languageCode,
      date: date,
    );
    return model.toEntity();
  }
}
