import 'package:dreamscope/features/dream/domain/entities/dream.dart';
import 'package:dreamscope/features/dream/domain/repositories/dream_repository.dart';

class GetAllDreams {
  final DreamRepository repository;
  GetAllDreams(this.repository);

  Future<List<Dream>> call() async {
    return repository.getAllDreams();
  }
}
