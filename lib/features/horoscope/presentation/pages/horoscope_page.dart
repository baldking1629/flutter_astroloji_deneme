import 'package:dreamscope/features/horoscope/presentation/cubit/horoscope_cubit.dart';
import 'package:dreamscope/features/horoscope/presentation/cubit/saved_horoscope_cubit.dart';
import 'package:dreamscope/features/horoscope/data/services/ascendant_calculator_service.dart';
import 'package:dreamscope/features/profile/domain/usecases/get_user_profile.dart';
import 'package:dreamscope/injection_container.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dreamscope/features/dream/presentation/widgets/folder_selector.dart';
import 'package:dreamscope/features/horoscope/domain/entities/saved_horoscope.dart';
import 'package:dreamscope/features/horoscope/domain/usecases/save_horoscope.dart';
import 'package:uuid/uuid.dart';
import 'package:dreamscope/features/dream/presentation/bloc/folder_list/folder_list_bloc.dart';
import 'package:go_router/go_router.dart';

class HoroscopePage extends StatelessWidget {
  const HoroscopePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<HoroscopeCubit>()),
        BlocProvider(
            create: (_) => sl<SavedHoroscopeCubit>()..loadSavedHoroscopes()),
        BlocProvider(create: (_) => sl<FolderListBloc>()..add(LoadFolders())),
      ],
      child: const HoroscopeView(),
    );
  }
}

class HoroscopeView extends StatefulWidget {
  const HoroscopeView({super.key});

  @override
  State<HoroscopeView> createState() => _HoroscopeViewState();
}

