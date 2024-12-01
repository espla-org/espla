import 'package:espla/routes/shell.dart';
import 'package:espla/state/app.dart';
import 'package:espla/state/assets.dart';
import 'package:espla/state/owners.dart';
import 'package:espla/state/orgs.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

Widget provideAppState(
  Widget? child, {
  Widget Function(BuildContext, Widget?)? builder,
}) =>
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AppState(),
        ),
        ChangeNotifierProvider(
          create: (_) => OrgsState(),
        ),
      ],
      builder: builder,
      child: child,
    );

Widget provideOrgState(
  BuildContext context,
  GoRouterState state,
  Widget Function(AssetsState, OwnersState) builder,
) {
  final orgId = state.pathParameters['id']!;
  final assetsState = AssetsState(chainAddress: orgId);
  final ownersState = OwnersState(chainAddress: orgId);

  return MultiProvider(
    key: Key('org-$orgId'),
    providers: [
      ChangeNotifierProvider(
        key: Key('assets-$orgId'),
        create: (_) => assetsState,
      ),
      ChangeNotifierProvider(
        key: Key('owners-$orgId'),
        create: (_) => ownersState,
      ),
    ],
    builder: (_, __) => builder(assetsState, ownersState),
  );
}
