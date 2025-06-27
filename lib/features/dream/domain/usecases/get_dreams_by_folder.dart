import 'package:dreamscope/features/dream/domain/entities/dream.dart';
import 'package:dreamscope/features/dream/domain/repositories/dream_repository.dart';

class GetDreamsByFolder {
  final DreamRepository repository;
  GetDreamsByFolder(this.repository);

  Future<List<Dream>> call(String folderId) async {
    final allDreams = await repository.getAllDreams();
    return allDreams.where((dream) => dream.folderId == folderId).toList();
  }
}
