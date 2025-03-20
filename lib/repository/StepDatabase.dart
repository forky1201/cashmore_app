import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class StepDatabase {
  static final StepDatabase _instance = StepDatabase._internal();
  factory StepDatabase() => _instance;
  StepDatabase._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'steps.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE step_data (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            userId TEXT,
            date TEXT,
            todayStepBase INTEGER,
            lastSavedSteps INTEGER,
            stepCount INTEGER,
            UNIQUE (userId, date) ON CONFLICT REPLACE
          )
        ''');
      },
    );
  }

  /// 📌 **걸음 수 저장 및 업데이트 (userId와 date로 중복 방지)**
  Future<void> insertOrUpdateStepData(
      String userId, String date, int todayStepBase, int lastSavedSteps, int stepCount) async {
    final db = await database;
    await db.insert(
      'step_data',
      {
        'userId': userId,
        'date': date,
        'todayStepBase': todayStepBase,
        'lastSavedSteps': lastSavedSteps,
        'stepCount': stepCount,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// 📌 **걸음 수 불러오기 (userId와 date 기준)**
  Future<Map<String, dynamic>?> getStepData(String userId, String date) async {
    final db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      'step_data',
      where: 'userId = ? AND date = ?',
      whereArgs: [userId, date],
    );

    if (maps.isNotEmpty) {
      return maps.first;
    }
    return null;
  }

  /// 전전날 데이터 삭제 메서드 추가
  Future<void> deleteStepData(String userId, String date) async {
    final db = await database;
    await db.delete(
      'step_data',
      where: 'userId = ? AND date = ?',
      whereArgs: [userId, date],
    );
  }
}
