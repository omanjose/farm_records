import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../app/theme/app_theme.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/custom_text_field.dart';
import '../../core/widgets/empty_state_widget.dart';
import 'finance_controller.dart';

class FinanceFormView extends GetView<FinanceController> {
  const FinanceFormView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Obx(() => Text(controller.isEditing
            ? 'Edit Transaction'
            : 'New Transaction')),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Get.back(),
        ),
      ),
      body: Form(
        key: controller.formKey,
        child: ListView(
          padding: const EdgeInsets.only(bottom: 100),
          children: [
            // Type selector
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Obx(() => Row(
                    children: [
                      Expanded(
                        child: _TypeButton(
                          label: 'Expense',
                          icon: Icons.arrow_upward_rounded,
                          color: AppColors.orange,
                          isSelected:
                              controller.selectedType.value == 'Expense',
                          onTap: () =>
                              controller.onTypeChanged('Expense'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _TypeButton(
                          label: 'Income',
                          icon: Icons.arrow_downward_rounded,
                          color: const Color(0xFF2E7D32),
                          isSelected:
                              controller.selectedType.value == 'Income',
                          onTap: () =>
                              controller.onTypeChanged('Income'),
                        ),
                      ),
                    ],
                  )),
            ),

            FormCard(
              title: 'TRANSACTION DETAILS',
              children: [
                Obx(() => AppDropdownField<String>(
                      label: 'Category *',
                      value: controller.categoryOptions
                              .contains(controller.selectedCategory.value)
                          ? controller.selectedCategory.value
                          : controller.categoryOptions.first,
                      items: controller.categoryOptions,
                      itemLabel: (e) => e,
                      onChanged: (v) =>
                          controller.selectedCategory.value = v!,
                      prefixIcon: Icons.label_outline,
                      validator: (v) =>
                          v == null ? 'Select a category' : null,
                    )),
                const SizedBox(height: 14),
                AppTextField(
                  label: 'Amount (₦) *',
                  hint: 'e.g. 50000',
                  controller: controller.amountCtrl,
                  prefixIcon: Icons.payments_outlined,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^\d+\.?\d{0,2}'))
                  ],
                  validator: controller.validateAmount,
                ),
                const SizedBox(height: 14),
                DatePickerField(
                  label: 'Transaction Date *',
                  controller: controller.dateCtrl,
                  validator: controller.validateDate,
                  lastDate:
                      DateTime.now().add(const Duration(days: 7)),
                ),
              ],
            ),

            FormCard(
              title: 'DESCRIPTION',
              children: [
                AppTextField(
                  label: 'Description',
                  hint: 'What was this transaction for?',
                  controller: controller.descriptionCtrl,
                  prefixIcon: Icons.notes_rounded,
                  maxLines: 3,
                  textCapitalization: TextCapitalization.sentences,
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Obx(() => PrimaryButton(
                    label: controller.isEditing
                        ? 'Update Transaction'
                        : 'Save Transaction',
                    onPressed: controller.save,
                    isLoading: controller.isSaving.value,
                    icon: Icons.save_rounded,
                  )),
            ),
          ],
        ),
      ),
    );
  }
}

class _TypeButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _TypeButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: isSelected ? color : AppColors.divider, width: 2),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                      color: color.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4))
                ]
              : [],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon,
                color: isSelected ? Colors.white : color, size: 20),
            const SizedBox(width: 8),
            Text(label,
                style: TextStyle(
                    color: isSelected ? Colors.white : color,
                    fontWeight: FontWeight.bold,
                    fontSize: 15)),
          ],
        ),
      ),
    );
  }
}
