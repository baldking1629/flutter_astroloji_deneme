import 'package:freezed_annotation/freezed_annotation.dart';

part 'horoscope_reading.freezed.dart';

enum ReadingType {
  daily,
  weekly,
  monthly,
}

@freezed
class HoroscopeReading with _$HoroscopeReading {
  const factory HoroscopeReading({
    required String id,
    required String title,
    required String content,
    required ReadingType type,
    required String zodiacSign,
    required DateTime readingDate,
    required String? folderId,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _HoroscopeReading;
}
