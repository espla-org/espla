import 'package:espla/state/app.dart';
import 'package:espla/state/assets.dart';
import 'package:espla/state/orgs.dart';
import 'package:flutter/cupertino.dart';
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
