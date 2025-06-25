import 'package:dreamscope/features/settings/presentation/pages/settings_page.dart';
import 'package:dreamscope/injection_container.dart' as di;
import 'package:dreamscope/presentation/app_blocs/locale/locale_cubit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dreamscope/presentation/app_blocs/theme/theme_cubit.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SettingsView();
  }
}

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ayarlar'),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Dil Ayarları
          _buildSectionCard(
            context,
            title: 'Dil Ayarları',
            icon: Icons.language,
            children: [
              BlocBuilder<LocaleCubit, LocaleState>(
                builder: (context, state) {
                  return _buildSettingTile(
                    context,
                    title: 'Uygulama Dili',
                    subtitle: state.locale.languageCode == 'tr'
                        ? 'Türkçe'
                        : 'English',
                    trailing: DropdownButton<Locale>(
                      value: state.locale,
                      underline: Container(),
                      items: [
                        DropdownMenuItem(
                          value: const Locale('tr'),
                          child: const Text('Türkçe'),
                        ),
                        DropdownMenuItem(
                          value: const Locale('en'),
                          child: const Text('English'),
                        ),
                      ],
                      onChanged: (locale) {
                        if (locale != null) {
                          context.read<LocaleCubit>().changeLocale(locale);
                        }
                      },
                    ),
                  );
                },
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Tema Ayarları
          _buildSectionCard(
            context,
            title: 'Görünüm Ayarları',
            icon: Icons.palette,
            children: [
              BlocListener<ThemeCubit, ThemeState>(
                listener: (context, state) {
                  // Theme state changed
                },
                child: BlocBuilder<ThemeCubit, ThemeState>(
                  builder: (context, state) {
                    return _buildSettingTile(
                      context,
                      title: 'Tema',
                      subtitle: _getThemeDisplayName(state.mode),
                      trailing: DropdownButton<AppThemeMode>(
                        value: state.mode,
                        underline: Container(),
                        items: [
                          DropdownMenuItem(
                            value: AppThemeMode.system,
                            child: const Text('Sistem'),
                          ),
                          DropdownMenuItem(
                            value: AppThemeMode.light,
                            child: const Text('Açık'),
                          ),
                          DropdownMenuItem(
                            value: AppThemeMode.dark,
                            child: const Text('Koyu'),
                          ),
                        ],
                        onChanged: (mode) {
                          if (mode != null) {
                            context.read<ThemeCubit>().setTheme(mode);
                          }
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Uygulama Bilgileri
          _buildSectionCard(
            context,
            title: 'Uygulama Bilgileri',
            icon: Icons.info,
            children: [
              _buildSettingTile(
                context,
                title: 'Versiyon',
                subtitle: '1.0.0',
                trailing: const Icon(Icons.chevron_right),
                onTap: () {},
              ),
              _buildSettingTile(
                context,
                title: 'Geliştirici',
                subtitle: 'DreamScope Team',
                trailing: const Icon(Icons.chevron_right),
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildSettingTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w500,
            ),
      ),
      subtitle: Text(
        subtitle,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
      ),
      trailing: trailing,
      onTap: onTap,
    );
  }

  String _getThemeDisplayName(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.system:
        return 'Sistem temasını kullan';
      case AppThemeMode.light:
        return 'Açık tema';
      case AppThemeMode.dark:
        return 'Koyu tema';
    }
  }
}
