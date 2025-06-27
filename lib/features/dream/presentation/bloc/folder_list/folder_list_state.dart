part of 'folder_list_bloc.dart';

abstract class FolderListState {}

class FolderListInitial extends FolderListState {}

class FolderListLoading extends FolderListState {}

class FolderListLoaded extends FolderListState {
  final List<Folder> folders;
  FolderListLoaded(this.folders);
}

class FolderListError extends FolderListState {
  final String message;
  FolderListError(this.message);
}
