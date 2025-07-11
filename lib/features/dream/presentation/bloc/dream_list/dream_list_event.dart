part of 'dream_list_bloc.dart';

abstract class DreamListEvent extends Equatable {
  const DreamListEvent();

  @override
  List<Object> get props => [];
}

class LoadDreams extends DreamListEvent {
  final String? folderId;

  const LoadDreams({this.folderId});

  @override
  List<Object> get props => [folderId ?? ''];
}

class ChangeSortOrder extends DreamListEvent {
  final DreamSortType sortType;
  const ChangeSortOrder(this.sortType);
  @override
  List<Object> get props => [sortType];
}

class MoveDreamToFolder extends DreamListEvent {
  final String dreamId;
  final String? folderId;

  const MoveDreamToFolder({required this.dreamId, this.folderId});

  @override
  List<Object> get props => [dreamId, folderId ?? ''];
}

class DeleteDream extends DreamListEvent {
  final String dreamId;

  const DeleteDream(this.dreamId);

  @override
  List<Object> get props => [dreamId];
}
