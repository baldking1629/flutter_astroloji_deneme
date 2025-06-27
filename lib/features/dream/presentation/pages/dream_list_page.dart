import 'package:dreamscope/features/dream/presentation/bloc/dream_list/dream_list_bloc.dart';
import 'package:dreamscope/features/dream/presentation/widgets/dream_card.dart';
import 'package:dreamscope/features/profile/domain/usecases/get_user_profile.dart';
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
    return BlocProvider(
      create: (context) =>
          sl<DreamListBloc>()..add(LoadDreams(folderId: folderId)),
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

class _DreamListViewState extends State<DreamListView> {
  String? _userSign;
  String? _userAscendant;
  bool _isLoadingProfile = true;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    try {
      final profile = await sl<GetUserProfile>()();
      if (profile != null) {
        setState(() {
          _userSign = profile.zodiacSign;
          _userAscendant = profile.ascendant;
        });
      }
    } catch (e) {
      // Profil yüklenirken hata oluştu
    } finally {
      setState(() {
        _isLoadingProfile = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.folderId != null ? 'Klasör Rüyaları' : l10n.dreamListTitle),
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
            return RefreshIndicator(
              onRefresh: () async {
                context
                    .read<DreamListBloc>()
                    .add(LoadDreams(folderId: widget.folderId));
              },
              child: ListView(
                padding: const EdgeInsets.all(8.0),
                children: [
                  // Kişisel Burç Yorumu Kısayolu (sadece ana sayfada ve profil varsa)
                  if (widget.folderId == null &&
                      !_isLoadingProfile &&
                      _userSign != null)
                    _buildPersonalHoroscopeCard(context, theme),
                  if (widget.folderId == null &&
                      !_isLoadingProfile &&
                      _userSign != null)
                    const SizedBox(height: 16),
                  // Rüya Listesi
                  if (state.dreams.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Text(
                          widget.folderId != null
                              ? 'Bu klasörde henüz rüya yok'
                              : l10n.noDreamsMessage,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyLarge,
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
      ),
      floatingActionButton: FloatingActionButton(
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
      ),
    );
  }

  Widget _buildPersonalHoroscopeCard(BuildContext context, ThemeData theme) {
    final signNames = {
      'aries': 'Koç',
      'taurus': 'Boğa',
      'gemini': 'İkizler',
      'cancer': 'Yengeç',
      'leo': 'Aslan',
      'virgo': 'Başak',
      'libra': 'Terazi',
      'scorpio': 'Akrep',
      'sagittarius': 'Yay',
      'capricorn': 'Oğlak',
      'aquarius': 'Kova',
      'pisces': 'Balık'
    };

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [
              theme.colorScheme.primary.withOpacity(0.1),
              theme.colorScheme.secondary.withOpacity(0.1),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.auto_awesome,
                    color: theme.colorScheme.primary,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Kişisel Burç Yorumunuz',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'Burç: ${signNames[_userSign] ?? _userSign}',
                style: theme.textTheme.bodyLarge,
              ),
              if (_userAscendant != null) ...[
                const SizedBox(height: 4),
                Text(
                  'Yükselen: ${signNames[_userAscendant] ?? _userAscendant}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ],
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        context.push('/horoscope');
                      },
                      icon: const Icon(Icons.psychology),
                      label: const Text('Günlük Yorum'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: theme.colorScheme.onPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        context.push('/profile');
                      },
                      icon: const Icon(Icons.person),
                      label: const Text('Profil'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
