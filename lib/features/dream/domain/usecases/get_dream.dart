import 'package:dreamscope/features/dream/domain/entities/dream.dart';
import 'package:dreamscope/features/dream/domain/repositories/dream_repository.dart';

class GetDream {
  final DreamRepository repository;
  GetDream(this.repository);
  Future<Dream?> call(String id) => repository.getDream(id);
}
