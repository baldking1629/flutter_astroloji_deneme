import 'package:dreamscope/features/dream/domain/entities/dream.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'dream_model.freezed.dart';
part 'dream_model.g.dart';

@freezed
class DreamModel with _$DreamModel {
  const DreamModel._();

  const factory DreamModel({
    required String id,
    required String title,
    required String content,
    required DateTime date,
    String? analysis,
    String? folderId,
  }) = _DreamModel;

  factory DreamModel.fromJson(Map<String, dynamic> json) =>
      _$DreamModelFromJson(json);

  Dream toEntity() => Dream(
        id: id,
        title: title,
        content: content,
        date: date,
        analysis: analysis,
        folderId: folderId,
      );

  factory DreamModel.fromEntity(Dream entity) => DreamModel(
        id: entity.id,
        title: entity.title,
        content: entity.content,
        date: entity.date,
        analysis: entity.analysis,
        folderId: entity.folderId,
      );
}
