import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<String> getDatabasePath() async {
    final directory = await getApplicationDocumentsDirectory();
    return join(directory.path, 'patient_database.db');
  }

  Future<Database> _initDatabase() async {
    final String path = await getDatabasesPath();
    final String databasePath = join(path, 'patient_database.db');
    return await openDatabase(
      databasePath,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE patients (
        id INTEGER PRIMARY KEY,
        code TEXT
      )
    ''');
  }

  Future<void> insertPatient(int id, String code) async {
    final db = await instance.database;
    await db.insert(
      'patients',
      {'id': id, 'code': code},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<String?> getCode(int id) async {
    final db = await instance.database;
    final List<Map<String, dynamic>> results = await db.query(
      'patients',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (results.isNotEmpty) {
      return results[0]['code'] as String;
    }
    return null;
  }

  Future<void> updateCode(int id, String code) async {
    final db = await instance.database;
    await db.update(
      'patients',
      {'code': code},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deletePatient(int id) async {
    final db = await instance.database;
    await db.delete(
      'patients',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
