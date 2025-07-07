import 'package:dreamscope/features/horoscope/presentation/cubit/horoscope_cubit.dart';
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

class HoroscopePage extends StatelessWidget {
  const HoroscopePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<HoroscopeCubit>(),
      child: const HoroscopeView(),
    );
  }
}

class HoroscopeView extends StatefulWidget {
  const HoroscopeView({super.key});

  @override
  State<HoroscopeView> createState() => _HoroscopeViewState();
}

class _HoroscopeViewState extends State<HoroscopeView> {
  String? _selectedSign;
  String? _selectedAscendant;
  String? _selectedPeriod;
  String? _selectedFolderId;
  String? _selectedFolderName;
  bool _isSaving = false;
  bool _useCalculatedAscendant = false;
  String? _calculatedAscendant;

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

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.horoscopeTitle),
      ),
      body: SingleChildScrollView(
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
                      onChanged: (value) =>
                          setState(() => _selectedSign = value),
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
                          color: theme.colorScheme.primaryContainer.withOpacity(0.3),
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
                        bloc: sl<FolderListBloc>()..add(LoadFolders()),
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
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text('Yorum kaydedildi!')),
                                      );
                                    }
                                  } catch (e) {
                                    if (mounted) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content:
                                                Text('Kaydetme hatası: $e')),
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
      ),
    );
  }

  void _showAscendantInfo(BuildContext context) {
    if (_calculatedAscendant == null) return;
    
    final theme = Theme.of(context);
    final signName = AscendantCalculatorService.getSignNameInTurkish(_calculatedAscendant!);
    final description = AscendantCalculatorService.getAscendantDescription(_calculatedAscendant!);
    
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
