import '../../utils/constants.dart';
import '../models/transaction_model.dart';
import '../providers/database_provider.dart';

/// Handles all CRUD and aggregate queries for financial transactions.
class TransactionRepository {
  final DatabaseProvider _provider = DatabaseProvider.instance;

  Future<List<FarmTransaction>> getAll() async {
    final db = await _provider.database;
    final results = await db.query(
      DBTables.transactions,
      orderBy: 'date DESC',
    );
    return results.map((e) => FarmTransaction.fromMap(e)).toList();
  }

  Future<int> create(FarmTransaction tx) async {
    final db = await _provider.database;
    return db.insert(DBTables.transactions, tx.toMap());
  }

  Future<int> update(FarmTransaction tx) async {
    final db = await _provider.database;
    return db.update(
      DBTables.transactions,
      tx.toMap(),
      where: 'id = ?',
      whereArgs: [tx.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await _provider.database;
    return db.delete(DBTables.transactions, where: 'id = ?', whereArgs: [id]);
  }

  Future<double> totalByType(String type) async {
    final db = await _provider.database;
    final result = await db.rawQuery(
      'SELECT SUM(amount) AS total FROM ${DBTables.transactions} WHERE type = ?',
      [type],
    );
    return (result.first['total'] as num?)?.toDouble() ?? 0.0;
  }

  Future<double> netBalance() async {
    final income = await totalByType(TransactionType.income);
    final expense = await totalByType(TransactionType.expense);
    return income - expense;
  }

  /// Aggregated totals grouped by category, for a given transaction type.
  Future<Map<String, double>> totalsByCategory(String type) async {
    final db = await _provider.database;
    final results = await db.rawQuery(
      '''SELECT category, SUM(amount) AS total FROM ${DBTables.transactions}
         WHERE type = ? GROUP BY category ORDER BY total DESC''',
      [type],
    );
    return {
      for (final row in results)
        row['category'] as String: (row['total'] as num).toDouble(),
    };
  }
}
