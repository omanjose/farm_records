import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../theme/app_theme.dart';
import '../../../utils/constants.dart';
import '../../../utils/formatters.dart';
import '../../../utils/validators.dart';
import '../../../widgets/custom_dropdown.dart';
import '../../../widgets/custom_text_field.dart';
import '../controllers/finance_controller.dart';

class FinanceFormView extends GetView<FinanceController> {
  const FinanceFormView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(controller.isEditing ? 'Edit Transaction' : 'Add Transaction'),
      ),
      body: Form(
        key: controller.formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 30),
          children: [
            Obx(
              () => Row(
                children: TransactionType.all.map((t) {
                  final selected = controller.type.value == t;
                  final color =
                      t == TransactionType.income ? AppColors.primary : AppColors.danger;
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        right: t == TransactionType.all.first ? 8 : 0,
                      ),
                      child: GestureDetector(
                        onTap: () => controller.switchType(t),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            color: selected ? color.withOpacity(0.12) : AppColors.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: selected ? color : AppColors.divider,
                              width: selected ? 1.6 : 1,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              t,
                              style: TextStyle(
                                color: selected ? color : AppColors.textSecondary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),
            Obx(
              () => CustomDropdown<String>(
                value: controller.category.value,
                label: 'Category',
                items: controller.categoryOptions,
                itemLabel: (v) => v,
                onChanged: (v) => controller.category.value = v ?? controller.category.value,
              ),
            ),
            const SizedBox(height: 14),
            CustomTextField(
              controller: controller.amountCtrl,
              label: 'Amount (₦) *',
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: (v) => Validators.positiveNumber(v, field: 'Amount'),
            ),
            const SizedBox(height: 14),
            Obx(
              () => InkWell(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: controller.date.value,
                    firstDate: DateTime(2015),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) controller.date.value = picked;
                },
                borderRadius: BorderRadius.circular(12),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Date',
                    suffixIcon: Icon(Icons.calendar_today_outlined, size: 18),
                  ),
                  child: Text(
                    AppFormatters.displayDate(
                      AppFormatters.toStorageDate(controller.date.value),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),
            CustomTextField(
              controller: controller.descriptionCtrl,
              label: 'Description (optional)',
              maxLines: 3,
            ),
            const SizedBox(height: 28),
            ElevatedButton(
              onPressed: () async {
                final success = await controller.submit();
                if (success) {
                  Get.back();
                  Get.snackbar(
                    'Saved',
                    controller.isEditing
                        ? 'Transaction updated successfully.'
                        : 'Transaction recorded successfully.',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                }
              },
              child: const Text('Save Transaction'),
            ),
          ],
        ),
      ),
    );
  }
}
