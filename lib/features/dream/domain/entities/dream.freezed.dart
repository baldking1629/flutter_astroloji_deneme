// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dream.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$Dream {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  DateTime get date => throw _privateConstructorUsedError;
  String? get analysis => throw _privateConstructorUsedError;

  /// Create a copy of Dream
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DreamCopyWith<Dream> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DreamCopyWith<$Res> {
  factory $DreamCopyWith(Dream value, $Res Function(Dream) then) =
      _$DreamCopyWithImpl<$Res, Dream>;
  @useResult
  $Res call(
      {String id,
      String title,
      String content,
      DateTime date,
      String? analysis});
}

/// @nodoc
class _$DreamCopyWithImpl<$Res, $Val extends Dream>
    implements $DreamCopyWith<$Res> {
  _$DreamCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Dream
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
abstract class _$$DreamImplCopyWith<$Res> implements $DreamCopyWith<$Res> {
  factory _$$DreamImplCopyWith(
          _$DreamImpl value, $Res Function(_$DreamImpl) then) =
      __$$DreamImplCopyWithImpl<$Res>;
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
class __$$DreamImplCopyWithImpl<$Res>
    extends _$DreamCopyWithImpl<$Res, _$DreamImpl>
    implements _$$DreamImplCopyWith<$Res> {
  __$$DreamImplCopyWithImpl(
      _$DreamImpl _value, $Res Function(_$DreamImpl) _then)
      : super(_value, _then);

  /// Create a copy of Dream
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
    return _then(_$DreamImpl(
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

class _$DreamImpl implements _Dream {
  const _$DreamImpl(
      {required this.id,
      required this.title,
      required this.content,
      required this.date,
      this.analysis});

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
    return 'Dream(id: $id, title: $title, content: $content, date: $date, analysis: $analysis)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DreamImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.analysis, analysis) ||
                other.analysis == analysis));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, id, title, content, date, analysis);

  /// Create a copy of Dream
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DreamImplCopyWith<_$DreamImpl> get copyWith =>
      __$$DreamImplCopyWithImpl<_$DreamImpl>(this, _$identity);
}

abstract class _Dream implements Dream {
  const factory _Dream(
      {required final String id,
      required final String title,
      required final String content,
      required final DateTime date,
      final String? analysis}) = _$DreamImpl;

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

  /// Create a copy of Dream
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DreamImplCopyWith<_$DreamImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
