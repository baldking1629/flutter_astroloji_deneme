import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:dreamscope/presentation/app_blocs/locale/locale_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settingsTitle),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Text(
            l10n.languageSettings,
            style: theme.textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          BlocBuilder<LocaleCubit, LocaleState>(
            builder: (context, state) {
              return Card(
                child: Column(
                  children: [
                    RadioListTile<Locale>(
                      title: const Text('English'),
                      value: const Locale('en'),
                      groupValue: state.locale,
                      onChanged: (locale) {
                        if (locale != null) {
                          context.read<LocaleCubit>().changeLocale(locale);
                        }
                      },
                      activeColor: theme.colorScheme.secondary,
                    ),
                    RadioListTile<Locale>(
                      title: const Text('Türkçe'),
                      value: const Locale('tr'),
                      groupValue: state.locale,
                      onChanged: (locale) {
                        if (locale != null) {
                          context.read<LocaleCubit>().changeLocale(locale);
                        }
                      },
                      activeColor: theme.colorScheme.secondary,
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
