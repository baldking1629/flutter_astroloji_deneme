import 'package:dreamscope/features/dream/domain/repositories/dream_repository.dart';

class DeleteDream {
  final DreamRepository repository;
  DeleteDream(this.repository);
  Future<void> call(String id) => repository.deleteDream(id);
}
