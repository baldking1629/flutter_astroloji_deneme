// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'horoscope_reading_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HoroscopeReadingModelImpl _$$HoroscopeReadingModelImplFromJson(
        Map<String, dynamic> json) =>
    _$HoroscopeReadingModelImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      type: $enumDecode(_$ReadingTypeEnumMap, json['type']),
      zodiacSign: json['zodiacSign'] as String,
      readingDate: DateTime.parse(json['readingDate'] as String),
      folderId: json['folderId'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$HoroscopeReadingModelImplToJson(
        _$HoroscopeReadingModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'content': instance.content,
      'type': _$ReadingTypeEnumMap[instance.type]!,
      'zodiacSign': instance.zodiacSign,
      'readingDate': instance.readingDate.toIso8601String(),
      'folderId': instance.folderId,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$ReadingTypeEnumMap = {
  ReadingType.daily: 'daily',
  ReadingType.weekly: 'weekly',
  ReadingType.monthly: 'monthly',
};
