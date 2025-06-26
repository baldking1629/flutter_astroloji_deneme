import 'package:dreamscope/features/horoscope/presentation/cubit/horoscope_cubit.dart';
import 'package:dreamscope/injection_container.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  String? _selectedPeriod;

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
                  children: [
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
                    ElevatedButton(
                      onPressed:
                          (_selectedSign != null && _selectedPeriod != null)
                              ? () {
                                  context.read<HoroscopeCubit>().fetchHoroscope(
                                        sign: _selectedSign!,
                                        period: _selectedPeriod!,
                                        languageCode: l10n.localeName,
                                        date: DateTime.now(),
                                      );
                                }
                              : null,
                      child: Text(l10n.getHoroscopeButton),
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
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.horoscopeFor(
                                l10n.getString(state.horoscope.sign)),
                            style: theme.textTheme.titleLarge,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            state.horoscope.prediction,
                            style: theme.textTheme.bodyLarge,
                          ),
                        ],
                      ),
                    ),
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
