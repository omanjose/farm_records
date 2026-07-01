/// Reusable form-field validators used across all record-entry forms.
class Validators {
  static String? required(String? value, {String field = 'This field'}) {
    if (value == null || value.trim().isEmpty) {
      return '$field is required';
    }
    return null;
  }

  static String? number(String? value, {String field = 'Value'}) {
    if (value == null || value.trim().isEmpty) {
      return '$field is required';
    }
    if (double.tryParse(value.trim()) == null) {
      return '$field must be a valid number';
    }
    return null;
  }

  static String? positiveNumber(String? value, {String field = 'Value'}) {
    final baseError = number(value, field: field);
    if (baseError != null) return baseError;
    final parsed = double.parse(value!.trim());
    if (parsed <= 0) {
      return '$field must be greater than zero';
    }
    return null;
  }

  static String? optionalNumber(String? value, {String field = 'Value'}) {
    if (value == null || value.trim().isEmpty) return null;
    if (double.tryParse(value.trim()) == null) {
      return '$field must be a valid number';
    }
    return null;
  }

  static String? integer(String? value, {String field = 'Value'}) {
    if (value == null || value.trim().isEmpty) {
      return '$field is required';
    }
    if (int.tryParse(value.trim()) == null) {
      return '$field must be a whole number';
    }
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final regex = RegExp(r'^[\w.\-]+@([\w\-]+\.)+[\w\-]{2,4}$');
    if (!regex.hasMatch(value.trim())) {
      return 'Enter a valid email address';
    }
    return null;
  }
}
