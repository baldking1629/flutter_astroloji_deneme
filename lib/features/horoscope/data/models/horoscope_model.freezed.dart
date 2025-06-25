// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'horoscope_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

HoroscopeModel _$HoroscopeModelFromJson(Map<String, dynamic> json) {
  return _HoroscopeModel.fromJson(json);
}

/// @nodoc
mixin _$HoroscopeModel {
  String get sign => throw _privateConstructorUsedError;
  String get period => throw _privateConstructorUsedError;
  String get prediction => throw _privateConstructorUsedError;

  /// Serializes this HoroscopeModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of HoroscopeModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HoroscopeModelCopyWith<HoroscopeModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HoroscopeModelCopyWith<$Res> {
  factory $HoroscopeModelCopyWith(
          HoroscopeModel value, $Res Function(HoroscopeModel) then) =
      _$HoroscopeModelCopyWithImpl<$Res, HoroscopeModel>;
  @useResult
  $Res call({String sign, String period, String prediction});
}

/// @nodoc
class _$HoroscopeModelCopyWithImpl<$Res, $Val extends HoroscopeModel>
    implements $HoroscopeModelCopyWith<$Res> {
  _$HoroscopeModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HoroscopeModel
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
abstract class _$$HoroscopeModelImplCopyWith<$Res>
    implements $HoroscopeModelCopyWith<$Res> {
  factory _$$HoroscopeModelImplCopyWith(_$HoroscopeModelImpl value,
          $Res Function(_$HoroscopeModelImpl) then) =
      __$$HoroscopeModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String sign, String period, String prediction});
}

/// @nodoc
class __$$HoroscopeModelImplCopyWithImpl<$Res>
    extends _$HoroscopeModelCopyWithImpl<$Res, _$HoroscopeModelImpl>
    implements _$$HoroscopeModelImplCopyWith<$Res> {
  __$$HoroscopeModelImplCopyWithImpl(
      _$HoroscopeModelImpl _value, $Res Function(_$HoroscopeModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of HoroscopeModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sign = null,
    Object? period = null,
    Object? prediction = null,
  }) {
    return _then(_$HoroscopeModelImpl(
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
@JsonSerializable()
class _$HoroscopeModelImpl extends _HoroscopeModel {
  const _$HoroscopeModelImpl(
      {required this.sign, required this.period, required this.prediction})
      : super._();

  factory _$HoroscopeModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$HoroscopeModelImplFromJson(json);

  @override
  final String sign;
  @override
  final String period;
  @override
  final String prediction;

  @override
  String toString() {
    return 'HoroscopeModel(sign: $sign, period: $period, prediction: $prediction)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HoroscopeModelImpl &&
            (identical(other.sign, sign) || other.sign == sign) &&
            (identical(other.period, period) || other.period == period) &&
            (identical(other.prediction, prediction) ||
                other.prediction == prediction));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, sign, period, prediction);

  /// Create a copy of HoroscopeModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HoroscopeModelImplCopyWith<_$HoroscopeModelImpl> get copyWith =>
      __$$HoroscopeModelImplCopyWithImpl<_$HoroscopeModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HoroscopeModelImplToJson(
      this,
    );
  }
}

abstract class _HoroscopeModel extends HoroscopeModel {
  const factory _HoroscopeModel(
      {required final String sign,
      required final String period,
      required final String prediction}) = _$HoroscopeModelImpl;
  const _HoroscopeModel._() : super._();

  factory _HoroscopeModel.fromJson(Map<String, dynamic> json) =
      _$HoroscopeModelImpl.fromJson;

  @override
  String get sign;
  @override
  String get period;
  @override
  String get prediction;

  /// Create a copy of HoroscopeModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HoroscopeModelImplCopyWith<_$HoroscopeModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
