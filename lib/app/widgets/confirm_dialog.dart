import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../theme/app_theme.dart';

/// Shows a standard confirmation dialog (e.g. for delete actions) and
/// returns `true` if the user confirmed, `false`/`null` otherwise.
Future<bool?> showConfirmDialog({
  required String title,
  required String message,
  String confirmLabel = 'Delete',
  bool danger = true,
}) {
  return Get.dialog<bool>(
    AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Get.back(result: false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Get.back(result: true),
          style: TextButton.styleFrom(
            foregroundColor: danger ? AppColors.danger : AppColors.primary,
          ),
          child: Text(confirmLabel),
        ),
      ],
    ),
  );
}
