import 'dart:convert';

class SafeAsset {
  final String tokenAddress;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? orgId;
  final TokenInfo? token;
  final String balance;

  SafeAsset({
    this.tokenAddress = 'native',
    DateTime? createdAt,
    DateTime? updatedAt,
    this.orgId,
    this.token,
    required this.balance,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  // For creating new DB entries
  SafeAsset.create({
    this.tokenAddress = 'native',
    required this.orgId,
    this.token,
    required this.balance,
  })  : createdAt = DateTime.now(),
        updatedAt = DateTime.now();

  // Check if this asset is a native coin (e.g., ETH)
  bool get isNativeCoin => tokenAddress == 'native' && token == null;

  // Factory constructor to create from JSON
  factory SafeAsset.fromJson(Map<String, dynamic> json, String chainAddress) {
    return SafeAsset(
      tokenAddress: json['tokenAddress'] ?? 'native',
      orgId: chainAddress,
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

  Map<String, dynamic> toMap() {
    return {
      'token_address': tokenAddress,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'org_id': orgId,
      'token': token?.toMap(),
      'balance': balance,
    };
  }

  static SafeAsset fromMap(Map<String, dynamic> map, {String? chainAddress}) {
    return SafeAsset(
      tokenAddress: map['token_address'] ?? map['tokenAddress'] ?? 'native',
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'])
          : DateTime.now(),
      updatedAt: map['updated_at'] != null
          ? DateTime.parse(map['updated_at'])
          : DateTime.now(),
      orgId: chainAddress ?? map['org_id'],
      token: map['token'] != null ? TokenInfo.fromMap(map['token']) : null,
      balance: map['balance'],
    );
  }

  Map<String, dynamic> toDB() {
    return {
      'token_address': tokenAddress,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'org_id': orgId,
      'token': token?.toJson(),
      'balance': balance,
    };
  }

  static SafeAsset fromDB(Map<String, dynamic> map) {
    return SafeAsset(
      tokenAddress: map['token_address'],
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'])
          : DateTime.now(),
      updatedAt: map['updated_at'] != null
          ? DateTime.parse(map['updated_at'])
          : DateTime.now(),
      orgId: map['org_id'],
      token: map['token'] != null ? TokenInfo.fromJson(map['token']) : null,
      balance: map['balance'],
    );
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
  factory TokenInfo.fromJson(String json) {
    final Map<String, dynamic> map = jsonDecode(json);

    return TokenInfo(
      name: map['name'],
      symbol: map['symbol'],
      decimals: map['decimals'],
      logoUri: map['logoUri'],
    );
  }

  // Convert to JSON
  String toJson() {
    return jsonEncode({
      'name': name,
      'symbol': symbol,
      'decimals': decimals,
      'logoUri': logoUri,
    });
  }

  factory TokenInfo.fromMap(Map<String, dynamic> map) {
    return TokenInfo(
      name: map['name'],
      symbol: map['symbol'],
      decimals: map['decimals'],
      logoUri: map['logoUri'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'symbol': symbol,
      'decimals': decimals,
      'logoUri': logoUri,
    };
  }
}
