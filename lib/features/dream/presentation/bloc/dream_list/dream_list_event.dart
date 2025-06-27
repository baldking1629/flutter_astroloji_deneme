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
