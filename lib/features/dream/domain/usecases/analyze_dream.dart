import 'package:dreamscope/features/dream/domain/repositories/dream_repository.dart';

class AnalyzeDream {
  final DreamRepository repository;
  AnalyzeDream(this.repository);

  Future<String> call({required String dreamContent}) async {
    return repository.analyzeDream(dreamContent: dreamContent);
  }
}
