import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:ui';

class ScaffoldWithNavBar extends StatelessWidget {
  final Widget child;
  const ScaffoldWithNavBar({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
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
            child: SafeArea(
              child: Container(
                height: 65,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
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
    
    return Expanded(
      child: GestureDetector(
        onTap: () => context.go(route),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
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
                padding: EdgeInsets.all(isSelected ? 6 : 4),
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
                  size: isSelected ? 22 : 20,
                ),
              ),
              const SizedBox(height: 2),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 300),
                style: TextStyle(
                  fontSize: isSelected ? 11 : 10,
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
