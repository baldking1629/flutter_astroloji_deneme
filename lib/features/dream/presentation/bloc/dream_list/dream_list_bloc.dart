import 'package:dreamscope/features/dream/domain/entities/dream.dart';
import 'package:dreamscope/features/dream/domain/usecases/get_all_dreams.dart';
import 'package:dreamscope/features/dream/domain/usecases/get_dreams_by_folder.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'dream_list_event.dart';
part 'dream_list_state.dart';

enum DreamSortType { dateDesc, dateAsc, titleAsc, titleDesc }

class DreamListBloc extends Bloc<DreamListEvent, DreamListState> {
  final GetAllDreams getAllDreams;
  final GetDreamsByFolder getDreamsByFolder;
  DreamSortType _sortType = DreamSortType.dateDesc;
  String? _currentFolderId;

  DreamListBloc({
    required this.getAllDreams,
    required this.getDreamsByFolder,
  }) : super(DreamListInitial()) {
    on<LoadDreams>(_onLoadDreams);
    on<ChangeSortOrder>(_onChangeSortOrder);
  }

  Future<void> _onLoadDreams(
      LoadDreams event, Emitter<DreamListState> emit) async {
    emit(DreamListLoading());
    try {
      _currentFolderId = event.folderId;
      List<Dream> dreams;

      if (event.folderId != null) {
        dreams = await getDreamsByFolder(event.folderId!);
      } else {
        dreams = await getAllDreams();
      }

      emit(DreamListLoaded(_sortDreams(dreams, _sortType), _sortType));
    } catch (e) {
      emit(DreamListError(e.toString()));
    }
  }

  void _onChangeSortOrder(
      ChangeSortOrder event, Emitter<DreamListState> emit) async {
    _sortType = event.sortType;
    if (state is DreamListLoaded) {
      final loaded = state as DreamListLoaded;
      emit(DreamListLoaded(
          _sortDreams(List.from(loaded.dreams), _sortType), _sortType));
    } else {
      add(LoadDreams(folderId: _currentFolderId));
    }
  }

  List<Dream> _sortDreams(List<Dream> dreams, DreamSortType sortType) {
    switch (sortType) {
      case DreamSortType.dateDesc:
        dreams.sort((a, b) => b.date.compareTo(a.date));
        break;
      case DreamSortType.dateAsc:
        dreams.sort((a, b) => a.date.compareTo(b.date));
        break;
      case DreamSortType.titleAsc:
        dreams.sort(
            (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
        break;
      case DreamSortType.titleDesc:
        dreams.sort(
            (a, b) => b.title.toLowerCase().compareTo(a.title.toLowerCase()));
        break;
    }
    return dreams;
  }
}
