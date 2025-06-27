import 'dart:async';
import 'package:dreamscope/features/dream/domain/entities/dream.dart';
import 'package:dreamscope/features/dream/domain/usecases/analyze_dream.dart';
import 'package:dreamscope/features/dream/domain/usecases/save_dream.dart';
import 'package:dreamscope/features/dream/domain/usecases/update_folder_dream_count.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

part 'dream_form_event.dart';
part 'dream_form_state.dart';

class DreamFormBloc extends Bloc<DreamFormEvent, DreamFormState> {
  final SaveDream saveDream;
  final AnalyzeDream analyzeDream;
  final UpdateFolderDreamCount updateFolderDreamCount;

  DreamFormBloc({
    required this.saveDream,
    required this.analyzeDream,
    required this.updateFolderDreamCount,
  }) : super(DreamFormInitial()) {
    on<SubmitDream>(_onSubmitDream);
  }

  Future<void> _onSubmitDream(
      SubmitDream event, Emitter<DreamFormState> emit) async {
    emit(DreamFormSubmitting());
    try {
      final analysis = await analyzeDream(dreamContent: event.content);

      final dream = Dream(
        id: const Uuid().v4(),
        title: event.title,
        content: event.content,
        date: event.date,
        analysis: analysis,
        folderId: event.folderId,
      );

      await saveDream(dream);

      // Klasör varsa rüya sayısını güncelle
      if (event.folderId != null) {
        await updateFolderDreamCount(event.folderId!);
      }

      emit(DreamFormSuccess(dream));
    } catch (e) {
      emit(DreamFormError(e.toString()));
    }
  }
}
