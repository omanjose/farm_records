import 'package:crypto/crypto.dart';
import 'dart:convert';
import '../../core/constants/app_constants.dart';
import '../../core/database/database_helper.dart';
import '../models/user_model.dart';

class UserRepository {
  final _db = DatabaseHelper.instance;

  String hashPassword(String password) {
    final bytes = utf8.encode(password);
    return sha256.convert(bytes).toString();
  }

  Future<UserModel?> authenticate(String username, String password) async {
    final hash = hashPassword(password);
    final results = await _db.queryWhere(
      AppConstants.tblUsers,
      where: 'username = ? AND password_hash = ?',
      whereArgs: [username.toLowerCase().trim(), hash],
    );
    if (results.isEmpty) return null;
    return UserModel.fromMap(results.first);
  }

  Future<List<UserModel>> getAll() async {
    final maps = await _db.queryAll(AppConstants.tblUsers,
        orderBy: 'full_name ASC');
    return maps.map(UserModel.fromMap).toList();
  }

  Future<UserModel?> getById(int id) async {
    final m = await _db.queryById(AppConstants.tblUsers, id);
    return m != null ? UserModel.fromMap(m) : null;
  }

  Future<bool> usernameExists(String username, {int? excludeId}) async {
    final results = await _db.queryWhere(
      AppConstants.tblUsers,
      where: excludeId != null ? 'username = ? AND id != ?' : 'username = ?',
      whereArgs:
          excludeId != null ? [username.toLowerCase().trim(), excludeId] : [username.toLowerCase().trim()],
    );
    return results.isNotEmpty;
  }

  Future<int> create(UserModel user) async {
    final map = user.toMap();
    map['username'] = (map['username'] as String).toLowerCase().trim();
    return _db.insert(AppConstants.tblUsers, map);
  }

  Future<int> update(UserModel user) async =>
      _db.update(AppConstants.tblUsers, user.toMap(), user.id!);

  Future<int> changePassword(int userId, String newPassword) async {
    return _db.update(
      AppConstants.tblUsers,
      {'password_hash': hashPassword(newPassword)},
      userId,
    );
  }

  Future<int> delete(int id) async =>
      _db.delete(AppConstants.tblUsers, id);
}
