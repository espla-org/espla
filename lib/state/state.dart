import 'package:espla/state/app.dart';
import 'package:espla/state/assets.dart';
import 'package:espla/state/members.dart';
import 'package:espla/state/orgs.dart';
import 'package:espla/state/voting.dart';
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
  Widget child,
) {
  final orgId = state.pathParameters['id']!;

  return MultiProvider(
    key: Key('org-$orgId'),
    providers: [
      ChangeNotifierProvider(
        key: Key('assets-$orgId'),
        create: (_) => AssetsState(chainAddress: orgId),
      ),
      ChangeNotifierProvider(
        key: Key('members-$orgId'),
        create: (_) => MembersState(chainAddress: orgId),
      ),
      ChangeNotifierProvider(
        key: Key('voting-$orgId'),
        create: (_) => VotingState(orgId: orgId),
      ),
    ],
    child: child,
  );
}
