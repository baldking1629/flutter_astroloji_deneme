import 'package:dreamscope/features/dream/presentation/pages/add_dream_page.dart';
import 'package:dreamscope/features/dream/presentation/pages/dream_list_page.dart';
import 'package:dreamscope/features/horoscope/presentation/pages/horoscope_page.dart';
import 'package:dreamscope/features/horoscope/presentation/pages/saved_horoscope_list_page.dart';
import 'package:dreamscope/features/horoscope/presentation/pages/horoscope_detail_page.dart';
import 'package:dreamscope/features/settings/presentation/pages/settings_page.dart';
import 'package:dreamscope/features/profile/presentation/pages/profile_page.dart';
import 'package:dreamscope/presentation/widgets/scaffold_with_nav_bar.dart';
import 'package:dreamscope/presentation/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    initialLocation: '/home',
    navigatorKey: _rootNavigatorKey,
    routes: [
      GoRoute(
        path: '/home',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const ScaffoldWithNavBar(child: HomePage()),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
      ),
      GoRoute(
        path: '/dreams',
        pageBuilder: (context, state) {
          final folderId = state.uri.queryParameters['folderId'];
          return CustomTransitionPage(
            key: state.pageKey,
            child: ScaffoldWithNavBar(child: DreamListPage(folderId: folderId)),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
          );
        },
      ),
      GoRoute(
        path: '/horoscope',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const ScaffoldWithNavBar(child: HoroscopePage()),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
      ),
      GoRoute(
        path: '/saved-horoscopes',
        pageBuilder: (context, state) {
          final folderId = state.uri.queryParameters['folderId'];
          return CustomTransitionPage(
            key: state.pageKey,
            child: ScaffoldWithNavBar(child: SavedHoroscopeListPage(folderId: folderId)),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
          );
        },
      ),
      GoRoute(
        path: '/horoscope-detail/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return HoroscopeDetailPage(horoscopeId: id);
        },
      ),
      GoRoute(
        path: '/settings',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const ScaffoldWithNavBar(child: SettingsPage()),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
      ),
      GoRoute(
        path: '/add-dream',
        builder: (context, state) => const AddDreamPage(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfilePage(),
      ),
    ],
  );
}
