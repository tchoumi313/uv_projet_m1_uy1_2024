import 'package:sqflite/sqflite.dart';

class NoteDatabase {
  static final NoteDatabase instance = NoteDatabase._internal();

  static Database? _database;

  NoteDatabase._internal();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = '$databasePath/nexgen-agri.db';
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE recommendations (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id TEXT NOT NULL,
        nitrogen DOUBLE NOT NULL,
        phosphorus DOUBLE NOT NULL,
        potassium DOUBLE NOT NULL,
        ph DOUBLE NOT NULL,
        temperature DOUBLE NOT NULL,
        humidity DOUBLE NOT NULL,
        rainfall DOUBLE NOT NULL,
        recommendation TEXT NOT NULL,
        timestamp INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE diseases_detections (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id TEXT NOT NULL,
        isHealthy BOOLEAN NOT NULL,
        diseaseName TEXT NOT NULL,
        description TEXT,
        solution TEXT,
        vegetable TEXT,
        imagePath TEXT
        timestamp INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE chat_history (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id TEXT NOT NULL,
        role TEXT NOT NULL,
        content TEXT NOT NULL,
        timestamp INTEGER NOT NULL
      )
    ''');
  }
}
