import '../../utils/constants.dart';
import '../models/crop_model.dart';
import '../providers/database_provider.dart';

/// Handles all CRUD operations for crop production records.
class CropRepository {
  final DatabaseProvider _provider = DatabaseProvider.instance;

  Future<List<Crop>> getAll() async {
    final db = await _provider.database;
    final results = await db.query(
      DBTables.crops,
      orderBy: 'planting_date DESC',
    );
    return results.map((e) => Crop.fromMap(e)).toList();
  }

  Future<Crop?> getById(int id) async {
    final db = await _provider.database;
    final results = await db.query(
      DBTables.crops,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (results.isEmpty) return null;
    return Crop.fromMap(results.first);
  }

  Future<int> create(Crop crop) async {
    final db = await _provider.database;
    return db.insert(DBTables.crops, crop.toMap());
  }

  Future<int> update(Crop crop) async {
    final db = await _provider.database;
    return db.update(
      DBTables.crops,
      crop.toMap(),
      where: 'id = ?',
      whereArgs: [crop.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await _provider.database;
    return db.delete(DBTables.crops, where: 'id = ?', whereArgs: [id]);
  }

  /// Total number of distinct crop records.
  Future<int> countAll() async {
    final db = await _provider.database;
    final result =
        await db.rawQuery('SELECT COUNT(*) AS count FROM ${DBTables.crops}');
    return (result.first['count'] as int?) ?? 0;
  }

  /// Total planted area (acres) across all active (non-failed) crops.
  Future<double> totalActiveArea() async {
    final db = await _provider.database;
    final result = await db.rawQuery(
      '''SELECT SUM(area_planted) AS total FROM ${DBTables.crops}
         WHERE status != ?''',
      [CropStatus.failed],
    );
    return (result.first['total'] as num?)?.toDouble() ?? 0.0;
  }

  Future<int> countByStatus(String status) async {
    final db = await _provider.database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) AS count FROM ${DBTables.crops} WHERE status = ?',
      [status],
    );
    return (result.first['count'] as int?) ?? 0;
  }
}
