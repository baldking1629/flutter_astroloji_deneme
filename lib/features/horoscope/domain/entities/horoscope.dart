import 'package:freezed_annotation/freezed_annotation.dart';

part 'horoscope.freezed.dart';

@freezed
class Horoscope with _$Horoscope {
  const factory Horoscope({
    required String sign,
    required String period,
    required String prediction,
  }) = _Horoscope;
}
