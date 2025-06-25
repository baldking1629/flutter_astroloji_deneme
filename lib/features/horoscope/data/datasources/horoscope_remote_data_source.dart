import 'package:dio/dio.dart';
import 'package:dreamscope/features/horoscope/data/models/horoscope_model.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

abstract class HoroscopeRemoteDataSource {
  Future<HoroscopeModel> getHoroscope({
    required String sign,
    required String period,
    required String languageCode,
  });
}

class GeminiHoroscopeRemoteDataSource implements HoroscopeRemoteDataSource {
  final GenerativeModel model;

  GeminiHoroscopeRemoteDataSource(this.model);

  @override
  Future<HoroscopeModel> getHoroscope({
    required String sign,
    required String period,
    required String languageCode,
  }) async {
    final prompt = _buildPrompt(sign, period, languageCode);
    final content = [Content.text(prompt)];
    final response = await model.generateContent(content);
    final prediction = response.text ?? '';
    return HoroscopeModel(sign: sign, period: period, prediction: prediction);
  }

  String _buildPrompt(String sign, String period, String languageCode) {
    final periodText = {
          'daily': languageCode == 'tr' ? 'günlük' : 'daily',
          'weekly': languageCode == 'tr' ? 'haftalık' : 'weekly',
          'monthly': languageCode == 'tr' ? 'aylık' : 'monthly',
        }[period] ??
        period;
    if (languageCode == 'tr') {
      return 'Lütfen $sign burcu için $periodText burç yorumu yap. Sadece Türkçe cevap ver.';
    } else {
      return 'Please give a $periodText horoscope prediction for $sign. Respond only in English.';
    }
  }
}