class _HoroscopeViewState extends State<HoroscopeView>
    with SingleTickerProviderStateMixin {
  String? _selectedSign;
  String? _selectedAscendant;
  String? _selectedPeriod;
  String? _selectedFolderId;
  String? _selectedFolderName;
  bool _isSaving = false;
  bool _useCalculatedAscendant = false;
  String? _calculatedAscendant;
  late TabController _tabController;
  String? _filterFolderId;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadUserProfile();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadUserProfile() async {
    try {
      final profile = await sl<GetUserProfile>()();
      if (profile != null) {
        setState(() {
          _selectedSign = profile.zodiacSign;

          // Eğer profilde yükselen burç yoksa otomatik hesapla
          if (profile.ascendant != null && profile.ascendant!.isNotEmpty) {
            _selectedAscendant = profile.ascendant;
          } else {
            // Yükselen burcu hesapla
            _calculateAscendant(profile);
          }
        });
      }
    } catch (e) {
      // Profil yüklenirken hata oluştu
    }
  }

  void _calculateAscendant(profile) {
    if (profile.birthTime.isNotEmpty) {
      final calculatedAscendant = AscendantCalculatorService.calculateAscendant(
        sunSign: profile.zodiacSign,
        birthTime: profile.birthTime,
        birthDate: profile.birthDate,
      );

      if (calculatedAscendant != null) {
        setState(() {
          _calculatedAscendant = calculatedAscendant;
          _selectedAscendant = calculatedAscendant;
          _useCalculatedAscendant = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.horoscopeTitle),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Yeni Yorum', icon: Icon(Icons.psychology)),
            Tab(text: 'Kaydedilenler', icon: Icon(Icons.bookmark)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildNewHoroscopeTab(context, l10n, theme),
          _buildSavedHoroscopesTab(context, theme),
        ],
      ),
    );
  }

  Widget _buildNewHoroscopeTab(
      BuildContext context, AppLocalizations l10n, ThemeData theme) {
    final signKeys = [
      'aries',
      'taurus',
      'gemini',
      'cancer',
      'leo',
      'virgo',
      'libra',
      'scorpio',
      'sagittarius',
      'capricorn',
      'aquarius',
      'pisces'
    ];
    final signs = signKeys.map((key) => l10n.getString(key)).toList();
    final periods = {
      l10n.daily: 'daily',
      l10n.weekly: 'weekly',
      l10n.monthly: 'monthly',
    };

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Burç Bilgileriniz',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _selectedSign,
                    hint: Text(l10n.selectHoroscopeSign),
                    items: List.generate(signKeys.length, (i) {
                      return DropdownMenuItem(
                        value: signKeys[i],
                        child: Text(signs[i]),
                      );
                    }),
                    onChanged: (value) => setState(() => _selectedSign = value),
                    isExpanded: true,
                  ),
                  const SizedBox(height: 16),

                  // Yükselen burç seçimi/hesaplama
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _selectedAscendant,
                          hint: const Text('Yükselen Burç'),
                          items: [
                            const DropdownMenuItem<String>(
                              value: null,
                              child: Text('Yükselen Burç Yok'),
                            ),
                            ...List.generate(signKeys.length, (i) {
                              return DropdownMenuItem(
                                value: signKeys[i],
                                child: Text(signs[i]),
                              );
                            }),
                          ],
                          onChanged: (value) =>
                              setState(() => _selectedAscendant = value),
                          isExpanded: true,
                        ),
                      ),
                      if (_calculatedAscendant != null) ...[
                        const SizedBox(width: 8),
                        IconButton(
                          onPressed: () => _showAscendantInfo(context),
                          icon: Icon(
                            Icons.info_outline,
                            color: theme.colorScheme.primary,
                          ),
                          tooltip: 'Hesaplanan Yükselen Burç',
                        ),
                      ],
                    ],
                  ),

                  if (_calculatedAscendant != null) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color:
                            theme.colorScheme.primaryContainer.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: theme.colorScheme.primary.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.calculate,
                            size: 16,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Hesaplanan Yükselen: ${AscendantCalculatorService.getSignNameInTurkish(_calculatedAscendant!)}',
                              style: TextStyle(
                                fontSize: 12,
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _selectedPeriod,
                    hint: Text(l10n.selectHoroscopePeriod),
                    items: periods.keys.map((period) {
                      return DropdownMenuItem(
                          value: periods[period], child: Text(period));
                    }).toList(),
                    onChanged: (value) =>
                        setState(() => _selectedPeriod = value),
                    isExpanded: true,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed:
                          (_selectedSign != null && _selectedPeriod != null)
                              ? () {
                                  context.read<HoroscopeCubit>().fetchHoroscope(
                                        sign: _selectedSign!,
                                        ascendant: _selectedAscendant,
                                        period: _selectedPeriod!,
                                        languageCode: l10n.localeName,
                                        date: DateTime.now(),
                                      );
                                }
                              : null,
                      child: Text(l10n.getHoroscopeButton),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          BlocBuilder<HoroscopeCubit, HoroscopeState>(
            builder: (context, state) {
              if (state is HoroscopeLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is HoroscopeLoaded) {
                return Column(
                  children: [
                    Card(
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
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    l10n.horoscopeFor(
                                        l10n.getString(state.horoscope.sign)),
                                    style: theme.textTheme.titleLarge,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              state.horoscope.prediction,
                              style: theme.textTheme.bodyLarge,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    BlocBuilder<FolderListBloc, FolderListState>(
                      builder: (context, folderState) {
                        return FolderSelector(
                          selectedFolderId: _selectedFolderId,
                          onFolderSelected: (folderId) {
                            setState(() {
                              _selectedFolderId = folderId;
                              if (folderState is FolderListLoaded &&
                                  folderId != null) {
                                final folder = folderState.folders
                                    .where(
                                      (f) => f.id == folderId,
                                    )
                                    .toList();
                                _selectedFolderName = folder.isNotEmpty
                                    ? folder.first.name
                                    : null;
                              } else {
                                _selectedFolderName = null;
                              }
                            });
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.save),
                        label: _isSaving
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Text('Yorumu Kaydet'),
                        onPressed: _isSaving
                            ? null
                            : () async {
                                setState(() => _isSaving = true);
                                final savedHoroscope = SavedHoroscope(
                                  id: const Uuid().v4(),
                                  zodiacSign: state.horoscope.sign,
                                  period: state.horoscope.period,
                                  content: state.horoscope.prediction,
                                  createdAt: DateTime.now(),
                                  folderId: _selectedFolderId,
                                  folderName: _selectedFolderName,
                                );
                                try {
                                  await sl<SaveHoroscope>()(savedHoroscope);
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text('Yorum kaydedildi!')),
                                    );
                                    // Refresh saved horoscopes in the other tab
                                    context
                                        .read<SavedHoroscopeCubit>()
                                        .loadSavedHoroscopes();
                                  }
                                } catch (e) {
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text('Kaydetme hatası: $e')),
                                    );
                                  }
                                } finally {
                                  if (mounted)
                                    setState(() => _isSaving = false);
                                }
                              },
                      ),
                    ),
                  ],
                );
              }
              if (state is HoroscopeError) {
                return Center(
                  child: Column(
                    children: [
                      Text(l10n.errorOccurred,
                          style: TextStyle(color: theme.colorScheme.error)),
                      const SizedBox(height: 8),
                      Text(
                        state.message,
                        style: TextStyle(
                          color: theme.colorScheme.error,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          if (_selectedSign != null &&
                              _selectedPeriod != null) {
                            context.read<HoroscopeCubit>().fetchHoroscope(
                                  sign: _selectedSign!,
                                  ascendant: _selectedAscendant,
                                  period: _selectedPeriod!,
                                  languageCode: l10n.localeName,
                                  date: DateTime.now(),
                                );
                          }
                        },
                        child: Text(l10n.tryAgain),
                      )
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSavedHoroscopesTab(BuildContext context, ThemeData theme) {
    return Column(
      children: [
        // Filter bar
        BlocBuilder<FolderListBloc, FolderListState>(
          builder: (context, folderState) {
            if (folderState is FolderListLoaded &&
                folderState.folders.isNotEmpty) {
              return Container(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Icon(Icons.filter_list, color: theme.colorScheme.primary),
                    const SizedBox(width: 8),
                    Expanded(
                      child: DropdownButtonFormField<String?>(
                        value: _filterFolderId,
                        hint: const Text('Tüm Klasörler'),
                        items: [
                          const DropdownMenuItem<String?>(
                            value: null,
                            child: Text('Tüm Klasörler'),
                          ),
                          ...folderState.folders
                              .map((folder) => DropdownMenuItem<String>(
                                    value: folder.id,
                                    child: Text(folder.name),
                                  )),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _filterFolderId = value;
                          });
                        },
                        decoration: const InputDecoration(
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),

        // Horoscopes list
        Expanded(
          child: BlocBuilder<SavedHoroscopeCubit, SavedHoroscopeState>(
            builder: (context, state) {
              if (state is SavedHoroscopeLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is SavedHoroscopeLoaded) {
                // Filter horoscopes by folder
                final filteredHoroscopes = _filterFolderId == null
                    ? state.horoscopes
                    : state.horoscopes
                        .where((h) => h.folderId == _filterFolderId)
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
                          _filterFolderId == null
                              ? 'Henüz kaydedilmiş burç yorumu yok.'
                              : 'Bu klasörde burç yorumu bulunamadı.',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'İlk sekmeye geçerek yorum oluşturup kaydedebilirsiniz.',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[500],
                          ),
                          textAlign: TextAlign.center,
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
                          onTap: () =>
                              context.push('/horoscope-detail/${h.id}'),
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
                          context
                              .read<SavedHoroscopeCubit>()
                              .loadSavedHoroscopes();
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

  void _showAscendantInfo(BuildContext context) {
    if (_calculatedAscendant == null) return;

    final theme = Theme.of(context);
    final signName =
        AscendantCalculatorService.getSignNameInTurkish(_calculatedAscendant!);
    final description = AscendantCalculatorService.getAscendantDescription(
        _calculatedAscendant!);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.calculate, color: theme.colorScheme.primary),
            const SizedBox(width: 8),
            Text('Yükselen Burç: $signName'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              description,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Not:',
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Bu hesaplama yaklaşık bir değerdir. Kesin yükselen burç hesaplama için doğum yeri koordinatları ve tam doğum saati gereklidir.',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tamam'),
          ),
        ],
      ),
    );
  }
}

extension HoroscopeL10nExtension on AppLocalizations {
  String getString(String key) {
    switch (key) {
      case 'aries':
        return this.aries;
      case 'taurus':
        return this.taurus;
      case 'gemini':
        return this.gemini;
      case 'cancer':
        return this.cancer;
      case 'leo':
        return this.leo;
      case 'virgo':
        return this.virgo;
      case 'libra':
        return this.libra;
      case 'scorpio':
        return this.scorpio;
      case 'sagittarius':
        return this.sagittarius;
      case 'capricorn':
        return this.capricorn;
      case 'aquarius':
        return this.aquarius;
      case 'pisces':
        return this.pisces;
      default:
        return key;
    }
  }
}
