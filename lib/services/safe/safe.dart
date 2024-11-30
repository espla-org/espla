import 'package:espla/services/api/api.dart';
import 'package:espla/services/safe/asset.dart';
import 'package:espla/services/safe/response.dart';

const Map<String, String> chainURLs = {
  'matic': 'https://safe-transaction-polygon.safe.global/api/v2',
  'gno': 'https://safe-transaction-gnosis-chain.safe.global/api/v2',
  'eth': 'https://safe-transaction-mainnet.safe.global/api/v2',
  'base': 'https://safe-transaction-base.safe.global/api/v2',
  'arb': 'https://safe-transaction-arbitrum.safe.global/api/v2',
  'avalanche': 'https://safe-transaction-avalanche.safe.global/api/v2',
  'optimism': 'https://safe-transaction-optimism.safe.global/api/v2',
  'polygon': 'https://safe-transaction-polygon.safe.global/api/v2',
  'zkevm': 'https://safe-transaction-zkevm.safe.global/api/v2',
};

String getURLFromERC3770(String address) {
  final parts = address.split(':');
  if (parts.length != 2) {
    throw const FormatException(
        'Invalid ERC3770 address format. Expected chain:address');
  }

  final chain = parts[0];
  final walletAddress = parts[1];

  final chainURL = chainURLs[chain];
  if (chainURL == null) {
    throw FormatException('Unsupported chain: $chain');
  }

  return '$chainURL/safes/$walletAddress';
}

class SafeService {
  final APIService api;
  final String _chainAddress;

  SafeService({required String chainAddress})
      : api = APIService(baseURL: getURLFromERC3770(chainAddress)),
        _chainAddress = chainAddress;

  Future<PaginatedResponse<SafeAsset>> getBalances({
    int offset = 0,
    int limit = 10,
    bool trusted = true,
  }) async {
    final response = await api.get(
      url: '/balances?offset=$offset&limit=$limit&trusted=$trusted',
    );

    return PaginatedResponse.fromJson(
      response,
      (e) => SafeAsset.fromMap(e, chainAddress: _chainAddress),
    );
  }
}
