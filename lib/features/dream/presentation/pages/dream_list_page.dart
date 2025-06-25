import 'package:dreamscope/features/dream/presentation/bloc/dream_list/dream_list_bloc.dart';
import 'package:dreamscope/features/dream/presentation/widgets/dream_card.dart';
import 'package:dreamscope/injection_container.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class DreamListPage extends StatelessWidget {
  const DreamListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<DreamListBloc>()..add(LoadDreams()),
      child: DreamListView(),
    );
  }
}

class DreamListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.dreamListTitle),
        actions: [
          BlocBuilder<DreamListBloc, DreamListState>(
            builder: (context, state) {
              DreamSortType sortType = DreamSortType.dateDesc;
              if (state is DreamListLoaded) sortType = state.sortType;
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: PopupMenuButton<DreamSortType>(
                  tooltip: 'Sırala',
                  icon: Icon(Icons.sort, color: theme.colorScheme.primary),
                  onSelected: (type) {
                    context.read<DreamListBloc>().add(ChangeSortOrder(type));
                  },
                  initialValue: sortType,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  color: theme.colorScheme.surface,
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: DreamSortType.dateDesc,
                      child: Row(
                        children: [
                          Icon(Icons.schedule,
                              size: 18, color: theme.colorScheme.primary),
                          const SizedBox(width: 8),
                          Text(l10n.sortDateDesc),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: DreamSortType.dateAsc,
                      child: Row(
                        children: [
                          Icon(Icons.schedule_outlined,
                              size: 18, color: theme.colorScheme.primary),
                          const SizedBox(width: 8),
                          Text(l10n.sortDateAsc),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: DreamSortType.titleAsc,
                      child: Row(
                        children: [
                          Icon(Icons.sort_by_alpha,
                              size: 18, color: theme.colorScheme.primary),
                          const SizedBox(width: 8),
                          Text(l10n.sortTitleAsc),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: DreamSortType.titleDesc,
                      child: Row(
                        children: [
                          Icon(Icons.sort_by_alpha,
                              size: 18, color: theme.colorScheme.primary),
                          const SizedBox(width: 8),
                          Text(l10n.sortTitleDesc),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: BlocConsumer<DreamListBloc, DreamListState>(
        listener: (context, state) {
          if (state is DreamListError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is DreamListLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is DreamListLoaded) {
            if (state.dreams.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Text(
                    l10n.noDreamsMessage,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyLarge,
                  ),
                ),
              );
            }
            return RefreshIndicator(
              onRefresh: () async {
                context.read<DreamListBloc>().add(LoadDreams());
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: state.dreams.length,
                itemBuilder: (context, index) {
                  return DreamCard(dream: state.dreams[index]);
                },
              ),
            );
          }
          return Center(child: Text(l10n.errorOccurred));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('/add-dream').then((result) {
            if (result == true) {
              context.read<DreamListBloc>().add(LoadDreams());
            }
          });
        },
        tooltip: l10n.addDreamHint,
        child: const Icon(Icons.add),
      ),
    );
  }
}
