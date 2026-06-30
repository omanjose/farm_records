import 'package:intl/intl.dart';

abstract class AppDateUtils {
  static final _displayFmt = DateFormat('dd MMM yyyy');
  static final _dbFmt = DateFormat('yyyy-MM-dd');
  static final _monthFmt = DateFormat('MMM yyyy');
  static final _currencyFmt = NumberFormat('#,##0.00', 'en_NG');
  static final _compactFmt = NumberFormat('#,##0', 'en_NG');

  static String toDisplay(String? dbDate) {
    if (dbDate == null || dbDate.isEmpty) return '—';
    try {
      return _displayFmt.format(DateTime.parse(dbDate));
    } catch (_) {
      return dbDate;
    }
  }

  static String toDb(DateTime date) => _dbFmt.format(date);

  static DateTime? fromDb(String? dbDate) {
    if (dbDate == null || dbDate.isEmpty) return null;
    try {
      return DateTime.parse(dbDate);
    } catch (_) {
      return null;
    }
  }

  static String toMonth(String? dbDate) {
    if (dbDate == null || dbDate.isEmpty) return '—';
    try {
      return _monthFmt.format(DateTime.parse(dbDate));
    } catch (_) {
      return dbDate;
    }
  }

  static String today() => _dbFmt.format(DateTime.now());

  static String formatCurrency(double amount) =>
      '₦${_currencyFmt.format(amount)}';

  static String formatCompact(double amount) =>
      '₦${_compactFmt.format(amount)}';

  static String formatNumber(num value) => _compactFmt.format(value);

  static bool isOverdue(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return false;
    final date = DateTime.tryParse(dateStr);
    if (date == null) return false;
    return date.isBefore(DateTime.now());
  }

  static int daysBetween(String fromDate, String toDate) {
    final from = DateTime.tryParse(fromDate);
    final to = DateTime.tryParse(toDate);
    if (from == null || to == null) return 0;
    return to.difference(from).inDays;
  }
}
