import 'package:dreamscope/features/dream/domain/entities/folder.dart';
import 'package:dreamscope/features/dream/domain/repositories/folder_repository.dart';
import 'package:dreamscope/features/dream/domain/repositories/dream_repository.dart';

class UpdateFolderDreamCount {
  final FolderRepository folderRepository;
  final DreamRepository dreamRepository;

  UpdateFolderDreamCount({
    required this.folderRepository,
    required this.dreamRepository,
  });

  Future<void> call(String folderId) async {
    final dreams = await dreamRepository.getDreamsByFolder(folderId);
    final folder = await folderRepository.getFolder(folderId);

    if (folder != null) {
      final updatedFolder = folder.copyWith(
        dreamCount: dreams.length,
        updatedAt: DateTime.now(),
      );
      await folderRepository.saveFolder(updatedFolder);
    }
  }
}
