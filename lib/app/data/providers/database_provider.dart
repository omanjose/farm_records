import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../utils/constants.dart';

/// Singleton wrapper around the local sqflite database used for all
/// digital record keeping in MOUAU Agro Farm. Every repository goes
/// through this single provider so the connection and schema stay
/// centralized and consistent.
class DatabaseProvider {
  DatabaseProvider._internal();
  static final DatabaseProvider instance = DatabaseProvider._internal();

  static const String _dbName = 'mouau_agro_farm.db';
  static const int _dbVersion = 1;

  Database? _database;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);

    return openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    final batch = db.batch();

    batch.execute('''
      CREATE TABLE ${DBTables.farmProfile} (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        farm_name TEXT NOT NULL,
        owner_name TEXT NOT NULL,
        location TEXT NOT NULL,
        phone TEXT,
        email TEXT,
        farm_size_acres REAL,
        established_date TEXT,
        notes TEXT
      )
    ''');

    batch.execute('''
      CREATE TABLE ${DBTables.crops} (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        crop_name TEXT NOT NULL,
        variety TEXT,
        field_location TEXT,
        area_planted REAL NOT NULL,
        planting_date TEXT NOT NULL,
        expected_harvest_date TEXT,
        actual_harvest_date TEXT,
        expected_yield_kg REAL,
        actual_yield_kg REAL,
        status TEXT NOT NULL,
        notes TEXT,
        created_at TEXT NOT NULL
      )
    ''');

    batch.execute('''
      CREATE TABLE ${DBTables.livestock} (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        animal_type TEXT NOT NULL,
        breed TEXT,
        tag_id TEXT,
        quantity INTEGER NOT NULL,
        gender TEXT,
        average_weight_kg REAL,
        date_acquired TEXT NOT NULL,
        health_status TEXT NOT NULL,
        last_vaccination_date TEXT,
        notes TEXT,
        created_at TEXT NOT NULL
      )
    ''');

    batch.execute('''
      CREATE TABLE ${DBTables.transactions} (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        type TEXT NOT NULL,
        category TEXT NOT NULL,
        amount REAL NOT NULL,
        date TEXT NOT NULL,
        description TEXT,
        created_at TEXT NOT NULL
      )
    ''');

    batch.execute('''
      CREATE TABLE ${DBTables.tasks} (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT,
        category TEXT NOT NULL,
        due_date TEXT NOT NULL,
        priority TEXT NOT NULL,
        status TEXT NOT NULL,
        created_at TEXT NOT NULL,
        completed_at TEXT
      )
    ''');

    await batch.commit(noResult: true);
  }

  /// Closes the database connection. Mainly useful for tests.
  Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }
}
