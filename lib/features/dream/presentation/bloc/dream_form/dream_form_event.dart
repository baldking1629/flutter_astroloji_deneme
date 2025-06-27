part of 'dream_form_bloc.dart';

abstract class DreamFormEvent extends Equatable {
  const DreamFormEvent();

  @override
  List<Object> get props => [];
}

class SubmitDream extends DreamFormEvent {
  final String title;
  final String content;
  final DateTime date;
  final String? folderId;

  const SubmitDream({
    required this.title,
    required this.content,
    required this.date,
    this.folderId,
  });

  @override
  List<Object> get props => [title, content, date, folderId ?? ''];
}
