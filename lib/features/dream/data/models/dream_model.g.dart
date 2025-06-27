// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dream_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DreamModelImpl _$$DreamModelImplFromJson(Map<String, dynamic> json) =>
    _$DreamModelImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      date: DateTime.parse(json['date'] as String),
      analysis: json['analysis'] as String?,
      folderId: json['folderId'] as String?,
    );

Map<String, dynamic> _$$DreamModelImplToJson(_$DreamModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'content': instance.content,
      'date': instance.date.toIso8601String(),
      'analysis': instance.analysis,
      'folderId': instance.folderId,
    };
