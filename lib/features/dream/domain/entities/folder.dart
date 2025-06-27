import 'package:freezed_annotation/freezed_annotation.dart';

part 'folder.freezed.dart';

@freezed
class Folder with _$Folder {
  const factory Folder({
    required String id,
    required String name,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default(0) int dreamCount,
  }) = _Folder;
}
