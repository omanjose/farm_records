import '../../core/constants/app_constants.dart';
import '../../core/database/database_helper.dart';
import '../models/livestock_model.dart';

class LivestockRepository {
  final _db = DatabaseHelper.instance;

  Future<List<LivestockModel>> getAll(int farmId) async {
    final maps = await _db.queryWhere(
      AppConstants.tblLivestock,
      where: 'farm_id = ?',
      whereArgs: [farmId],
      orderBy: 'animal_type ASC',
    );
    return maps.map(LivestockModel.fromMap).toList();
  }

  Future<LivestockModel?> getById(int id) async {
    final m = await _db.queryById(AppConstants.tblLivestock, id);
    return m != null ? LivestockModel.fromMap(m) : null;
  }

  Future<int> create(LivestockModel livestock) async =>
      _db.insert(AppConstants.tblLivestock, livestock.toMap());

  Future<int> update(LivestockModel livestock) async =>
      _db.update(AppConstants.tblLivestock, livestock.toMap(), livestock.id!);

  Future<int> delete(int id) async =>
      _db.delete(AppConstants.tblLivestock, id);

  // ── Stats ──────────────────────────────────────────────────────────────────
  Future<Map<String, dynamic>> getStats(int farmId) async {
    final rows = await _db.rawQuery('''
      SELECT
        COUNT(*) AS types,
        SUM(quantity) AS total,
        COUNT(CASE WHEN health_status = 'Healthy' THEN 1 END) AS healthy,
        COUNT(CASE WHEN health_status != 'Healthy' THEN 1 END) AS attention
      FROM ${AppConstants.tblLivestock}
      WHERE farm_id = ?
    ''', [farmId]);
    return rows.isNotEmpty ? rows.first : {};
  }

  Future<List<Map<String, dynamic>>> getByAnimalType(int farmId) async {
    return _db.rawQuery('''
      SELECT animal_type,
             SUM(quantity) AS total,
             COUNT(*) AS records
      FROM ${AppConstants.tblLivestock}
      WHERE farm_id = ?
      GROUP BY animal_type
      ORDER BY total DESC
    ''', [farmId]);
  }

  Future<List<LivestockModel>> getOverdueVaccinations(int farmId) async {
    final today = DateTime.now().toIso8601String().substring(0, 10);
    final maps = await _db.queryWhere(
      AppConstants.tblLivestock,
      where: 'farm_id = ? AND next_vaccination < ?',
      whereArgs: [farmId, today],
    );
    return maps.map(LivestockModel.fromMap).toList();
  }
}
