import 'package:dreamscope/features/dream/domain/entities/dream.dart';
import 'package:dreamscope/features/dream/presentation/bloc/dream_list/dream_list_bloc.dart';
import 'package:dreamscope/features/dream/presentation/bloc/folder_list/folder_list_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class DreamCard extends StatelessWidget {
  final Dream dream;

  const DreamCard({super.key, required this.dream});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final formattedDate =
        DateFormat.yMMMd(l10n.localeName).add_jm().format(dream.date);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: InkWell(
        onTap: () {
          _showDreamDetail(context, dream, theme, l10n);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      dream.title,
                      style: theme.textTheme.titleLarge,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  PopupMenuButton<String>(
                    icon: Icon(Icons.more_vert, color: theme.colorScheme.primary),
                    onSelected: (value) {
                      if (value == 'move_folder') {
                        _showMoveFolderDialog(context, dream, theme, l10n);
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'move_folder',
                        child: Row(
                          children: [
                            Icon(Icons.folder_open, size: 18, color: theme.colorScheme.primary),
                            const SizedBox(width: 8),
                            const Text('Klasörü Değiştir'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                formattedDate,
                style:
                    theme.textTheme.bodySmall?.copyWith(color: Colors.white54),
              ),
              const SizedBox(height: 12),
              Text(
                dream.content,
                style: theme.textTheme.bodyMedium,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDreamDetail(BuildContext context, Dream dream, ThemeData theme,
      AppLocalizations l10n) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: theme.scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.8,
          maxChildSize: 0.95,
          minChildSize: 0.5,
          builder: (_, scrollController) {
            return Container(
              padding: const EdgeInsets.all(20),
              child: ListView(
                controller: scrollController,
                children: [
                  Text(dream.title, style: theme.textTheme.displaySmall),
                  const SizedBox(height: 16),
                  Text(
                    dream.content,
                    style: theme.textTheme.bodyLarge?.copyWith(fontSize: 16),
                  ),
                  const SizedBox(height: 24),
                  const Divider(color: Colors.white24),
                  const SizedBox(height: 16),
                  Text(
                    l10n.dreamAnalysis,
                    style: theme.textTheme.titleLarge?.copyWith(
                        color: theme.colorScheme.secondary, fontSize: 22),
                  ),
                  const SizedBox(height: 12),
                  dream.analysis != null
                      ? Text(
                          dream.analysis!,
                          style: theme.textTheme.bodyLarge
                              ?.copyWith(fontStyle: FontStyle.italic),
                        )
                      : Text(
                          "No analysis available.",
                          style: theme.textTheme.bodyMedium
                              ?.copyWith(fontStyle: FontStyle.italic),
                        ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showMoveFolderDialog(BuildContext context, Dream dream, ThemeData theme,
      AppLocalizations l10n) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: theme.scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.6,
          maxChildSize: 0.8,
          minChildSize: 0.4,
          builder: (_, scrollController) {
            return Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Klasörü Değiştir',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '"${dream.title}" rüyasını taşımak istediğiniz klasörü seçin',
                    style: theme.textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: BlocBuilder<FolderListBloc, FolderListState>(
                      builder: (context, state) {
                        if (state is FolderListLoading) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        if (state is FolderListLoaded) {
                          return ListView(
                            controller: scrollController,
                            children: [
                              // "Klasörsüz" seçeneği
                              Card(
                                child: ListTile(
                                  leading: Icon(Icons.home, color: theme.colorScheme.primary),
                                  title: const Text('Klasörsüz'),
                                  subtitle: const Text('Ana klasör'),
                                  trailing: dream.folderId == null
                                      ? Icon(Icons.check, color: theme.colorScheme.primary)
                                      : null,
                                  onTap: () {
                                    if (dream.folderId != null) {
                                      context.read<DreamListBloc>().add(
                                            MoveDreamToFolder(
                                              dreamId: dream.id,
                                              folderId: null,
                                            ),
                                          );
                                    }
                                    Navigator.of(ctx).pop();
                                  },
                                ),
                              ),
                              const SizedBox(height: 8),
                              // Mevcut klasörler
                              ...state.folders.map((folder) {
                                final isCurrentFolder = dream.folderId == folder.id;
                                return Card(
                                  child: ListTile(
                                    leading: Icon(Icons.folder, color: Colors.amber[700]),
                                    title: Text(folder.name),
                                    subtitle: Text('${folder.dreamCount} rüya'),
                                    trailing: isCurrentFolder
                                        ? Icon(Icons.check, color: theme.colorScheme.primary)
                                        : null,
                                    onTap: () {
                                      if (!isCurrentFolder) {
                                        context.read<DreamListBloc>().add(
                                              MoveDreamToFolder(
                                                dreamId: dream.id,
                                                folderId: folder.id,
                                              ),
                                            );
                                      }
                                      Navigator.of(ctx).pop();
                                    },
                                  ),
                                );
                              }).toList(),
                            ],
                          );
                        }
                        return const Center(child: Text('Klasörler yüklenemedi'));
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
