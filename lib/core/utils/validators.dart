abstract class Validators {
  static String? required(String? value, [String field = 'This field']) {
    if (value == null || value.trim().isEmpty) return '$field is required';
    return null;
  }

  static String? number(String? value, [String field = 'Value']) {
    if (value == null || value.trim().isEmpty) return '$field is required';
    if (double.tryParse(value) == null) return '$field must be a valid number';
    if (double.parse(value) < 0) return '$field must be positive';
    return null;
  }

  static String? positiveNumber(String? value, [String field = 'Value']) {
    final base = number(value, field);
    if (base != null) return base;
    if (double.parse(value!) <= 0) return '$field must be greater than zero';
    return null;
  }

  static String? integer(String? value, [String field = 'Value']) {
    if (value == null || value.trim().isEmpty) return '$field is required';
    if (int.tryParse(value) == null) return '$field must be a whole number';
    if (int.parse(value) <= 0) return '$field must be greater than zero';
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.isEmpty) return null; // optional
    final re = RegExp(r'^[\w\-\.]+@([\w\-]+\.)+[\w]{2,4}$');
    if (!re.hasMatch(value)) return 'Enter a valid email address';
    return null;
  }

  static String? minLength(String? value, int min, [String field = 'Field']) {
    if (value == null || value.length < min) {
      return '$field must be at least $min characters';
    }
    return null;
  }

  static String? username(String? value) {
    if (value == null || value.trim().isEmpty) return 'Username is required';
    if (value.length < 3) return 'Username must be at least 3 characters';
    final re = RegExp(r'^[a-zA-Z0-9_]+$');
    if (!re.hasMatch(value)) {
      return 'Only letters, numbers, and underscores allowed';
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (value.length < 6) return 'Password must be at least 6 characters';
    return null;
  }
}
