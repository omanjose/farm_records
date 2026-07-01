import '../../utils/constants.dart';
import '../models/livestock_model.dart';
import '../providers/database_provider.dart';

/// Handles all CRUD operations for livestock records.
class LivestockRepository {
  final DatabaseProvider _provider = DatabaseProvider.instance;

  Future<List<Livestock>> getAll() async {
    final db = await _provider.database;
    final results = await db.query(
      DBTables.livestock,
      orderBy: 'date_acquired DESC',
    );
    return results.map((e) => Livestock.fromMap(e)).toList();
  }

  Future<Livestock?> getById(int id) async {
    final db = await _provider.database;
    final results = await db.query(
      DBTables.livestock,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (results.isEmpty) return null;
    return Livestock.fromMap(results.first);
  }

  Future<int> create(Livestock item) async {
    final db = await _provider.database;
    return db.insert(DBTables.livestock, item.toMap());
  }

  Future<int> update(Livestock item) async {
    final db = await _provider.database;
    return db.update(
      DBTables.livestock,
      item.toMap(),
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await _provider.database;
    return db.delete(DBTables.livestock, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> countAll() async {
    final db = await _provider.database;
    final result = await db
        .rawQuery('SELECT COUNT(*) AS count FROM ${DBTables.livestock}');
    return (result.first['count'] as int?) ?? 0;
  }

  /// Total number of live animals across all batches (sum of quantity).
  Future<int> totalHeadCount() async {
    final db = await _provider.database;
    final result = await db.rawQuery(
      'SELECT SUM(quantity) AS total FROM ${DBTables.livestock} WHERE health_status != ?',
      [HealthStatus.deceased],
    );
    return (result.first['total'] as int?) ?? 0;
  }

  Future<int> countByHealthStatus(String status) async {
    final db = await _provider.database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) AS count FROM ${DBTables.livestock} WHERE health_status = ?',
      [status],
    );
    return (result.first['count'] as int?) ?? 0;
  }
}
