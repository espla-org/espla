import 'package:espla/routes/shell.dart';
import 'package:espla/screens/home/assets/screen.dart';
import 'package:espla/screens/home/discussions/screen.dart';
import 'package:espla/screens/home/members/screen.dart';
import 'package:espla/screens/home/proposals/screen.dart';
import 'package:espla/screens/home/screen.dart';
import 'package:espla/screens/landing/screen.dart';
import 'package:espla/state/state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';

GoRouter createRouter(
  GlobalKey<NavigatorState> rootNavigatorKey,
  GlobalKey<NavigatorState> shellNavigatorKey,
  List<NavigatorObserver> observers,
) =>
    GoRouter(
      initialLocation: '/',
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
          builder: (context, state, child) => provideOrgState(
            context,
            state,
            (assetsState, ownersState) => RouterShell(
              key: Key(state.pathParameters['id']!),
              state: state,
              assetsState: assetsState,
              ownersState: ownersState,
              child: child,
            ),
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
              name: 'Members',
              path: '/:id/members',
              pageBuilder: (context, state) => NoTransitionPage(
                key: state.pageKey,
                name: state.name,
                child: const MembersScreen(),
              ),
            ),
            GoRoute(
              name: 'Assets',
              path: '/:id/assets',
              pageBuilder: (context, state) => NoTransitionPage(
                key: state.pageKey,
                name: state.name,
                child: const AssetsScreen(),
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
            GoRoute(
              name: 'Discussions',
              path: '/:id/discussions/:discussionId',
              pageBuilder: (context, state) => NoTransitionPage(
                key: state.pageKey,
                name: state.name,
                child: const DiscussionsScreen(),
              ),
            ),
          ],
        ),
      ],
    );
