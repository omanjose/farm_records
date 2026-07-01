import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../theme/app_theme.dart';
import '../../../utils/constants.dart';
import '../../../utils/formatters.dart';
import '../../../utils/validators.dart';
import '../../../widgets/custom_dropdown.dart';
import '../../../widgets/custom_text_field.dart';
import '../controllers/livestock_controller.dart';

class LivestockFormView extends GetView<LivestockController> {
  const LivestockFormView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(controller.isEditing ? 'Edit Livestock Record' : 'Add Livestock Record'),
      ),
      body: Form(
        key: controller.formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 30),
          children: [
            CustomTextField(
              controller: controller.animalTypeCtrl,
              label: 'Animal Type *',
              hint: 'e.g. Poultry, Goat, Cattle',
              validator: (v) => Validators.required(v, field: 'Animal type'),
            ),
            const SizedBox(height: 14),
            CustomTextField(
              controller: controller.breedCtrl,
              label: 'Breed (optional)',
            ),
            const SizedBox(height: 14),
            CustomTextField(
              controller: controller.tagIdCtrl,
              label: 'Tag / Batch ID (optional)',
            ),
            const SizedBox(height: 14),
            CustomTextField(
              controller: controller.quantityCtrl,
              label: 'Quantity (head count) *',
              keyboardType: TextInputType.number,
              validator: (v) => Validators.integer(v, field: 'Quantity'),
            ),
            const SizedBox(height: 14),
            Obx(
              () => CustomDropdown<String>(
                value: controller.gender.value,
                label: 'Gender / Composition',
                items: const ['Male', 'Female', 'Mixed'],
                itemLabel: (v) => v,
                onChanged: (v) => controller.gender.value = v ?? controller.gender.value,
              ),
            ),
            const SizedBox(height: 14),
            CustomTextField(
              controller: controller.weightCtrl,
              label: 'Average Weight (kg, optional)',
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: (v) => Validators.optionalNumber(v, field: 'Weight'),
            ),
            const SizedBox(height: 14),
            Obx(
              () => CustomDropdown<String>(
                value: controller.healthStatus.value,
                label: 'Health Status',
                items: HealthStatus.all,
                itemLabel: (v) => v,
                onChanged: (v) =>
                    controller.healthStatus.value = v ?? controller.healthStatus.value,
              ),
            ),
            const SizedBox(height: 14),
            Obx(
              () => _DateTile(
                label: 'Date Acquired *',
                date: controller.dateAcquired.value,
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: controller.dateAcquired.value,
                    firstDate: DateTime(2015),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) controller.dateAcquired.value = picked;
                },
              ),
            ),
            const SizedBox(height: 14),
            Obx(
              () => _DateTile(
                label: 'Last Vaccination Date (optional)',
                date: controller.lastVaccinationDate.value,
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: controller.lastVaccinationDate.value ?? DateTime.now(),
                    firstDate: DateTime(2015),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) controller.lastVaccinationDate.value = picked;
                },
                onClear: controller.lastVaccinationDate.value != null
                    ? () => controller.lastVaccinationDate.value = null
                    : null,
              ),
            ),
            const SizedBox(height: 14),
            CustomTextField(
              controller: controller.notesCtrl,
              label: 'Notes (optional)',
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
                        ? 'Livestock record updated successfully.'
                        : 'Livestock record added successfully.',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                }
              },
              child: const Text('Save Livestock Record'),
            ),
          ],
        ),
      ),
    );
  }
}

class _DateTile extends StatelessWidget {
  final String label;
  final DateTime? date;
  final VoidCallback onTap;
  final VoidCallback? onClear;

  const _DateTile({
    required this.label,
    required this.date,
    required this.onTap,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          suffixIcon: onClear != null
              ? IconButton(icon: const Icon(Icons.clear, size: 18), onPressed: onClear)
              : const Icon(Icons.calendar_today_outlined, size: 18),
        ),
        child: Text(
          date != null ? AppFormatters.displayDate(AppFormatters.toStorageDate(date!)) : 'Select date',
          style: TextStyle(
            color: date != null ? AppColors.textPrimary : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
