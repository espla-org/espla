import 'package:espla/services/db/db.dart';
import 'package:espla/services/db/member.dart';
import 'package:espla/services/safe/safe.dart';
import 'package:flutter/cupertino.dart';

class MembersState with ChangeNotifier {
  final SafeService _safeService;
  final MemberTable _member = MainDB().member;

  final String _orgId;

  MembersState({required String chainAddress})
      : _safeService = SafeService(chainAddress: chainAddress),
        _orgId = chainAddress;

  bool loading = false;
  List<Member> members = [];
  int membersCount = 0;

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

  Future<void> fetchMembers() async {
    try {
      loading = true;
      safeNotifyListeners();

      final localMembers = await _member.getByOrgId(_orgId);

      this.members = localMembers;
      membersCount = localMembers.length;
      safeNotifyListeners();

      final safeOwners = await _safeService.getOwners();

      List<Member> members = [];

      for (final member in safeOwners) {
        members.add(Member.create(address: member, orgId: _orgId));
      }

      this.members = members;
      membersCount = members.length;
      safeNotifyListeners();

      await _member.upsertMembers(members);
    } catch (_) {
    } finally {
      loading = false;
      safeNotifyListeners();
    }
  }
}
