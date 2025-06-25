import 'package:dreamscope/features/dream/domain/entities/dream.dart';
import 'package:dreamscope/features/dream/domain/repositories/dream_repository.dart';

class SaveDream {
  final DreamRepository repository;
  SaveDream(this.repository);

  Future<void> call(Dream dream) async {
    return repository.saveDream(dream);
  }
}
