import 'package:dreamscope/features/dream/presentation/pages/add_dream_page.dart';
import 'package:dreamscope/features/dream/presentation/pages/dream_list_page.dart';
import 'package:dreamscope/features/horoscope/presentation/pages/horoscope_page.dart';
import 'package:dreamscope/features/settings/presentation/pages/settings_page.dart';
import 'package:dreamscope/presentation/widgets/scaffold_with_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    initialLocation: '/dreams',
    navigatorKey: _rootNavigatorKey,
    routes: [
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return ScaffoldWithNavBar(child: child);
        },
        routes: [
          GoRoute(
            path: '/dreams',
            pageBuilder:
                (context, state) =>
                    const NoTransitionPage(child: DreamListPage()),
          ),
          GoRoute(
            path: '/horoscope',
            pageBuilder:
                (context, state) =>
                    const NoTransitionPage(child: HoroscopePage()),
          ),
          GoRoute(
            path: '/settings',
            pageBuilder:
                (context, state) =>
                    const NoTransitionPage(child: SettingsPage()),
          ),
        ],
      ),
      GoRoute(
        path: '/add-dream',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const AddDreamPage(),
      ),
    ],
  );
}
