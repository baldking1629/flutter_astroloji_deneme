import 'package:dreamscope/features/dream/presentation/pages/add_dream_page.dart';
import 'package:dreamscope/features/dream/presentation/pages/dream_list_page.dart';
import 'package:dreamscope/features/horoscope/presentation/pages/horoscope_page.dart';
import 'package:dreamscope/features/settings/presentation/pages/settings_page.dart';
import 'package:dreamscope/presentation/widgets/scaffold_with_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    initialLocation: '/dreams',
    navigatorKey: _rootNavigatorKey,
    routes: [
      GoRoute(
        path: '/dreams',
        builder: (context, state) => const ScaffoldWithNavBar(
          child: DreamListPage(),
        ),
      ),
      GoRoute(
        path: '/horoscope',
        builder: (context, state) => const ScaffoldWithNavBar(
          child: HoroscopePage(),
        ),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const ScaffoldWithNavBar(
          child: SettingsPage(),
        ),
      ),
      GoRoute(
        path: '/add-dream',
        builder: (context, state) => const AddDreamPage(),
      ),
    ],
  );
}
