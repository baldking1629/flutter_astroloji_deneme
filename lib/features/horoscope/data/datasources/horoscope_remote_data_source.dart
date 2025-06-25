import 'package:dio/dio.dart';
import 'package:dreamscope/features/horoscope/data/models/horoscope_model.dart';

abstract class HoroscopeRemoteDataSource {
  Future<HoroscopeModel> getHoroscope({
    required String sign,
    required String period,
    required String languageCode,
  });
}

class MockHoroscopeRemoteDataSource implements HoroscopeRemoteDataSource {
  final Dio dio;

  MockHoroscopeRemoteDataSource(this.dio);

  @override
  Future<HoroscopeModel> getHoroscope({
    required String sign,
    required String period,
    required String languageCode,
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    String prediction;
    if (languageCode == 'tr') {
      prediction =
          "${sign} burcu için ${period} yorumu: Bugün yıldızlar sizin için parlıyor. Beklenmedik fırsatlar kapınızı çalabilir. Açık fikirli olun ve yeni maceralara atılmaktan çekinmeyin. İlişkilerinizde iletişim anahtar olacak.";
    } else {
      prediction =
          "The ${period} horoscope for ${sign}: The stars are aligning for you today. Unexpected opportunities may knock on your door. Be open-minded and don't hesitate to embark on new adventures. Communication will be key in your relationships.";
    }

    return HoroscopeModel(sign: sign, period: period, prediction: prediction);
  }
}
