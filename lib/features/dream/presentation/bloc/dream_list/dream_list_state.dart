part of 'dream_list_bloc.dart';

abstract class DreamListState extends Equatable {
  const DreamListState();
  @override
  List<Object> get props => [];
}

class DreamListInitial extends DreamListState {}

class DreamListLoading extends DreamListState {}

class DreamListLoaded extends DreamListState {
  final List<Dream> dreams;
  final DreamSortType sortType;
  const DreamListLoaded(this.dreams, this.sortType);
  @override
  List<Object> get props => [dreams, sortType];
}

class DreamListError extends DreamListState {
  final String message;
  const DreamListError(this.message);
  @override
  List<Object> get props => [message];
}
