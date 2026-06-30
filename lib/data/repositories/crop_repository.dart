import '../../core/constants/app_constants.dart';
import '../../core/database/database_helper.dart';
import '../models/crop_model.dart';

class CropRepository {
  final _db = DatabaseHelper.instance;

  Future<List<CropModel>> getAll(int farmId) async {
    final maps = await _db.queryWhere(
      AppConstants.tblCrops,
      where: 'farm_id = ?',
      whereArgs: [farmId],
      orderBy: 'date_planted DESC',
    );
    return maps.map(CropModel.fromMap).toList();
  }

  Future<List<CropModel>> getByStatus(int farmId, String status) async {
    final maps = await _db.queryWhere(
      AppConstants.tblCrops,
      where: 'farm_id = ? AND status = ?',
      whereArgs: [farmId, status],
      orderBy: 'date_planted DESC',
    );
    return maps.map(CropModel.fromMap).toList();
  }

  Future<CropModel?> getById(int id) async {
    final m = await _db.queryById(AppConstants.tblCrops, id);
    return m != null ? CropModel.fromMap(m) : null;
  }

  Future<int> create(CropModel crop) async =>
      _db.insert(AppConstants.tblCrops, crop.toMap());

  Future<int> update(CropModel crop) async =>
      _db.update(AppConstants.tblCrops, crop.toMap(), crop.id!);

  Future<int> delete(int id) async =>
      _db.delete(AppConstants.tblCrops, id);

  // ── Stats ──────────────────────────────────────────────────────────────────
  Future<Map<String, dynamic>> getStats(int farmId) async {
    final rows = await _db.rawQuery('''
      SELECT
        COUNT(*) AS total,
        SUM(area_ha) AS total_area,
        SUM(expected_yield_kg) AS expected_yield,
        SUM(actual_yield_kg) AS actual_yield,
        COUNT(CASE WHEN status = 'Growing' THEN 1 END) AS growing,
        COUNT(CASE WHEN status = 'Harvested' THEN 1 END) AS harvested
      FROM ${AppConstants.tblCrops}
      WHERE farm_id = ?
    ''', [farmId]);
    return rows.isNotEmpty ? rows.first : {};
  }

  Future<List<Map<String, dynamic>>> getYieldByCropType(int farmId) async {
    return _db.rawQuery('''
      SELECT crop_type,
             SUM(actual_yield_kg) AS total_yield,
             COUNT(*) AS count
      FROM ${AppConstants.tblCrops}
      WHERE farm_id = ? AND actual_yield_kg IS NOT NULL
      GROUP BY crop_type
      ORDER BY total_yield DESC
    ''', [farmId]);
  }
}
