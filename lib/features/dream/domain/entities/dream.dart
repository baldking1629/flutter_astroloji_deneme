import 'package:freezed_annotation/freezed_annotation.dart';

part 'dream.freezed.dart';

@freezed
class Dream with _$Dream {
  const factory Dream({
    required String id,
    required String title,
    required String content,
    required DateTime date,
    String? analysis,
    String? folderId,
  }) = _Dream;
}
