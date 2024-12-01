import 'package:espla/services/preferences/preferences.dart';
import 'package:espla/state/orgs.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  final PreferencesService _preferences = PreferencesService();
  late OrgsState _orgState;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _orgState = context.read<OrgsState>();

      onLoad();
    });
  }

  void onLoad() async {
    final orgs = await _orgState.fetchOrgs();

    if (orgs.isEmpty) {
      // TODO: fetch orgs from API
      return;
    }

    if (!super.mounted) {
      return;
    }

    final lastActiveOrgId = await _preferences.lastActiveOrgId;

    if (!super.mounted) {
      return;
    }

    GoRouter.of(context).go('/${lastActiveOrgId ?? orgs.first.id}/home');
  }

  @override
  Widget build(BuildContext context) {
    return const Text('Landing Screen');
  }
}
