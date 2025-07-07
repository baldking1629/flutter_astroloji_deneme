import 'package:dreamscope/features/dream/presentation/bloc/dream_list/dream_list_bloc.dart';
import 'package:dreamscope/features/dream/presentation/bloc/folder_list/folder_list_bloc.dart';
import 'package:dreamscope/features/dream/presentation/widgets/dream_card.dart';
import 'package:dreamscope/features/dream/presentation/widgets/folder_card.dart';
import 'package:dreamscope/injection_container.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class DreamListPage extends StatelessWidget {
  final String? folderId;

  const DreamListPage({super.key, this.folderId});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              sl<DreamListBloc>()..add(LoadDreams(folderId: folderId)),
        ),
        BlocProvider(
          create: (context) => sl<FolderListBloc>()..add(LoadFolders()),
        ),
      ],
      child: DreamListView(folderId: folderId),
    );
  }
}

class DreamListView extends StatefulWidget {
  final String? folderId;

  const DreamListView({super.key, this.folderId});

  @override
  State<DreamListView> createState() => _DreamListViewState();
}

class _DreamListViewState extends State<DreamListView>
    with SingleTickerProviderStateMixin {

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex:
          widget.folderId != null ? 0 : 0, // Varsayılan olarak rüyalar tab'ı
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.folderId != null ? 'Klasör Rüyaları' : 'Rüyalar'),
        bottom: widget.folderId == null
            ? TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: 'Rüyalar', icon: Icon(Icons.nightlight_round)),
                  Tab(text: 'Klasörler', icon: Icon(Icons.folder)),
                ],
              )
            : null,
        actions: [
          if (widget.folderId == null && _tabController.index == 1)
            IconButton(
              onPressed: () => _showAddFolderDialog(context),
              icon: const Icon(Icons.add),
              tooltip: 'Yeni Klasör Ekle',
            ),
          BlocBuilder<DreamListBloc, DreamListState>(
            builder: (context, state) {
              if (widget.folderId != null || _tabController.index == 0) {
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
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: widget.folderId != null
          ? _buildDreamsList(context, theme, l10n)
          : TabBarView(
              controller: _tabController,
              children: [
                _buildDreamsList(context, theme, l10n),
                _buildFoldersList(context, theme),
              ],
            ),
      floatingActionButton: widget.folderId != null ||
              (widget.folderId == null && _tabController.index == 0)
          ? FloatingActionButton(
              onPressed: () {
                context.push('/add-dream').then((result) {
                  if (result == true) {
                    context
                        .read<DreamListBloc>()
                        .add(LoadDreams(folderId: widget.folderId));
                  }
                });
              },
              tooltip: l10n.addDreamHint,
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  Widget _buildDreamsList(
      BuildContext context, ThemeData theme, AppLocalizations l10n) {
    return BlocConsumer<DreamListBloc, DreamListState>(
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
          return RefreshIndicator(
            onRefresh: () async {
              context
                  .read<DreamListBloc>()
                  .add(LoadDreams(folderId: widget.folderId));
            },
            child: ListView(
              padding: const EdgeInsets.all(8.0),
              children: [
                // Klasör bilgisi (eğer belirli bir klasördeyse)
                if (widget.folderId != null)
                  BlocBuilder<FolderListBloc, FolderListState>(
                    builder: (context, folderState) {
                      if (folderState is FolderListLoaded) {
                        final folder = folderState.folders
                            .where((f) => f.id == widget.folderId)
                            .firstOrNull;
                        if (folder != null) {
                          return Card(
                            margin: const EdgeInsets.only(bottom: 16),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                children: [
                                  Icon(Icons.folder, color: Colors.amber[700]),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      folder.name,
                                      style:
                                          theme.textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () => context.go('/dreams'),
                                    child: const Text('Tüm Rüyalar'),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                      }
                      return const SizedBox.shrink();
                    },
                  ),



                // Rüya Listesi
                if (state.dreams.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        children: [
                          Icon(
                            Icons.nightlight_round,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            widget.folderId != null
                                ? 'Bu klasörde henüz rüya yok'
                                : l10n.noDreamsMessage,
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Rüyalarınızı kaydetmek için "+" butonuna tıklayın',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  ...state.dreams
                      .map((dream) => DreamCard(dream: dream))
                      .toList(),
              ],
            ),
          );
        }
        return Center(child: Text(l10n.errorOccurred));
      },
    );
  }

  Widget _buildFoldersList(BuildContext context, ThemeData theme) {
    return BlocConsumer<FolderListBloc, FolderListState>(
      listener: (context, state) {
        if (state is FolderListError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        if (state is FolderListLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is FolderListLoaded) {
          if (state.folders.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.folder_open,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Henüz klasör oluşturmadınız',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Rüyalarınızı organize etmek için klasör oluşturun',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[500],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () => _showAddFolderDialog(context),
                      icon: const Icon(Icons.add),
                      label: const Text('İlk Klasörü Oluştur'),
                    ),
                  ],
                ),
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () async {
              context.read<FolderListBloc>().add(LoadFolders());
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: state.folders.length,
              itemBuilder: (context, index) {
                final folder = state.folders[index];
                return FolderCard(
                  folder: folder,
                  onTap: () {
                    context.push('/dreams?folderId=${folder.id}');
                  },
                  onDelete: () => _showDeleteFolderDialog(context, folder),
                );
              },
            ),
          );
        }
        return const Center(child: Text('Bir hata oluştu'));
      },
    );
  }



  void _showAddFolderDialog(BuildContext context) {
    final controller = TextEditingController();
    final folderBloc = context.read<FolderListBloc>();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Yeni Klasör'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Klasör Adı',
            hintText: 'Klasör adını girin',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                folderBloc.add(AddFolder(controller.text.trim()));
                Navigator.of(dialogContext).pop();
              }
            },
            child: const Text('Ekle'),
          ),
        ],
      ),
    );
  }

  void _showDeleteFolderDialog(BuildContext context, folder) {
    final folderBloc = context.read<FolderListBloc>();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Klasörü Sil'),
        content: Text(
            '"${folder.name}" klasörünü silmek istediğinizden emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () {
              folderBloc.add(DeleteFolderEvent(folder.id));
              Navigator.of(dialogContext).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Sil'),
          ),
        ],
      ),
    );
  }
}
