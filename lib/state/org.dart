import 'package:espla/services/db/asset.dart';
import 'package:espla/services/db/db.dart';
import 'package:flutter/cupertino.dart';

class OrgState with ChangeNotifier {
  final AssetTable _asset = MainDB().asset;

  final String _orgId;

  OrgState({required String orgId}) : _orgId = orgId;

  int assetsCount = 0;

  Future<void> fetchAssetsCount() async {
    assetsCount = await _asset.countByOrgId(_orgId);
    notifyListeners();
  }
}
