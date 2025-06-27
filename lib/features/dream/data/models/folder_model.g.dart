// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'folder_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FolderModelImpl _$$FolderModelImplFromJson(Map<String, dynamic> json) =>
    _$FolderModelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      dreamCount: (json['dreamCount'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$FolderModelImplToJson(_$FolderModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'dreamCount': instance.dreamCount,
    };
