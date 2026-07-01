import '../../utils/constants.dart';
import '../models/task_model.dart';
import '../providers/database_provider.dart';

/// Handles all CRUD operations for farm activity/task records.
class TaskRepository {
  final DatabaseProvider _provider = DatabaseProvider.instance;

  Future<List<FarmTask>> getAll() async {
    final db = await _provider.database;
    final results = await db.query(DBTables.tasks, orderBy: 'due_date ASC');
    return results.map((e) => FarmTask.fromMap(e)).toList();
  }

  Future<int> create(FarmTask task) async {
    final db = await _provider.database;
    return db.insert(DBTables.tasks, task.toMap());
  }

  Future<int> update(FarmTask task) async {
    final db = await _provider.database;
    return db.update(
      DBTables.tasks,
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await _provider.database;
    return db.delete(DBTables.tasks, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> countPending() async {
    final db = await _provider.database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) AS count FROM ${DBTables.tasks} WHERE status != ?',
      [TaskStatus.completed],
    );
    return (result.first['count'] as int?) ?? 0;
  }
}
