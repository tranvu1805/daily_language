import 'dart:async';

import 'package:daily_language/core/di/service_locator.dart';
import 'package:daily_language/core/route/app_shell.dart';
import 'package:daily_language/core/route/routes.dart';
import 'package:daily_language/features/account/presentation/presentation.dart';
import 'package:daily_language/features/authentication/presentation/presentation.dart';
import 'package:daily_language/features/home/presentation/pages/home_page.dart';
import 'package:daily_language/features/record/presentation/bloc/record_bloc/record_bloc.dart';
import 'package:daily_language/features/record/presentation/bloc/records_bloc/records_bloc.dart';
import 'package:daily_language/features/record/presentation/pages/record_add_page.dart';
import 'package:daily_language/features/record/presentation/pages/record_page.dart';
import 'package:daily_language/features/word/presentation/bloc/word_bloc/word_bloc.dart';
import 'package:daily_language/features/word/presentation/bloc/words_bloc/words_bloc.dart';
import 'package:daily_language/features/word/presentation/pages/word_add_page.dart';
import 'package:daily_language/features/word/presentation/pages/word_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'root',
);

GoRouter router(GoRouterRefreshStream goRouterRefreshStream) {
  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: Routes.splash,
    redirect: (context, state) {
      final authState = context.read<AuthenticationBloc>().state;
      final isSplash = state.matchedLocation == Routes.splash;
      if (authState is! AuthenticationSuccess && !isSplash) {
        return Routes.splash;
      }
      if (isSplash && authState is AuthenticationSuccess) {
        return Routes.home;
      }
      return null;
    },
    refreshListenable: goRouterRefreshStream,
    routes: [
      GoRoute(
        path: Routes.splash,
        builder: (context, state) => const SplashPage(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, shellRoutes) => MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => sl<RecordBloc>()),
            BlocProvider(create: (context) => sl<RecordsBloc>()),
            BlocProvider(create: (context) => sl<WordBloc>()),
            BlocProvider(create: (context) => sl<WordsBloc>()),
          ],
          child: AppPage(navigationShell: shellRoutes),
        ),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.home,
                builder: (context, state) => const HomePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.diary,
                builder: (context, state) => const RecordPage(),
                routes: [
                  GoRoute(
                    path: Routes.diaryAdd,
                    builder: (context, state) => const RecordAddPage(),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.words,
                builder: (context, state) => const WordPage(),
                routes: [
                  GoRoute(
                    path: Routes.wordsAdd,
                    builder: (context, state) => const WordAddPage(),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.account,
                builder: (context, state) => const AccountPage(),
                routes: [
                  GoRoute(
                    path: Routes.accountEdit,
                    builder: (context, state) => const AccountEditPage(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

class AppRouter {
  final AuthenticationBloc authBloc;

  AppRouter({required this.authBloc});

  GoRouter get router => GoRouter(
    initialLocation: Routes.splash,
    refreshListenable: GoRouterRefreshStream(authBloc.stream),
    redirect: (context, state) {
      final authState = authBloc.state;
      final isSplash = state.matchedLocation == Routes.splash;
      if (authState is! AuthenticationSuccess && !isSplash) {
        return Routes.splash;
      }
      if (isSplash) {
        return Routes.home;
      }
      return null;
    },
    routes: [
      GoRoute(
        path: Routes.splash,
        builder: (context, state) => const SplashPage(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, shellRoutes) =>
            AppPage(navigationShell: shellRoutes),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.home,
                builder: (context, state) => const HomePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.diary,
                builder: (context, state) =>
                    const Scaffold(body: Center(child: Text('Diary Page'))),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.words,
                builder: (context, state) => const WordPage(),
                routes: [
                  GoRoute(
                    path: Routes.wordsAdd,
                    builder: (context, state) => const WordAddPage(),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.account,
                builder: (context, state) => const AccountPage(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.listen((_) {
      notifyListeners();
    });
  }

  late final StreamSubscription _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
