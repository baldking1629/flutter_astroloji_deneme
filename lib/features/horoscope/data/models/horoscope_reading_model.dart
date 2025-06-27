import 'package:dreamscope/features/horoscope/domain/entities/horoscope_reading.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'horoscope_reading_model.freezed.dart';
part 'horoscope_reading_model.g.dart';

@freezed
class HoroscopeReadingModel with _$HoroscopeReadingModel {
  const factory HoroscopeReadingModel({
    required String id,
    required String title,
    required String content,
    required ReadingType type,
    required String zodiacSign,
    required DateTime readingDate,
    required String? folderId,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _HoroscopeReadingModel;

  factory HoroscopeReadingModel.fromJson(Map<String, dynamic> json) =>
      _$HoroscopeReadingModelFromJson(json);

  factory HoroscopeReadingModel.fromEntity(HoroscopeReading reading) =>
      HoroscopeReadingModel(
        id: reading.id,
        title: reading.title,
        content: reading.content,
        type: reading.type,
        zodiacSign: reading.zodiacSign,
        readingDate: reading.readingDate,
        folderId: reading.folderId,
        createdAt: reading.createdAt,
        updatedAt: reading.updatedAt,
      );
}

extension HoroscopeReadingModelExtension on HoroscopeReadingModel {
  HoroscopeReading toEntity() => HoroscopeReading(
        id: id,
        title: title,
        content: content,
        type: type,
        zodiacSign: zodiacSign,
        readingDate: readingDate,
        folderId: folderId,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}
