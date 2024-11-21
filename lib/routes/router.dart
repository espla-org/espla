import 'package:espla/routes/shell.dart';
import 'package:espla/screens/home/assets/screen.dart';
import 'package:espla/screens/home/proposals/screen.dart';
import 'package:espla/screens/home/screen.dart';
import 'package:espla/screens/landing/screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';

GoRouter createRouter(
  GlobalKey<NavigatorState> rootNavigatorKey,
  GlobalKey<NavigatorState> shellNavigatorKey,
  List<NavigatorObserver> observers,
) =>
    GoRouter(
      initialLocation: '/0x0a26e479BaCe7D97c679b9b1de0fF606739Dafa2/home',
      debugLogDiagnostics: kDebugMode,
      navigatorKey: rootNavigatorKey,
      observers: observers,
      routes: [
        GoRoute(
            name: 'Landing',
            path: '/',
            parentNavigatorKey: rootNavigatorKey,
            builder: (context, state) {
              return const LandingScreen();
            }),
        ShellRoute(
          builder: (context, state, child) => RouterShell(
            state: state,
            child: child,
          ),
          routes: [
            GoRoute(
              name: 'Home',
              path: '/:id/home',
              pageBuilder: (context, state) => NoTransitionPage(
                key: state.pageKey,
                name: state.name,
                child: const HomeScreen(),
              ),
            ),
            GoRoute(
              name: 'Assets',
              path: '/:id/assets',
              pageBuilder: (context, state) => NoTransitionPage(
                key: state.pageKey,
                name: state.name,
                child: AssetsScreen(address: state.pathParameters['id']!),
              ),
            ),
            GoRoute(
              name: 'Proposals',
              path: '/:id/proposals',
              pageBuilder: (context, state) => NoTransitionPage(
                key: state.pageKey,
                name: state.name,
                child: const ProposalsScreen(),
              ),
            ),
          ],
        ),
      ],
    );
