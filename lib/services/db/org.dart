import 'package:espla/services/db/db.dart';
import 'package:sqflite_common/sqflite.dart';

class Org {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String name;
  final String description;
  final String image;

  Org({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.name,
    required this.description,
    required this.image,
  });

  Org.create({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
  })  : createdAt = DateTime.now(),
        updatedAt = DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'name': name,
      'description': description,
      'image': image,
    };
  }

  static Org fromMap(Map<String, dynamic> map) {
    return Org(
      id: map['id'],
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
      name: map['name'],
      description: map['description'],
      image: map['image'],
    );
  }
}

class OrgTable extends DBTable {
  OrgTable(super.db);

  @override
  String get name => 'org';

  @override
  String get createQuery => '''
    CREATE TABLE $name (
      id TEXT PRIMARY KEY,
      created_at TEXT,
      updated_at TEXT,
      name TEXT,
      description TEXT,
      image TEXT
    )
  ''';

  @override
  Future<void> create(Database db) async {
    await db.execute(createQuery);
  }

  @override
  Future<void> migrate(Database db, int oldVersion, int newVersion) async {}
}
