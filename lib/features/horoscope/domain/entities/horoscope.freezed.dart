// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'horoscope.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$Horoscope {
  String get sign => throw _privateConstructorUsedError;
  String get period => throw _privateConstructorUsedError;
  String get prediction => throw _privateConstructorUsedError;

  /// Create a copy of Horoscope
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HoroscopeCopyWith<Horoscope> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HoroscopeCopyWith<$Res> {
  factory $HoroscopeCopyWith(Horoscope value, $Res Function(Horoscope) then) =
      _$HoroscopeCopyWithImpl<$Res, Horoscope>;
  @useResult
  $Res call({String sign, String period, String prediction});
}

/// @nodoc
class _$HoroscopeCopyWithImpl<$Res, $Val extends Horoscope>
    implements $HoroscopeCopyWith<$Res> {
  _$HoroscopeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Horoscope
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sign = null,
    Object? period = null,
    Object? prediction = null,
  }) {
    return _then(_value.copyWith(
      sign: null == sign
          ? _value.sign
          : sign // ignore: cast_nullable_to_non_nullable
              as String,
      period: null == period
          ? _value.period
          : period // ignore: cast_nullable_to_non_nullable
              as String,
      prediction: null == prediction
          ? _value.prediction
          : prediction // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HoroscopeImplCopyWith<$Res>
    implements $HoroscopeCopyWith<$Res> {
  factory _$$HoroscopeImplCopyWith(
          _$HoroscopeImpl value, $Res Function(_$HoroscopeImpl) then) =
      __$$HoroscopeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String sign, String period, String prediction});
}

/// @nodoc
class __$$HoroscopeImplCopyWithImpl<$Res>
    extends _$HoroscopeCopyWithImpl<$Res, _$HoroscopeImpl>
    implements _$$HoroscopeImplCopyWith<$Res> {
  __$$HoroscopeImplCopyWithImpl(
      _$HoroscopeImpl _value, $Res Function(_$HoroscopeImpl) _then)
      : super(_value, _then);

  /// Create a copy of Horoscope
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sign = null,
    Object? period = null,
    Object? prediction = null,
  }) {
    return _then(_$HoroscopeImpl(
      sign: null == sign
          ? _value.sign
          : sign // ignore: cast_nullable_to_non_nullable
              as String,
      period: null == period
          ? _value.period
          : period // ignore: cast_nullable_to_non_nullable
              as String,
      prediction: null == prediction
          ? _value.prediction
          : prediction // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$HoroscopeImpl implements _Horoscope {
  const _$HoroscopeImpl(
      {required this.sign, required this.period, required this.prediction});

  @override
  final String sign;
  @override
  final String period;
  @override
  final String prediction;

  @override
  String toString() {
    return 'Horoscope(sign: $sign, period: $period, prediction: $prediction)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HoroscopeImpl &&
            (identical(other.sign, sign) || other.sign == sign) &&
            (identical(other.period, period) || other.period == period) &&
            (identical(other.prediction, prediction) ||
                other.prediction == prediction));
  }

  @override
  int get hashCode => Object.hash(runtimeType, sign, period, prediction);

  /// Create a copy of Horoscope
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HoroscopeImplCopyWith<_$HoroscopeImpl> get copyWith =>
      __$$HoroscopeImplCopyWithImpl<_$HoroscopeImpl>(this, _$identity);
}

abstract class _Horoscope implements Horoscope {
  const factory _Horoscope(
      {required final String sign,
      required final String period,
      required final String prediction}) = _$HoroscopeImpl;

  @override
  String get sign;
  @override
  String get period;
  @override
  String get prediction;

  /// Create a copy of Horoscope
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HoroscopeImplCopyWith<_$HoroscopeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
