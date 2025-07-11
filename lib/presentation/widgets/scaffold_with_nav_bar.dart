import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:ui';

class ScaffoldWithNavBar extends StatelessWidget {
  final Widget child;
  const ScaffoldWithNavBar({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    // Ekran boyutuna göre bottom navigation bar yüksekliğini ayarla
    final navBarHeight =
        screenHeight < 700 ? 60.0 : 65.0; // Yükseklik artırıldı

    return Scaffold(
      body: child,
      bottomNavigationBar: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.surface.withOpacity(0.85),
                Theme.of(context).colorScheme.surface.withOpacity(0.95),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 30,
                offset: const Offset(0, -8),
                spreadRadius: 0,
              ),
            ],
            border: Border(
              top: BorderSide(
                color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
                width: 0.5,
              ),
            ),
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(0)),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: Container(
                height: navBarHeight + bottomPadding + 8, // Yükseklik artırıldı
                padding: EdgeInsets.only(
                  left: 8,
                  right: 8,
                  top: 6, // Üst padding azaltıldı
                  bottom: 8 + bottomPadding, // Alt padding azaltıldı
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildNavItem(
                      context,
                      icon: Icons.home_rounded,
                      label: 'Anasayfa',
                      index: 0,
                      route: '/home',
                    ),
                    _buildNavItem(
                      context,
                      icon: Icons.nightlight_round,
                      label: 'Rüyalar',
                      index: 1,
                      route: '/dreams',
                    ),
                    _buildNavItem(
                      context,
                      icon: Icons.auto_awesome,
                      label: 'Burç',
                      index: 2,
                      route: '/horoscope',
                    ),
                    _buildNavItem(
                      context,
                      icon: Icons.settings_rounded,
                      label: 'Ayarlar',
                      index: 3,
                      route: '/settings',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required int index,
    required String route,
  }) {
    final theme = Theme.of(context);
    final isSelected = _calculateSelectedIndex(context) == index;
    final screenHeight = MediaQuery.of(context).size.height;

    // Ekran boyutuna göre icon ve text boyutlarını ayarla
    final iconSize = screenHeight < 700
        ? (isSelected ? 16.0 : 14.0) // Icon boyutları küçültüldü
        : (isSelected ? 18.0 : 16.0);
    final fontSize = screenHeight < 700
        ? (isSelected ? 8.0 : 7.0) // Font boyutları küçültüldü
        : (isSelected ? 9.0 : 8.0);

    return Expanded(
      child: GestureDetector(
        onTap: () => context.go(route),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          padding: EdgeInsets.symmetric(
            horizontal: screenHeight < 700 ? 2 : 4, // Padding azaltıldı
            vertical: screenHeight < 700 ? 2 : 4, // Padding azaltıldı
          ),
          margin: EdgeInsets.symmetric(horizontal: screenHeight < 700 ? 1 : 2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: isSelected
                ? theme.colorScheme.primaryContainer.withOpacity(0.15)
                : Colors.transparent,
            border: isSelected
                ? Border.all(
                    color: theme.colorScheme.primary.withOpacity(0.2),
                    width: 1,
                  )
                : null,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                padding: EdgeInsets.all(isSelected
                    ? (screenHeight < 700 ? 2 : 3) // Padding azaltıldı
                    : (screenHeight < 700 ? 1 : 2)),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected
                      ? theme.colorScheme.primary.withOpacity(0.1)
                      : Colors.transparent,
                ),
                child: Icon(
                  icon,
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurface.withOpacity(0.7),
                  size: iconSize,
                ),
              ),
              SizedBox(height: screenHeight < 700 ? 0.5 : 1),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 300),
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurface.withOpacity(0.7),
                ),
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    if (location.startsWith('/home')) {
      return 0;
    } else if (location.startsWith('/dreams')) {
      return 1;
    } else if (location.startsWith('/horoscope')) {
      return 2;
    } else if (location.startsWith('/settings')) {
      return 3;
    }
    return 0;
  }
}
