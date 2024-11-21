class SafeAsset {
  final String? tokenAddress;
  final TokenInfo? token;
  final String balance;

  const SafeAsset({
    this.tokenAddress,
    this.token,
    required this.balance,
  });

  // Check if this asset is a native coin (e.g., ETH)
  bool get isNativeCoin => tokenAddress == null && token == null;

  // Factory constructor to create from JSON
  factory SafeAsset.fromJson(Map<String, dynamic> json) {
    return SafeAsset(
      tokenAddress: json['tokenAddress'],
      token: json['token'] != null ? TokenInfo.fromJson(json['token']) : null,
      balance: json['balance'],
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'tokenAddress': tokenAddress,
      'token': token?.toJson(),
      'balance': balance,
    };
  }
}

class TokenInfo {
  final String name;
  final String symbol;
  final int decimals;
  final String? logoUri;

  const TokenInfo({
    required this.name,
    required this.symbol,
    required this.decimals,
    this.logoUri,
  });

  // Factory constructor to create from JSON
  factory TokenInfo.fromJson(Map<String, dynamic> json) {
    return TokenInfo(
      name: json['name'],
      symbol: json['symbol'],
      decimals: json['decimals'],
      logoUri: json['logoUri'],
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'symbol': symbol,
      'decimals': decimals,
      'logoUri': logoUri,
    };
  }
}
