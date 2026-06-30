import '../../core/constants/app_constants.dart';
import '../../core/database/database_helper.dart';
import '../models/expense_model.dart';

class ExpenseRepository {
  final _db = DatabaseHelper.instance;

  Future<List<ExpenseModel>> getAll(int farmId) async {
    final maps = await _db.queryWhere(
      AppConstants.tblExpenses,
      where: 'farm_id = ?',
      whereArgs: [farmId],
      orderBy: 'transaction_date DESC',
    );
    return maps.map(ExpenseModel.fromMap).toList();
  }

  Future<List<ExpenseModel>> getByType(int farmId, String type) async {
    final maps = await _db.queryWhere(
      AppConstants.tblExpenses,
      where: 'farm_id = ? AND type = ?',
      whereArgs: [farmId, type],
      orderBy: 'transaction_date DESC',
    );
    return maps.map(ExpenseModel.fromMap).toList();
  }

  Future<ExpenseModel?> getById(int id) async {
    final m = await _db.queryById(AppConstants.tblExpenses, id);
    return m != null ? ExpenseModel.fromMap(m) : null;
  }

  Future<int> create(ExpenseModel expense) async =>
      _db.insert(AppConstants.tblExpenses, expense.toMap());

  Future<int> update(ExpenseModel expense) async =>
      _db.update(AppConstants.tblExpenses, expense.toMap(), expense.id!);

  Future<int> delete(int id) async =>
      _db.delete(AppConstants.tblExpenses, id);

  // ── Financial stats ────────────────────────────────────────────────────────
  Future<Map<String, dynamic>> getSummary(int farmId) async {
    final rows = await _db.rawQuery('''
      SELECT
        SUM(CASE WHEN type = 'Income'  THEN amount ELSE 0 END) AS total_income,
        SUM(CASE WHEN type = 'Expense' THEN amount ELSE 0 END) AS total_expense,
        COUNT(*) AS total_transactions
      FROM ${AppConstants.tblExpenses}
      WHERE farm_id = ?
    ''', [farmId]);
    return rows.isNotEmpty ? rows.first : {};
  }

  Future<List<Map<String, dynamic>>> getExpenseByCategory(int farmId) async {
    return _db.rawQuery('''
      SELECT category,
             SUM(amount) AS total,
             COUNT(*) AS count
      FROM ${AppConstants.tblExpenses}
      WHERE farm_id = ? AND type = 'Expense'
      GROUP BY category
      ORDER BY total DESC
    ''', [farmId]);
  }

  Future<List<Map<String, dynamic>>> getMonthlyFlow(int farmId) async {
    return _db.rawQuery('''
      SELECT
        strftime('%Y-%m', transaction_date) AS month,
        SUM(CASE WHEN type = 'Income'  THEN amount ELSE 0 END) AS income,
        SUM(CASE WHEN type = 'Expense' THEN amount ELSE 0 END) AS expense
      FROM ${AppConstants.tblExpenses}
      WHERE farm_id = ?
      GROUP BY month
      ORDER BY month ASC
      LIMIT 6
    ''', [farmId]);
  }
}
