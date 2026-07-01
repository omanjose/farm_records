import 'package:flutter/material.dart';

/// A styled dropdown form field used across all record forms for
/// selecting from a fixed list of options (status, category, etc).
class CustomDropdown<T> extends StatelessWidget {
  final T? value;
  final String label;
  final List<T> items;
  final String Function(T) itemLabel;
  final void Function(T?) onChanged;
  final String? Function(T?)? validator;

  const CustomDropdown({
    super.key,
    required this.value,
    required this.label,
    required this.items,
    required this.itemLabel,
    required this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: value,
      decoration: InputDecoration(labelText: label),
      isExpanded: true,
      items: items
          .map(
            (item) => DropdownMenuItem<T>(
              value: item,
              child: Text(itemLabel(item)),
            ),
          )
          .toList(),
      onChanged: onChanged,
      validator: validator,
    );
  }
}
