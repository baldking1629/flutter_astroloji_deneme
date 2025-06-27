import 'package:dreamscope/features/dream/domain/entities/folder.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'folder_model.freezed.dart';
part 'folder_model.g.dart';

@freezed
class FolderModel with _$FolderModel {
  const factory FolderModel({
    required String id,
    required String name,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default(0) int dreamCount,
  }) = _FolderModel;

  factory FolderModel.fromJson(Map<String, dynamic> json) =>
      _$FolderModelFromJson(json);

  factory FolderModel.fromEntity(Folder folder) => FolderModel(
        id: folder.id,
        name: folder.name,
        createdAt: folder.createdAt,
        updatedAt: folder.updatedAt,
        dreamCount: folder.dreamCount,
      );
}

extension FolderModelExtension on FolderModel {
  Folder toEntity() => Folder(
        id: id,
        name: name,
        createdAt: createdAt,
        updatedAt: updatedAt,
        dreamCount: dreamCount,
      );
}
