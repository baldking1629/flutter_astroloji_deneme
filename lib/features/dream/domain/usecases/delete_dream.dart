import 'package:dreamscope/features/dream/domain/entities/dream.dart';
import 'package:dreamscope/features/dream/domain/repositories/dream_repository.dart';
import 'package:dreamscope/features/dream/domain/usecases/update_folder_dream_count.dart';

class DeleteDream {
  final DreamRepository repository;
  final UpdateFolderDreamCount updateFolderDreamCount;

  DeleteDream(this.repository, this.updateFolderDreamCount);

  Future<void> call(String id) async {
    // Önce rüyayı al
    final dream = await repository.getDream(id);
    final folderId = dream?.folderId;
    
    // Rüyayı sil
    await repository.deleteDream(id);
    
    // Eğer klasör varsa sayısını güncelle
    if (folderId != null) {
      await updateFolderDreamCount(folderId);
    }
  }
}
