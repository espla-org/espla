import 'package:espla/services/preferences/preferences.dart';
import 'package:espla/services/safe/safe.dart';
import 'package:flutter/cupertino.dart';

class VotingState extends ChangeNotifier {
  final String _orgId;
  final PreferencesService _preferences = PreferencesService();
  final SafeService _safeService;

  VotingState({required String orgId})
      : _orgId = orgId,
        _safeService = SafeService(chainAddress: orgId);

  bool _mounted = true;

  void safeNotifyListeners() {
    if (_mounted) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _mounted = false;
    super.dispose();
  }

  bool loading = false;
  BigInt threshold = BigInt.one;

  Future<void> getThreshold() async {
    try {
      loading = true;
      safeNotifyListeners();

      final localThreshold = await _preferences.getOrgThreshold(_orgId);
      if (localThreshold != null) {
        loading = false;
      }
      threshold = BigInt.parse(localThreshold ?? '0');
      safeNotifyListeners();

      final remoteThreshold = await _safeService.getThreshold();
      threshold = remoteThreshold;
      loading = false;
      safeNotifyListeners();

      await _preferences.setOrgThreshold(_orgId, threshold.toString());
    } catch (_) {
      loading = false;
      safeNotifyListeners();
    }
  }
}

enum VotingThreshold {
  majority('Majority'),
  supermajority('Supermajority'),
  unanimous('Unanimous'),
  decisive('Decisive'),
  custom('Custom');

  final String name;
  const VotingThreshold(this.name);

  @override
  String toString() => name;
}

(VotingThreshold?, double?) Function(VotingState) selectVotingThreshold(
    int memberCount) {
  return (VotingState state) {
    if (state.loading || memberCount == 0) {
      return (null, null);
    }

    if (state.threshold == BigInt.one) {
      return (VotingThreshold.decisive, null);
    }

    final threshold = state.threshold / BigInt.from(memberCount);

    if (threshold >= 0.5) {
      return (VotingThreshold.majority, threshold * 100);
    }

    if (threshold >= 0.66) {
      return (VotingThreshold.supermajority, threshold * 100);
    }

    if (threshold >= 0.8) {
      return (VotingThreshold.unanimous, threshold * 100);
    }

    return (VotingThreshold.custom, threshold * 100);
  };
}
