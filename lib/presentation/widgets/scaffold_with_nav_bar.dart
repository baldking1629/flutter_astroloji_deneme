import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ScaffoldWithNavBar extends StatelessWidget {
  final Widget child;
  const ScaffoldWithNavBar({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    final theme = Theme.of(context);

    int currentIndex = 0;
    if (location.startsWith('/horoscope')) {
      currentIndex = 1;
    } else if (location.startsWith('/settings')) {
      currentIndex = 2;
    }

    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        backgroundColor: theme.bottomNavigationBarTheme.backgroundColor,
        selectedItemColor: theme.bottomNavigationBarTheme.selectedItemColor,
        unselectedItemColor: theme.bottomNavigationBarTheme.unselectedItemColor,
        onTap: (index) {
          switch (index) {
            case 0:
              context.go('/dreams');
              break;
            case 1:
              context.go('/horoscope');
              break;
            case 2:
              context.go('/settings');
              break;
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.nightlight_round),
            label: AppLocalizations.of(context)!.dreamsTab,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.star_border_purple500_outlined),
            label: AppLocalizations.of(context)!.horoscopeTab,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings),
            label: AppLocalizations.of(context)!.settingsTab,
          ),
        ],
      ),
    );
  }
}
