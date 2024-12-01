import 'package:espla/services/api/api.dart';
import 'package:espla/services/contracts/safe.dart';
import 'package:espla/services/safe/asset.dart';
import 'package:espla/services/safe/response.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';

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

const Map<String, int> chainIds = {
  'matic': 137,
  'gno': 100,
  'eth': 1,
  'base': 8453,
  'arb': 42161,
  'avalanche': 43114,
  'optimism': 10,
  'zkevm': 1101,
};

const Map<String, String> chainRPCs = {
  'matic': 'https://polygon.llamarpc.com',
  'gno': 'https://rpc.gnosischain.com',
  'eth': 'https://mainnet.infura.io/v3',
  'base': 'https://base.llamarpc.com',
  'arb': 'https://arbitrum.llamarpc.com',
  'avalanche': 'https://avalanche.llamarpc.com',
  'optimism': 'https://optimism.llamarpc.com',
  'zkevm': 'https://zkevm.llamarpc.com',
};

String getURLFromERC3770(String address) {
  final parts = address.split(':');
  if (parts.length != 2) {
    throw const FormatException(
        'Invalid ERC3770 address format. Expected chain:address');
  }

  final chain = parts[0];
  final accountAddress = parts[1];

  final chainURL = chainURLs[chain];
  if (chainURL == null) {
    throw FormatException('Unsupported chain: $chain');
  }

  return '$chainURL/safes/$accountAddress';
}

String getRPCFromERC3770(String address) {
  final parts = address.split(':');
  final chain = parts[0];

  return chainRPCs[chain]!;
}

int getChainIdFromERC3770(String address) {
  final parts = address.split(':');
  final chain = parts[0];

  return chainIds[chain]!;
}

String getAccountAddressFromERC3770(String address) {
  final parts = address.split(':');
  return parts[1];
}

class SafeService {
  late APIService api;
  late String _chainAddress;
  late String _address;
  late int _chainId;
  late Safe _safe;

  SafeService({required String chainAddress}) {
    api = APIService(baseURL: getURLFromERC3770(chainAddress));
    _chainAddress = chainAddress;
    _address = getAccountAddressFromERC3770(chainAddress);
    _chainId = getChainIdFromERC3770(chainAddress);
    _safe = Safe(
      _chainId,
      Web3Client(getRPCFromERC3770(chainAddress), Client()),
      _address,
    );

    _safe.init();
  }

  int get chainId => _chainId;
  String get address => _address;

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

  Future<List<EthereumAddress>> getOwners() async {
    return await _safe.getOwners();
  }
}
