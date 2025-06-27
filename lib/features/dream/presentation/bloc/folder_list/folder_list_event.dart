part of 'folder_list_bloc.dart';

abstract class FolderListEvent {}

class LoadFolders extends FolderListEvent {}

class AddFolder extends FolderListEvent {
  final String name;
  AddFolder(this.name);
}

class DeleteFolderEvent extends FolderListEvent {
  final String id;
  DeleteFolderEvent(this.id);
}
