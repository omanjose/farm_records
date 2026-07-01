import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../theme/app_theme.dart';
import '../../../utils/constants.dart';
import '../../../utils/formatters.dart';
import '../../../utils/validators.dart';
import '../../../widgets/custom_dropdown.dart';
import '../../../widgets/custom_text_field.dart';
import '../controllers/crops_controller.dart';

class CropFormView extends GetView<CropsController> {
  const CropFormView({super.key});

  Future<void> _pickDate(
    BuildContext context,
    Rx<DateTime?> target, {
    DateTime? initial,
  }) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: initial ?? DateTime.now(),
      firstDate: DateTime(2015),
      lastDate: DateTime(2100),
    );
    if (picked != null) target.value = picked;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(controller.isEditing ? 'Edit Crop Record' : 'Add Crop Record'),
      ),
      body: Form(
        key: controller.formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 30),
          children: [
            CustomTextField(
              controller: controller.cropNameCtrl,
              label: 'Crop Name *',
              hint: 'e.g. Maize',
              validator: (v) => Validators.required(v, field: 'Crop name'),
            ),
            const SizedBox(height: 14),
            CustomTextField(
              controller: controller.varietyCtrl,
              label: 'Variety (optional)',
            ),
            const SizedBox(height: 14),
            CustomTextField(
              controller: controller.fieldLocationCtrl,
              label: 'Field / Plot Location (optional)',
            ),
            const SizedBox(height: 14),
            CustomTextField(
              controller: controller.areaPlantedCtrl,
              label: 'Area Planted (acres) *',
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: (v) => Validators.positiveNumber(v, field: 'Area planted'),
            ),
            const SizedBox(height: 14),
            Obx(
              () => CustomDropdown<String>(
                value: controller.status.value,
                label: 'Status',
                items: CropStatus.all,
                itemLabel: (v) => v,
                onChanged: (v) => controller.status.value = v ?? controller.status.value,
              ),
            ),
            const SizedBox(height: 14),
            Obx(
              () => _DateTile(
                label: 'Planting Date *',
                date: controller.plantingDate.value,
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: controller.plantingDate.value,
                    firstDate: DateTime(2015),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) controller.plantingDate.value = picked;
                },
              ),
            ),
            const SizedBox(height: 14),
            Obx(
              () => _DateTile(
                label: 'Expected Harvest Date (optional)',
                date: controller.expectedHarvestDate.value,
                onTap: () => _pickDate(
                  context,
                  controller.expectedHarvestDate,
                  initial: controller.expectedHarvestDate.value,
                ),
                onClear: controller.expectedHarvestDate.value != null
                    ? () => controller.expectedHarvestDate.value = null
                    : null,
              ),
            ),
            const SizedBox(height: 14),
            Obx(
              () => _DateTile(
                label: 'Actual Harvest Date (optional)',
                date: controller.actualHarvestDate.value,
                onTap: () => _pickDate(
                  context,
                  controller.actualHarvestDate,
                  initial: controller.actualHarvestDate.value,
                ),
                onClear: controller.actualHarvestDate.value != null
                    ? () => controller.actualHarvestDate.value = null
                    : null,
              ),
            ),
            const SizedBox(height: 14),
            CustomTextField(
              controller: controller.expectedYieldCtrl,
              label: 'Expected Yield (kg, optional)',
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: (v) => Validators.optionalNumber(v, field: 'Expected yield'),
            ),
            const SizedBox(height: 14),
            CustomTextField(
              controller: controller.actualYieldCtrl,
              label: 'Actual Yield (kg, optional)',
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: (v) => Validators.optionalNumber(v, field: 'Actual yield'),
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
                        ? 'Crop record updated successfully.'
                        : 'Crop record added successfully.',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                }
              },
              child: const Text('Save Crop Record'),
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
