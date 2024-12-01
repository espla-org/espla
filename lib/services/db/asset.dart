import 'package:espla/services/db/db.dart';
import 'package:espla/services/safe/asset.dart';
import 'package:sqflite_common/sqflite.dart';

class AssetTable extends DBTable {
  AssetTable(super.db);

  @override
  String get name => 'asset';

  @override
  String get createQuery => '''
    CREATE TABLE $name (
      token_address TEXT,
      created_at TEXT,
      updated_at TEXT,
      org_id TEXT,
      token TEXT,
      balance TEXT,
      PRIMARY KEY (token_address, org_id),
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
      2: [
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

  Future<List<SafeAsset>> getByOrgId(String orgId) async {
    final List<Map<String, dynamic>> maps =
        await db.query(name, where: 'org_id = ?', whereArgs: [orgId]);
    return List.generate(maps.length, (i) => SafeAsset.fromDB(maps[i]));
  }

  Future<int> countByOrgId(String orgId) async {
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM $name WHERE org_id = ?',
      [orgId],
    );
    return result.first['count'] as int;
  }

  Future<void> upsertAsset(SafeAsset asset) async {
    await db.insert(
      name,
      asset.toDB(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> upsertAssets(List<SafeAsset> assets) async {
    for (final asset in assets) {
      await upsertAsset(asset);
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
