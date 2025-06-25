part of 'dream_form_bloc.dart';

abstract class DreamFormEvent extends Equatable {
  const DreamFormEvent();

  @override
  List<Object> get props => [];
}

class SubmitDream extends DreamFormEvent {
  final String title;
  final String content;

  const SubmitDream({required this.title, required this.content});

  @override
  List<Object> get props => [title, content];
}
