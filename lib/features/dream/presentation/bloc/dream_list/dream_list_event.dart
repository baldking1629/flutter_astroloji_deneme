part of 'dream_list_bloc.dart';

abstract class DreamListEvent extends Equatable {
  const DreamListEvent();
  @override
  List<Object> get props => [];
}

class LoadDreams extends DreamListEvent {}

class ChangeSortOrder extends DreamListEvent {
  final DreamSortType sortType;
  const ChangeSortOrder(this.sortType);
  @override
  List<Object> get props => [sortType];
}
