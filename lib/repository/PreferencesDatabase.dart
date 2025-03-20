import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

/// ── PreferencesDatabase: 단순한 key-value 저장 (설정값 관리) ──────────────────────────────
class PreferencesDatabase {
  static final PreferencesDatabase _instance = PreferencesDatabase._internal();
  factory PreferencesDatabase() => _instance;
  PreferencesDatabase._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'preferences.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE preferences (
            key TEXT PRIMARY KEY,
            value TEXT
          )
        ''');
      },
    );
  }

  Future<String?> getPreference(String key) async {
    final db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      'preferences',
      where: 'key = ?',
      whereArgs: [key],
    );
    if (maps.isNotEmpty) {
      return maps.first['value'] as String?;
    }
    return null;
  }

  Future<void> setPreference(String key, String value) async {
    final db = await database;
    await db.insert(
      'preferences',
      {'key': key, 'value': value},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
