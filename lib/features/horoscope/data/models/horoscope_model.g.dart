// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'horoscope_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HoroscopeModelImpl _$$HoroscopeModelImplFromJson(Map<String, dynamic> json) =>
    _$HoroscopeModelImpl(
      sign: json['sign'] as String,
      period: json['period'] as String,
      prediction: json['prediction'] as String,
    );

Map<String, dynamic> _$$HoroscopeModelImplToJson(
        _$HoroscopeModelImpl instance) =>
    <String, dynamic>{
      'sign': instance.sign,
      'period': instance.period,
      'prediction': instance.prediction,
    };
