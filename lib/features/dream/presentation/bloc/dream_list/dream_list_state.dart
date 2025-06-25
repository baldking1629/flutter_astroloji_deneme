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
  const DreamListLoaded(this.dreams);
  @override
  List<Object> get props => [dreams];
}

class DreamListError extends DreamListState {
  final String message;
  const DreamListError(this.message);
  @override
  List<Object> get props => [message];
}
