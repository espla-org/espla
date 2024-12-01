import 'package:espla/services/db/db.dart';
import 'package:espla/services/profiles/profiles.dart';
import 'package:sqflite_common/sqflite.dart';
import 'package:web3dart/web3dart.dart';

class Owner {
  final EthereumAddress address;
  final String orgId;
  final Profile? profile;
  final DateTime createdAt;
  final DateTime updatedAt;

  Owner({
    required this.address,
    required this.orgId,
    this.profile,
    required this.createdAt,
    required this.updatedAt,
  });

  Owner.create({
    required this.address,
    required this.orgId,
    this.profile,
  })  : createdAt = DateTime.now(),
        updatedAt = DateTime.now();

  Map<String, dynamic> toDB() {
    return {
      'address': address.hexEip55,
      'org_id': orgId,
      'profile': profile?.toJson(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  static Owner fromDB(Map<String, dynamic> map) {
    return Owner(
      address: EthereumAddress.fromHex(map['address']),
      orgId: map['org_id'],
      profile: map['profile'] != null ? Profile.fromJson(map['profile']) : null,
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
    );
  }
}

class OwnerTable extends DBTable {
  OwnerTable(super.db);

  @override
  String get name => 'owner';

  @override
  String get createQuery => '''
    CREATE TABLE $name (
      address TEXT,
      org_id TEXT,
      profile TEXT,
      created_at TEXT,
      updated_at TEXT,
      PRIMARY KEY (address),
      FOREIGN KEY (org_id) REFERENCES org (id)
    )
  ''';

  @override
  Future<void> create(Database db) async {
    await db.execute(createQuery);
  }

  @override
  Future<void> migrate(Database db, int oldVersion, int newVersion) async {
    final Map<int, List<String>> migrations = {
      3: [
        createQuery,
      ]
    };

    for (var i = oldVersion + 1; i <= newVersion; i++) {
      final queries = migrations[i];

      if (queries != null) {
        for (final query in queries) {
          try {
            await db.execute(query);
          } catch (_) {}
        }
      }
    }
  }

  Future<List<Owner>> getByOrgId(String orgId) async {
    final List<Map<String, dynamic>> maps =
        await db.query(name, where: 'org_id = ?', whereArgs: [orgId]);
    return List.generate(maps.length, (i) => Owner.fromDB(maps[i]));
  }

  Future<int> countByOrgId(String orgId) async {
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM $name WHERE org_id = ?',
      [orgId],
    );
    return result.first['count'] as int;
  }

  Future<void> upsertOwner(Owner owner) async {
    await db.insert(
      name,
      owner.toDB(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> upsertOwners(List<Owner> owners) async {
    for (final owner in owners) {
      await upsertOwner(owner);
    }
  }

  Future<void> deleteByOrgId(String orgId) async {
    await db.delete(
      name,
      where: 'org_id = ?',
      whereArgs: [orgId],
    );
  }
}
