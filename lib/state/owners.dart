import 'package:espla/services/db/db.dart';
import 'package:espla/services/db/owner.dart';
import 'package:espla/services/safe/safe.dart';
import 'package:flutter/cupertino.dart';

class OwnersState with ChangeNotifier {
  final SafeService _safeService;
  final OwnerTable _owner = MainDB().owner;

  final String _orgId;

  OwnersState({required String chainAddress})
      : _safeService = SafeService(chainAddress: chainAddress),
        _orgId = chainAddress;

  bool loading = false;
  List<Owner> owners = [];
  int ownersCount = 0;

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

  Future<void> fetchOwners() async {
    try {
      loading = true;
      safeNotifyListeners();

      final localOwners = await _owner.getByOrgId(_orgId);

      this.owners = localOwners;
      ownersCount = localOwners.length;
      safeNotifyListeners();

      final safeOwners = await _safeService.getOwners();

      List<Owner> owners = [];

      for (final owner in safeOwners) {
        owners.add(Owner.create(address: owner, orgId: _orgId));
      }

      this.owners = owners;
      ownersCount = owners.length;
      safeNotifyListeners();

      await _owner.upsertOwners(owners);
    } catch (_) {
    } finally {
      loading = false;
      safeNotifyListeners();
    }
  }
}
