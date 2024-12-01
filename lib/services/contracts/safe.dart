import 'dart:async';
import 'package:flutter/services.dart' show rootBundle;

import 'package:web3dart/web3dart.dart';

class Safe {
  final int chainId;
  final Web3Client client;
  final String addr;
  late DeployedContract rcontract;

  Safe(this.chainId, this.client, this.addr);

  Future<void> init() async {
    final abi = await rootBundle.loadString('assets/contracts/Safe.json');

    final cabi = ContractAbi.fromJson(abi, 'Safe');

    rcontract = DeployedContract(cabi, EthereumAddress.fromHex(addr));
  }

  Future<List<EthereumAddress>> getOwners() async {
    final function = rcontract.function('getOwners');

    final result = await client.call(
      contract: rcontract,
      function: function,
      params: [],
    );

    return (result[0] as List<dynamic>)
        .map((addr) => addr as EthereumAddress)
        .toList();
  }

  Future<BigInt> getThreshold() async {
    final function = rcontract.function('getThreshold');

    final result =
        await client.call(contract: rcontract, function: function, params: []);

    return result[0] as BigInt;
  }
}
