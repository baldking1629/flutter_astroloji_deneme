import 'package:dreamscope/features/dream/presentation/bloc/folder_list/folder_list_bloc.dart';
import 'package:dreamscope/features/dream/presentation/widgets/folder_card.dart';
import 'package:dreamscope/features/horoscope/presentation/cubit/saved_horoscope_cubit.dart';
import 'package:dreamscope/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class FolderListPage extends StatelessWidget {
  const FolderListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<FolderListBloc>()..add(LoadFolders()),
        ),
        BlocProvider(
          create: (context) => sl<SavedHoroscopeCubit>()..loadSavedHoroscopes(),
        ),
      ],
      child: const FolderListView(),
    );
  }
}

class FolderListView extends StatefulWidget {
  const FolderListView({super.key});

  @override
  State<FolderListView> createState() => _FolderListViewState();
}

class _FolderListViewState extends State<FolderListView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Klasörler ve Yorumlar'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Klasörler'),
            Tab(text: 'Kaydedilen Yorumlar'),
          ],
        ),
        actions: [
          if (_tabController.index == 0)
            IconButton(
              onPressed: () => _showAddFolderDialog(context),
              icon: const Icon(Icons.add),
              tooltip: 'Yeni Klasör Ekle',
            ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildFoldersTab(),
          _buildSavedHoroscopesTab(),
        ],
      ),
    );
  }

  Widget _buildFoldersTab() {
    final theme = Theme.of(context);

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

  Widget _buildSavedHoroscopesTab() {
    return BlocBuilder<SavedHoroscopeCubit, SavedHoroscopeState>(
      builder: (context, state) {
        if (state is SavedHoroscopeLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is SavedHoroscopeLoaded) {
          if (state.horoscopes.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.auto_awesome, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('Henüz kaydedilmiş burç yorumu yok.'),
                ],
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () async {
              context.read<SavedHoroscopeCubit>().loadSavedHoroscopes();
            },
            child: ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: state.horoscopes.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final h = state.horoscopes[index];
                return Card(
                  child: ListTile(
                    title: Text('${h.zodiacSign.toUpperCase()} - ${h.period}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(h.content,
                            maxLines: 3, overflow: TextOverflow.ellipsis),
                        if (h.folderName != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            'Klasör: ${h.folderName}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('Yorumu Sil'),
                            content: const Text(
                                'Bu yorumu silmek istediğinize emin misiniz?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(ctx, false),
                                child: const Text('İptal'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(ctx, true),
                                child: const Text('Sil'),
                              ),
                            ],
                          ),
                        );
                        if (confirm == true) {
                          context
                              .read<SavedHoroscopeCubit>()
                              .deleteHoroscope(h.id);
                        }
                      },
                    ),
                  ),
                );
              },
            ),
          );
        }
        if (state is SavedHoroscopeError) {
          return Center(child: Text('Hata: ${state.message}'));
        }
        return const SizedBox.shrink();
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
