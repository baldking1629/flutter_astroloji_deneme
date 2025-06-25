import 'package:dreamscope/features/horoscope/domain/entities/horoscope.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'horoscope_model.freezed.dart';
part 'horoscope_model.g.dart';

@freezed
class HoroscopeModel with _$HoroscopeModel {
  const HoroscopeModel._();

  const factory HoroscopeModel({
    required String sign,
    required String period,
    required String prediction,
  }) = _HoroscopeModel;

  factory HoroscopeModel.fromJson(Map<String, dynamic> json) =>
      _$HoroscopeModelFromJson(json);

  Horoscope toEntity() => Horoscope(
        sign: sign,
        period: period,
        prediction: prediction,
      );
}
