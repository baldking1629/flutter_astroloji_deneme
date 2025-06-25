import 'package:dreamscope/features/dream/domain/entities/dream.dart';

abstract class DreamRepository {
  Future<List<Dream>> getAllDreams();
  Future<Dream?> getDream(String id);
  Future<void> saveDream(Dream dream);
  Future<void> deleteDream(String id);
  Future<String> analyzeDream({required String dreamContent});
}
