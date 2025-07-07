import 'package:dreamscope/features/dream/domain/entities/dream.dart';
import 'package:dreamscope/features/dream/domain/repositories/dream_repository.dart';
import 'package:dreamscope/features/dream/domain/usecases/update_folder_dream_count.dart';

class UpdateDream {
  final DreamRepository repository;
  final UpdateFolderDreamCount updateFolderDreamCount;

  UpdateDream(this.repository, this.updateFolderDreamCount);

  Future<void> call(Dream dream) async {
    // Eski rüyayı al (eski klasör bilgisi için)
    final oldDream = await repository.getDream(dream.id);
    final oldFolderId = oldDream?.folderId;
    
    // Rüyayı güncelle
    await repository.updateDream(dream);
    
    // Klasör sayılarını güncelle
    if (oldFolderId != null && oldFolderId != dream.folderId) {
      // Eski klasörün sayısını güncelle
      await updateFolderDreamCount(oldFolderId);
    }
    
    if (dream.folderId != null && dream.folderId != oldFolderId) {
      // Yeni klasörün sayısını güncelle
      await updateFolderDreamCount(dream.folderId!);
    }
  }
}