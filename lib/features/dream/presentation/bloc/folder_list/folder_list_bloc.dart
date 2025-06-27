import 'package:dreamscope/features/dream/domain/entities/folder.dart';
import 'package:dreamscope/features/dream/domain/usecases/get_all_folders.dart';
import 'package:dreamscope/features/dream/domain/usecases/save_folder.dart';
import 'package:dreamscope/features/dream/domain/usecases/delete_folder.dart';
import 'package:dreamscope/features/dream/domain/usecases/update_folder_dream_count.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

part 'folder_list_event.dart';
part 'folder_list_state.dart';

class FolderListBloc extends Bloc<FolderListEvent, FolderListState> {
  final GetAllFolders getAllFolders;
  final SaveFolder saveFolder;
  final DeleteFolder deleteFolder;
  final UpdateFolderDreamCount updateFolderDreamCount;

  FolderListBloc({
    required this.getAllFolders,
    required this.saveFolder,
    required this.deleteFolder,
    required this.updateFolderDreamCount,
  }) : super(FolderListInitial()) {
    on<LoadFolders>(_onLoadFolders);
    on<AddFolder>(_onAddFolder);
    on<DeleteFolderEvent>(_onDeleteFolder);
  }

  Future<void> _onLoadFolders(
      LoadFolders event, Emitter<FolderListState> emit) async {
    emit(FolderListLoading());
    try {
      final folders = await getAllFolders();

      // Her klasör için rüya sayısını güncelle
      for (final folder in folders) {
        await updateFolderDreamCount(folder.id);
      }

      // Güncellenmiş klasörleri tekrar al
      final updatedFolders = await getAllFolders();
      emit(FolderListLoaded(updatedFolders));
    } catch (e) {
      emit(FolderListError(e.toString()));
    }
  }

  Future<void> _onAddFolder(
      AddFolder event, Emitter<FolderListState> emit) async {
    try {
      final folder = Folder(
        id: const Uuid().v4(),
        name: event.name,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      await saveFolder(folder);
      add(LoadFolders());
    } catch (e) {
      emit(FolderListError(e.toString()));
    }
  }

  Future<void> _onDeleteFolder(
      DeleteFolderEvent event, Emitter<FolderListState> emit) async {
    try {
      await deleteFolder(event.id);
      add(LoadFolders());
    } catch (e) {
      emit(FolderListError(e.toString()));
    }
  }
}
