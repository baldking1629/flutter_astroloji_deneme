import 'package:dreamscope/features/dream/domain/entities/dream.dart';
import 'package:dreamscope/features/dream/domain/usecases/get_all_dreams.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'dream_list_event.dart';
part 'dream_list_state.dart';

class DreamListBloc extends Bloc<DreamListEvent, DreamListState> {
  final GetAllDreams getAllDreams;

  DreamListBloc({required this.getAllDreams}) : super(DreamListInitial()) {
    on<LoadDreams>(_onLoadDreams);
  }

  Future<void> _onLoadDreams(
      LoadDreams event, Emitter<DreamListState> emit) async {
    emit(DreamListLoading());
    try {
      final dreams = await getAllDreams();
      dreams.sort((a, b) => b.date.compareTo(a.date));
      emit(DreamListLoaded(dreams));
    } catch (e) {
      emit(DreamListError(e.toString()));
    }
  }
}
