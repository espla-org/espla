import 'package:espla/services/db/asset.dart';
import 'package:espla/services/db/db.dart';
import 'package:espla/services/safe/safe.dart';
import 'package:flutter/cupertino.dart';
import 'package:espla/services/safe/asset.dart';

class AssetsState with ChangeNotifier {
  final SafeService _safeService;
  final AssetTable _asset = MainDB().asset;

  final String _orgId;

  AssetsState({required String chainAddress})
      : _safeService = SafeService(chainAddress: chainAddress),
        _orgId = chainAddress;

  bool loading = false;
  List<SafeAsset> assets = [];

  Future<void> fetchAssets() async {
    try {
      loading = true;
      notifyListeners();

      final localAssets = await _asset.getByOrgId(_orgId);

      this.assets = localAssets;
      notifyListeners();

      final assets = await _safeService.getBalances();

      this.assets = assets.results;
      notifyListeners();

      await _asset.upsertAssets(assets.results);
    } catch (_) {
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}
