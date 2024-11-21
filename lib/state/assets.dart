import 'package:espla/services/safe/safe.dart';
import 'package:flutter/cupertino.dart';
import 'package:espla/services/safe/asset.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AssetsState with ChangeNotifier {
  final SafeService _safeService = SafeService(
    baseURL: dotenv.get('SAFE_BASE_URL'),
  );

  bool loading = false;
  List<SafeAsset> assets = [];

  Future<void> fetchAssets(String address) async {
    try {
      loading = true;
      notifyListeners();

      final assets = await _safeService.getBalance(address: address);

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
