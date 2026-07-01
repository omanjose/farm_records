import '../../utils/constants.dart';
import '../models/farm_profile_model.dart';
import '../providers/database_provider.dart';

/// Handles persistence for the single farm profile record.
class FarmRepository {
  final DatabaseProvider _provider = DatabaseProvider.instance;

  Future<FarmProfile?> getProfile() async {
    final db = await _provider.database;
    final results = await db.query(DBTables.farmProfile, limit: 1);
    if (results.isEmpty) return null;
    return FarmProfile.fromMap(results.first);
  }

  Future<int> saveProfile(FarmProfile profile) async {
    final db = await _provider.database;
    if (profile.id == null) {
      return db.insert(DBTables.farmProfile, profile.toMap());
    } else {
      return db.update(
        DBTables.farmProfile,
        profile.toMap(),
        where: 'id = ?',
        whereArgs: [profile.id],
      );
    }
  }
}
