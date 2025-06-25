part of 'dream_form_bloc.dart';

abstract class DreamFormState extends Equatable {
  const DreamFormState();

  @override
  List<Object> get props => [];
}

class DreamFormInitial extends DreamFormState {}

class DreamFormSubmitting extends DreamFormState {}

class DreamFormSuccess extends DreamFormState {
  final Dream dream;

  const DreamFormSuccess(this.dream);

  @override
  List<Object> get props => [dream];
}

class DreamFormError extends DreamFormState {
  final String message;

  const DreamFormError(this.message);

  @override
  List<Object> get props => [message];
}
