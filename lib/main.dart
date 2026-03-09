import 'package:daily_language/core/di/service_locator.dart';
import 'package:daily_language/core/route/router.dart';
import 'package:daily_language/core/theme/app_theme.dart';
import 'package:daily_language/features/account/presentation/bloc/account_bloc/account_bloc.dart';
import 'package:daily_language/features/authentication/presentation/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:daily_language/l10n/app_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DI.instance.init();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Bloc.observer = AppBlocObserver();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final AuthenticationBloc _authBloc;
  late final GoRouterRefreshStream _authRefresh;

  @override
  void initState() {
    super.initState();
    _authBloc = sl<AuthenticationBloc>()..add(AuthenticationRequested());
    _authRefresh = GoRouterRefreshStream(_authBloc.stream);
  }

  @override
  void dispose() {
    _authRefresh.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _authBloc),
        BlocProvider(create: (context) => sl<AccountBloc>()),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: appTheme,
        routerConfig: router(_authRefresh),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
      ),
    );
  }
}

class AppBlocObserver extends BlocObserver {
  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    debugPrint('🔄 [${bloc.runtimeType}] $transition');
  }
}
