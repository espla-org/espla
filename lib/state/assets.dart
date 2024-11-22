import 'package:espla/services/safe/safe.dart';
import 'package:flutter/cupertino.dart';
import 'package:espla/services/safe/asset.dart';

class AssetsState with ChangeNotifier {
  final SafeService _safeService;

  AssetsState({required String chainAddress})
      : _safeService = SafeService(chainAddress: chainAddress);

  bool loading = false;
  List<SafeAsset> assets = [];

  Future<void> fetchAssets() async {
    try {
      loading = true;
      notifyListeners();

      final assets = await _safeService.getBalances();

      this.assets = assets.results;
      notifyListeners();
    } catch (e) {
      print(e);
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}
