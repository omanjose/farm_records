import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../constants/app_constants.dart';

class DatabaseHelper {
  DatabaseHelper._internal();
  static final DatabaseHelper instance = DatabaseHelper._internal();
  factory DatabaseHelper() => instance;

  static Database? _db;

  Future<Database> get database async {
    _db ??= await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, AppConstants.dbName);
    return openDatabase(
      path,
      version: AppConstants.dbVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE ${AppConstants.tblUsers} (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL UNIQUE,
        password_hash TEXT NOT NULL,
        full_name TEXT NOT NULL,
        role TEXT NOT NULL DEFAULT 'supervisor',
        email TEXT,
        created_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE ${AppConstants.tblFarms} (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        farm_name TEXT NOT NULL,
        location TEXT,
        total_area REAL DEFAULT 0,
        description TEXT,
        created_at TEXT NOT NULL,
        FOREIGN KEY (user_id) REFERENCES ${AppConstants.tblUsers}(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE ${AppConstants.tblCrops} (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        farm_id INTEGER NOT NULL,
        crop_type TEXT NOT NULL,
        seed_variety TEXT,
        area_ha REAL NOT NULL,
        date_planted TEXT NOT NULL,
        expected_yield_kg REAL,
        actual_yield_kg REAL,
        fertilizer_used TEXT,
        season TEXT NOT NULL,
        status TEXT NOT NULL DEFAULT 'Planted',
        notes TEXT,
        created_at TEXT NOT NULL,
        FOREIGN KEY (farm_id) REFERENCES ${AppConstants.tblFarms}(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE ${AppConstants.tblLivestock} (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        farm_id INTEGER NOT NULL,
        animal_type TEXT NOT NULL,
        breed TEXT,
        quantity INTEGER NOT NULL,
        health_status TEXT NOT NULL DEFAULT 'Healthy',
        vaccination_date TEXT,
        next_vaccination TEXT,
        notes TEXT,
        created_at TEXT NOT NULL,
        FOREIGN KEY (farm_id) REFERENCES ${AppConstants.tblFarms}(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE ${AppConstants.tblExpenses} (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        farm_id INTEGER NOT NULL,
        type TEXT NOT NULL DEFAULT 'Expense',
        category TEXT NOT NULL,
        amount REAL NOT NULL,
        description TEXT,
        transaction_date TEXT NOT NULL,
        created_at TEXT NOT NULL,
        FOREIGN KEY (farm_id) REFERENCES ${AppConstants.tblFarms}(id)
      )
    ''');

    // Indexes for query performance
    await db.execute('CREATE INDEX idx_crops_farm ON ${AppConstants.tblCrops}(farm_id)');
    await db.execute('CREATE INDEX idx_livestock_farm ON ${AppConstants.tblLivestock}(farm_id)');
    await db.execute('CREATE INDEX idx_expenses_farm ON ${AppConstants.tblExpenses}(farm_id)');
    await db.execute('CREATE INDEX idx_expenses_date ON ${AppConstants.tblExpenses}(transaction_date)');

    await _seedData(db);
  }

  Future<void> _seedData(Database db) async {
    final now = DateTime.now().toIso8601String();

    // Default admin user
    await db.insert(AppConstants.tblUsers, {
      'username': AppConstants.defaultAdminUsername,
      'password_hash': AppConstants.defaultAdminPasswordHash,
      'full_name': 'System Administrator',
      'role': AppConstants.roleAdmin,
      'email': 'admin@dfrms.ng',
      'created_at': now,
    });

    // Manager user
    await db.insert(AppConstants.tblUsers, {
      'username': 'manager',
      // SHA-256 of 'farm2024'
      'password_hash': '4b5b7a63c3c6a86e22a87e19cf32dc3bc91e9e53a5bbe89d0f0e1a1a21e2f2a5',
      'full_name': 'John Obi (Farm Manager)',
      'role': AppConstants.roleManager,
      'email': 'john.obi@sunrise-agro.ng',
      'created_at': now,
    });

    // Default farm
    final farmId = await db.insert(AppConstants.tblFarms, {
      'user_id': 1,
      'farm_name': 'Sunrise Agro Limited',
      'location': 'Onitsha, Anambra State',
      'total_area': 85.0,
      'description': 'Medium-scale agricultural enterprise engaged in crop and livestock farming.',
      'created_at': now,
    });

    // Sample crop records
    final crops = [
      {
        'farm_id': farmId, 'crop_type': 'Maize', 'seed_variety': 'SWAM1',
        'area_ha': 20.0, 'date_planted': '2024-04-10', 'expected_yield_kg': 12000.0,
        'actual_yield_kg': 11500.0, 'fertilizer_used': 'NPK 20kg, Urea 10kg',
        'season': 'Wet Season', 'status': 'Harvested', 'notes': 'Good yield this season.', 'created_at': now,
      },
      {
        'farm_id': farmId, 'crop_type': 'Cassava', 'seed_variety': 'TME419',
        'area_ha': 30.0, 'date_planted': '2024-03-15', 'expected_yield_kg': 18000.0,
        'actual_yield_kg': null, 'fertilizer_used': 'NPK 25kg',
        'season': 'Wet Season', 'status': 'Growing', 'notes': null, 'created_at': now,
      },
      {
        'farm_id': farmId, 'crop_type': 'Yam', 'seed_variety': 'White Yam',
        'area_ha': 15.0, 'date_planted': '2024-01-20', 'expected_yield_kg': 9000.0,
        'actual_yield_kg': 8500.0, 'fertilizer_used': 'Organic compost',
        'season': 'Dry Season', 'status': 'Harvested', 'notes': 'Slight drought stress observed.', 'created_at': now,
      },
      {
        'farm_id': farmId, 'crop_type': 'Soybean', 'seed_variety': 'TGX',
        'area_ha': 12.0, 'date_planted': '2024-05-01', 'expected_yield_kg': 6000.0,
        'actual_yield_kg': null, 'fertilizer_used': 'Rhizobium inoculant',
        'season': 'Wet Season', 'status': 'Growing', 'notes': null, 'created_at': now,
      },
    ];

    for (final c in crops) {
      await db.insert(AppConstants.tblCrops, c);
    }

    // Sample livestock records
    final livestock = [
      {
        'farm_id': farmId, 'animal_type': 'Cattle', 'breed': 'Bunaji',
        'quantity': 45, 'health_status': 'Healthy', 'vaccination_date': '2024-02-10',
        'next_vaccination': '2024-08-10', 'notes': 'Monthly weight monitoring ongoing.', 'created_at': now,
      },
      {
        'farm_id': farmId, 'animal_type': 'Goat', 'breed': 'West African Dwarf',
        'quantity': 60, 'health_status': 'Healthy', 'vaccination_date': '2024-03-05',
        'next_vaccination': '2024-09-05', 'notes': null, 'created_at': now,
      },
      {
        'farm_id': farmId, 'animal_type': 'Chicken', 'breed': 'Noiler',
        'quantity': 500, 'health_status': 'Healthy', 'vaccination_date': '2024-04-20',
        'next_vaccination': '2024-07-20', 'notes': 'Layers producing ~450 eggs/day.', 'created_at': now,
      },
      {
        'farm_id': farmId, 'animal_type': 'Pig', 'breed': 'Large White',
        'quantity': 30, 'health_status': 'Under Treatment', 'vaccination_date': '2024-01-15',
        'next_vaccination': '2024-07-15', 'notes': 'Three pigs under treatment for respiratory infection.', 'created_at': now,
      },
    ];

    for (final l in livestock) {
      await db.insert(AppConstants.tblLivestock, l);
    }

    // Sample expense/income records
    final transactions = [
      {'farm_id': farmId, 'type': 'Expense', 'category': 'Labour', 'amount': 250000.0, 'description': 'Seasonal farm workers payment – April', 'transaction_date': '2024-04-30', 'created_at': now},
      {'farm_id': farmId, 'type': 'Expense', 'category': 'Fertilizer', 'amount': 185000.0, 'description': 'NPK and Urea fertilizer purchase', 'transaction_date': '2024-04-05', 'created_at': now},
      {'farm_id': farmId, 'type': 'Expense', 'category': 'Seeds', 'amount': 95000.0, 'description': 'Improved maize and soybean seeds', 'transaction_date': '2024-04-02', 'created_at': now},
      {'farm_id': farmId, 'type': 'Expense', 'category': 'Veterinary', 'amount': 45000.0, 'description': 'Vaccination and deworming – cattle & goats', 'transaction_date': '2024-03-20', 'created_at': now},
      {'farm_id': farmId, 'type': 'Expense', 'category': 'Equipment', 'amount': 320000.0, 'description': 'Tractor service and irrigation pump repair', 'transaction_date': '2024-03-10', 'created_at': now},
      {'farm_id': farmId, 'type': 'Income', 'category': 'Crop Sales', 'amount': 920000.0, 'description': 'Maize sale – 11,500 kg @ ₦80/kg', 'transaction_date': '2024-06-15', 'created_at': now},
      {'farm_id': farmId, 'type': 'Income', 'category': 'Crop Sales', 'amount': 680000.0, 'description': 'Yam sale – 8,500 kg @ ₦80/kg', 'transaction_date': '2024-05-20', 'created_at': now},
      {'farm_id': farmId, 'type': 'Income', 'category': 'Livestock Sales', 'amount': 560000.0, 'description': 'Cattle sale – 4 heads', 'transaction_date': '2024-05-10', 'created_at': now},
      {'farm_id': farmId, 'type': 'Income', 'category': 'Eggs', 'amount': 135000.0, 'description': 'Egg sales – 15,000 crates', 'transaction_date': '2024-06-01', 'created_at': now},
      {'farm_id': farmId, 'type': 'Expense', 'category': 'Feed', 'amount': 210000.0, 'description': 'Poultry and pig feed – monthly supply', 'transaction_date': '2024-05-01', 'created_at': now},
    ];

    for (final t in transactions) {
      await db.insert(AppConstants.tblExpenses, t);
    }
  }

  // ─── Generic helpers ───────────────────────────────────────────────────────

  Future<int> insert(String table, Map<String, dynamic> row) async {
    final db = await database;
    return db.insert(table, row, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> update(String table, Map<String, dynamic> row, int id) async {
    final db = await database;
    return db.update(table, row, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> delete(String table, int id) async {
    final db = await database;
    return db.delete(table, where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> queryAll(String table,
      {String? orderBy}) async {
    final db = await database;
    return db.query(table, orderBy: orderBy ?? 'created_at DESC');
  }

  Future<List<Map<String, dynamic>>> queryWhere(
    String table, {
    required String where,
    required List<dynamic> whereArgs,
    String? orderBy,
  }) async {
    final db = await database;
    return db.query(table,
        where: where,
        whereArgs: whereArgs,
        orderBy: orderBy ?? 'created_at DESC');
  }

  Future<Map<String, dynamic>?> queryById(String table, int id) async {
    final db = await database;
    final result = await db.query(table, where: 'id = ?', whereArgs: [id]);
    return result.isNotEmpty ? result.first : null;
  }

  Future<List<Map<String, dynamic>>> rawQuery(String sql,
      [List<dynamic>? args]) async {
    final db = await database;
    return db.rawQuery(sql, args);
  }
}
