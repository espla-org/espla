import 'package:espla/services/api/api.dart';
import 'package:espla/services/safe/asset.dart';
import 'package:espla/services/safe/response.dart';

class SafeService {
  final APIService api;

  SafeService({required String baseURL})
      : api = APIService(baseURL: '$baseURL/safes');

  Future<PaginatedResponse<SafeAsset>> getBalance({
    required String address,
    int offset = 0,
    int limit = 10,
    bool trusted = true,
  }) async {
    final response = await api.get(
      url: '/$address/balances?offset=$offset&limit=$limit&trusted=$trusted',
    );

    return PaginatedResponse.fromJson(
      response,
      (e) => SafeAsset.fromJson(e),
    );
  }
}
