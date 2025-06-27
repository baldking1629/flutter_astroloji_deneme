import 'package:dreamscope/features/dream/data/datasources/dream_local_data_source.dart';
import 'package:dreamscope/features/dream/data/datasources/dream_remote_data_source.dart';
import 'package:dreamscope/features/dream/data/models/dream_model.dart';
import 'package:dreamscope/features/dream/domain/entities/dream.dart';
import 'package:dreamscope/features/dream/domain/repositories/dream_repository.dart';

class DreamRepositoryImpl implements DreamRepository {
  final DreamLocalDataSource localDataSource;
  final DreamRemoteDataSource remoteDataSource;

  DreamRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<String> analyzeDream({required String dreamContent}) async {
    // CRITICAL RULE IMPLEMENTATION:
    const instruction =
        "Analyze the following dream. Your response MUST be in the same language as the input text provided. Here is the dream:";
    final fullPrompt = "$instruction\n\n\"$dreamContent\"";

    return remoteDataSource.analyzeDream(prompt: fullPrompt);
  }

  @override
  Future<void> deleteDream(String id) async {
    return localDataSource.deleteDream(id);
  }

  @override
  Future<List<Dream>> getAllDreams() async {
    final dreamModels = await localDataSource.getAllDreams();
    return dreamModels.map((model) => model.toEntity()).toList();
  }

  @override
  Future<List<Dream>> getDreamsByFolder(String folderId) async {
    final dreamModels = await localDataSource.getAllDreams();
    final filteredModels =
        dreamModels.where((model) => model.folderId == folderId).toList();
    return filteredModels.map((model) => model.toEntity()).toList();
  }

  @override
  Future<Dream?> getDream(String id) async {
    final model = await localDataSource.getDream(id);
    return model?.toEntity();
  }

  @override
  Future<void> saveDream(Dream dream) async {
    final dreamModel = DreamModel.fromEntity(dream);
    return localDataSource.saveDream(dreamModel);
  }
}
