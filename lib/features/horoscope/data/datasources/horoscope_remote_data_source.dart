import 'package:dio/dio.dart';
import 'package:dreamscope/features/horoscope/data/models/horoscope_model.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

abstract class HoroscopeRemoteDataSource {
  Future<HoroscopeModel> getHoroscope({
    required String sign,
    required String period,
    required String languageCode,
    required DateTime date,
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
    required DateTime date,
  }) async {
    final prompt = _buildPrompt(sign, period, languageCode, date);
    final content = [Content.text(prompt)];
    final response = await model.generateContent(content);
    final prediction = response.text ?? '';
    return HoroscopeModel(sign: sign, period: period, prediction: prediction);
  }

  String _buildPrompt(
      String sign, String period, String languageCode, DateTime date) {
    final periodText = {
          'daily': languageCode == 'tr' ? 'günlük' : 'daily',
          'weekly': languageCode == 'tr' ? 'haftalık' : 'weekly',
          'monthly': languageCode == 'tr' ? 'aylık' : 'monthly',
        }[period] ??
        period;

    String formattedDate;
    if (period == 'daily') {
      formattedDate = languageCode == 'tr'
          ? '${date.day} ${_trMonthName(date.month)} ${date.year}'
          : '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    } else if (period == 'weekly') {
      final weekStart = date.subtract(Duration(days: date.weekday - 1));
      final weekEnd = weekStart.add(const Duration(days: 6));
      formattedDate = languageCode == 'tr'
          ? '${weekStart.day} ${_trMonthName(weekStart.month)} - ${weekEnd.day} ${_trMonthName(weekEnd.month)} ${weekEnd.year}'
          : '${weekStart.year}-${weekStart.month.toString().padLeft(2, '0')}-${weekStart.day.toString().padLeft(2, '0')} to ${weekEnd.year}-${weekEnd.month.toString().padLeft(2, '0')}-${weekEnd.day.toString().padLeft(2, '0')}';
    } else {
      formattedDate = languageCode == 'tr'
          ? '${_trMonthName(date.month)} ${date.year}'
          : '${_enMonthName(date.month)} ${date.year}';
    }

    if (languageCode == 'tr') {
      return '''
Lütfen $sign burcu için $formattedDate tarihine özel, profesyonel ve detaylı bir $periodText burç yorumu hazırla.
Yorumda şunlara mutlaka yer ver:
+- Yorumun başında tarih bilgisini belirt.
+- O gün/hafta/ay için önemli gezegen hareketlerini (örneğin Mars, Venüs, Merkür retrosu, dolunay, yeniay gibi) ve bu hareketlerin $sign burcuna etkilerini açıkla.
+- Astrolojik terimler kullan.
+- Yorumun sonunda genel bir tavsiye ver.
+- Yorumun dili akıcı, anlaşılır ve profesyonel olsun.
Sadece Türkçe cevap ver.''';
    } else {
      return '''
Please prepare a professional and detailed $periodText horoscope for $sign for $formattedDate.
Include the following in your response:
+- Clearly state the date at the beginning.
+- Mention important planetary movements (such as Mars, Venus, Mercury retrograde, full moon, new moon, etc.) and their effects on $sign during this period.
+- Use astrological terminology.
+- End with a general advice.
+- The language should be fluent, clear, and professional.
Respond only in English.''';
    }
  }

  String _trMonthName(int month) {
    const months = [
      '',
      'Ocak',
      'Şubat',
      'Mart',
      'Nisan',
      'Mayıs',
      'Haziran',
      'Temmuz',
      'Ağustos',
      'Eylül',
      'Ekim',
      'Kasım',
      'Aralık'
    ];
    return months[month];
  }

  String _enMonthName(int month) {
    const months = [
      '',
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return months[month];
  }
}
