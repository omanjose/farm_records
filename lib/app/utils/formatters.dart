import 'package:intl/intl.dart';

/// Centralized date/currency formatting helpers so display formats stay
/// consistent across every module in the app.
class AppFormatters {
  static final DateFormat _displayDate = DateFormat('dd MMM yyyy');
  static final DateFormat _storageDate = DateFormat('yyyy-MM-dd');
  static final NumberFormat _currency =
      NumberFormat.currency(locale: 'en_NG', symbol: '₦', decimalDigits: 2);
  static final NumberFormat _decimal = NumberFormat('#,##0.##');

  /// Formats an ISO 8601 date string (yyyy-MM-dd) for display, e.g. "01 Jul 2026".
  static String displayDate(String isoDate) {
    try {
      final parsed = DateTime.parse(isoDate);
      return _displayDate.format(parsed);
    } catch (_) {
      return isoDate;
    }
  }

  /// Converts a [DateTime] into the storage format used in the database.
  static String toStorageDate(DateTime date) {
    return _storageDate.format(date);
  }

  static String todayStorageDate() => toStorageDate(DateTime.now());

  static String nowTimestamp() => DateTime.now().toIso8601String();

  static String currency(double amount) => _currency.format(amount);

  static String decimal(double value) => _decimal.format(value);

  /// Returns the number of whole days between today and [isoDate].
  /// Negative values mean the date is in the past.
  static int daysFromToday(String isoDate) {
    try {
      final target = DateTime.parse(isoDate);
      final today = DateTime.now();
      final todayOnly = DateTime(today.year, today.month, today.day);
      final targetOnly = DateTime(target.year, target.month, target.day);
      return targetOnly.difference(todayOnly).inDays;
    } catch (_) {
      return 0;
    }
  }
}
