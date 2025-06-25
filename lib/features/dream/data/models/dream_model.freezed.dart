// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dream_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DreamModel _$DreamModelFromJson(Map<String, dynamic> json) {
  return _DreamModel.fromJson(json);
}

/// @nodoc
mixin _$DreamModel {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  DateTime get date => throw _privateConstructorUsedError;
  String? get analysis => throw _privateConstructorUsedError;

  /// Serializes this DreamModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DreamModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DreamModelCopyWith<DreamModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DreamModelCopyWith<$Res> {
  factory $DreamModelCopyWith(
          DreamModel value, $Res Function(DreamModel) then) =
      _$DreamModelCopyWithImpl<$Res, DreamModel>;
  @useResult
  $Res call(
      {String id,
      String title,
      String content,
      DateTime date,
      String? analysis});
}

/// @nodoc
class _$DreamModelCopyWithImpl<$Res, $Val extends DreamModel>
    implements $DreamModelCopyWith<$Res> {
  _$DreamModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DreamModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? content = null,
    Object? date = null,
    Object? analysis = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      analysis: freezed == analysis
          ? _value.analysis
          : analysis // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DreamModelImplCopyWith<$Res>
    implements $DreamModelCopyWith<$Res> {
  factory _$$DreamModelImplCopyWith(
          _$DreamModelImpl value, $Res Function(_$DreamModelImpl) then) =
      __$$DreamModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      String content,
      DateTime date,
      String? analysis});
}

/// @nodoc
class __$$DreamModelImplCopyWithImpl<$Res>
    extends _$DreamModelCopyWithImpl<$Res, _$DreamModelImpl>
    implements _$$DreamModelImplCopyWith<$Res> {
  __$$DreamModelImplCopyWithImpl(
      _$DreamModelImpl _value, $Res Function(_$DreamModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of DreamModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? content = null,
    Object? date = null,
    Object? analysis = freezed,
  }) {
    return _then(_$DreamModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      analysis: freezed == analysis
          ? _value.analysis
          : analysis // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DreamModelImpl extends _DreamModel {
  const _$DreamModelImpl(
      {required this.id,
      required this.title,
      required this.content,
      required this.date,
      this.analysis})
      : super._();

  factory _$DreamModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$DreamModelImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String content;
  @override
  final DateTime date;
  @override
  final String? analysis;

  @override
  String toString() {
    return 'DreamModel(id: $id, title: $title, content: $content, date: $date, analysis: $analysis)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DreamModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.analysis, analysis) ||
                other.analysis == analysis));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, title, content, date, analysis);

  /// Create a copy of DreamModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DreamModelImplCopyWith<_$DreamModelImpl> get copyWith =>
      __$$DreamModelImplCopyWithImpl<_$DreamModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DreamModelImplToJson(
      this,
    );
  }
}

abstract class _DreamModel extends DreamModel {
  const factory _DreamModel(
      {required final String id,
      required final String title,
      required final String content,
      required final DateTime date,
      final String? analysis}) = _$DreamModelImpl;
  const _DreamModel._() : super._();

  factory _DreamModel.fromJson(Map<String, dynamic> json) =
      _$DreamModelImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get content;
  @override
  DateTime get date;
  @override
  String? get analysis;

  /// Create a copy of DreamModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DreamModelImplCopyWith<_$DreamModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
