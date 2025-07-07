import 'package:dreamscope/features/horoscope/presentation/cubit/saved_horoscope_cubit.dart';
import 'package:dreamscope/features/dream/presentation/bloc/folder_list/folder_list_bloc.dart';
import 'package:dreamscope/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SavedHoroscopeListPage extends StatelessWidget {
  final String? folderId;
  
  const SavedHoroscopeListPage({super.key, this.folderId});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => sl<SavedHoroscopeCubit>()..loadSavedHoroscopes(),
        ),
        BlocProvider(
          create: (_) => sl<FolderListBloc>()..add(LoadFolders()),
        ),
      ],
      child: SavedHoroscopeListView(folderId: folderId),
    );
  }
}

class SavedHoroscopeListView extends StatefulWidget {
  final String? folderId;
  
  const SavedHoroscopeListView({super.key, this.folderId});

  @override
  State<SavedHoroscopeListView> createState() => _SavedHoroscopeListViewState();
}

class _SavedHoroscopeListViewState extends State<SavedHoroscopeListView> {
  String? _selectedFolderId;

  @override
  void initState() {
    super.initState();
    _selectedFolderId = widget.folderId;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kaydedilen Burç Yorumları'),
        actions: [
          BlocBuilder<FolderListBloc, FolderListState>(
            builder: (context, folderState) {
              if (folderState is FolderListLoaded) {
                return PopupMenuButton<String?>(
                  icon: const Icon(Icons.filter_list),
                  onSelected: (folderId) {
                    setState(() {
                      _selectedFolderId = folderId;
                    });
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem<String?>(
                      value: null,
                      child: Row(
                        children: [
                          Icon(Icons.all_inclusive),
                          SizedBox(width: 8),
                          Text('Tüm Yorumlar'),
                        ],
                      ),
                    ),
                    ...folderState.folders.map((folder) => PopupMenuItem<String>(
                      value: folder.id,
                      child: Row(
                        children: [
                          Icon(Icons.folder, color: Colors.amber[700]),
                          const SizedBox(width: 8),
                          Text(folder.name),
                        ],
                      ),
                    )),
                  ],
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Klasör bilgisi
          if (_selectedFolderId != null)
            BlocBuilder<FolderListBloc, FolderListState>(
              builder: (context, state) {
                if (state is FolderListLoaded) {
                  final folder = state.folders
                      .where((f) => f.id == _selectedFolderId)
                      .firstOrNull;
                  if (folder != null) {
                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.amber[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.amber[200]!),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.folder, color: Colors.amber[700]),
                          const SizedBox(width: 8),
                          Text(
                            'Klasör: ${folder.name}',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedFolderId = null;
                              });
                            },
                            child: Icon(Icons.close, color: Colors.amber[700]),
                          ),
                        ],
                      ),
                    );
                  }
                }
                return const SizedBox.shrink();
              },
            ),
          
          // Yorumlar listesi
          Expanded(
            child: BlocBuilder<SavedHoroscopeCubit, SavedHoroscopeState>(
              builder: (context, state) {
                if (state is SavedHoroscopeLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is SavedHoroscopeLoaded) {
                  // Klasör filtrelemesi
                  final filteredHoroscopes = _selectedFolderId == null
                      ? state.horoscopes
                      : state.horoscopes
                          .where((h) => h.folderId == _selectedFolderId)
                          .toList();
                  
                  if (filteredHoroscopes.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.auto_awesome,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _selectedFolderId == null
                                ? 'Henüz kaydedilmiş burç yorumu yok.'
                                : 'Bu klasörde burç yorumu bulunamadı.',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Burç sayfasından yorum oluşturup kaydedebilirsiniz.',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[500],
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: () => context.go('/horoscope'),
                            icon: const Icon(Icons.auto_awesome),
                            label: const Text('Burç Yorumu Oluştur'),
                          ),
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
                      itemCount: filteredHoroscopes.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final h = filteredHoroscopes[index];
                        return Card(
                          child: ListTile(
                            leading: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primaryContainer,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.auto_awesome,
                                color: theme.colorScheme.onPrimaryContainer,
                              ),
                            ),
                            title: Text(
                              '${h.zodiacSign.toUpperCase()} - ${_getPeriodText(h.period)}',
                              style: const TextStyle(fontWeight: FontWeight.w600),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 4),
                                Text(
                                  h.content,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_today,
                                      size: 12,
                                      color: Colors.grey[600],
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      _formatDate(h.createdAt),
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    if (h.folderName != null) ...[
                                      const SizedBox(width: 12),
                                      Icon(
                                        Icons.folder,
                                        size: 12,
                                        color: Colors.amber[700],
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        h.folderName!,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ],
                            ),
                            trailing: PopupMenuButton<String>(
                              onSelected: (value) async {
                                switch (value) {
                                  case 'view':
                                    context.push('/horoscope-detail/${h.id}');
                                    break;
                                  case 'delete':
                                    _showDeleteDialog(context, h);
                                    break;
                                }
                              },
                              itemBuilder: (context) => [
                                const PopupMenuItem(
                                  value: 'view',
                                  child: Row(
                                    children: [
                                      Icon(Icons.visibility),
                                      SizedBox(width: 8),
                                      Text('Detayını Gör'),
                                    ],
                                  ),
                                ),
                                const PopupMenuItem(
                                  value: 'delete',
                                  child: Row(
                                    children: [
                                      Icon(Icons.delete, color: Colors.red),
                                      SizedBox(width: 8),
                                      Text('Sil'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            onTap: () => context.push('/horoscope-detail/${h.id}'),
                          ),
                        );
                      },
                    ),
                  );
                }
                if (state is SavedHoroscopeError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: theme.colorScheme.error,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Hata: ${state.message}',
                          style: TextStyle(color: theme.colorScheme.error),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            context.read<SavedHoroscopeCubit>().loadSavedHoroscopes();
                          },
                          child: const Text('Tekrar Dene'),
                        ),
                      ],
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  String _getPeriodText(String period) {
    switch (period) {
      case 'daily':
        return 'Günlük';
      case 'weekly':
        return 'Haftalık';
      case 'monthly':
        return 'Aylık';
      default:
        return period;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.'
           '${date.month.toString().padLeft(2, '0')}.'
           '${date.year}';
  }

  void _showDeleteDialog(BuildContext context, horoscope) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Yorumu Sil'),
        content: Text(
          '${horoscope.zodiacSign.toUpperCase()} burcu yorumunu silmek istediğinize emin misiniz?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<SavedHoroscopeCubit>().deleteHoroscope(horoscope.id);
              Navigator.pop(dialogContext);
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
