import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../app/theme/app_theme.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/custom_text_field.dart';
import '../../core/widgets/empty_state_widget.dart';
import '../../core/constants/app_constants.dart';
import 'crop_controller.dart';

class CropFormView extends GetView<CropController> {
  const CropFormView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Obx(() => Text(
            controller.isEditing ? 'Edit Crop Record' : 'New Crop Record')),
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
            // Crop Info
            FormCard(
              title: 'CROP INFORMATION',
              children: [
                Obx(() => AppDropdownField<String>(
                      label: 'Crop Type *',
                      value: controller.selectedCropType.value,
                      items: AppConstants.cropTypes,
                      itemLabel: (e) => e,
                      onChanged: (v) =>
                          controller.selectedCropType.value = v!,
                      prefixIcon: Icons.grass_rounded,
                      validator: (v) =>
                          v == null ? 'Select a crop type' : null,
                    )),
                const SizedBox(height: 14),
                AppTextField(
                  label: 'Seed Variety',
                  hint: 'e.g. SWAM1, TME419',
                  controller: controller.seedVarietyCtrl,
                  prefixIcon: Icons.spa_outlined,
                  textCapitalization: TextCapitalization.words,
                ),
                const SizedBox(height: 14),
                AppTextField(
                  label: 'Area Cultivated (ha) *',
                  hint: 'e.g. 10.5',
                  controller: controller.areaCtrl,
                  prefixIcon: Icons.straighten_rounded,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^\d+\.?\d{0,2}'))
                  ],
                  validator: controller.validateArea,
                ),
                const SizedBox(height: 14),
                Obx(() => AppDropdownField<String>(
                      label: 'Season *',
                      value: controller.selectedSeason.value,
                      items: AppConstants.seasons,
                      itemLabel: (e) => e,
                      onChanged: (v) =>
                          controller.selectedSeason.value = v!,
                      prefixIcon: Icons.wb_sunny_outlined,
                    )),
              ],
            ),

            // Planting Details
            FormCard(
              title: 'PLANTING DETAILS',
              children: [
                DatePickerField(
                  label: 'Date Planted *',
                  controller: controller.datePlantedCtrl,
                  validator: controller.validateDate,
                  lastDate: DateTime.now()
                      .add(const Duration(days: 30)),
                ),
                const SizedBox(height: 14),
                AppTextField(
                  label: 'Fertilizer Used',
                  hint: 'e.g. NPK 20kg, Urea 10kg',
                  controller: controller.fertilizerCtrl,
                  prefixIcon: Icons.science_outlined,
                  textCapitalization: TextCapitalization.sentences,
                ),
              ],
            ),

            // Yield
            FormCard(
              title: 'YIELD INFORMATION',
              children: [
                AppTextField(
                  label: 'Expected Yield (kg)',
                  hint: 'e.g. 12000',
                  controller: controller.expectedYieldCtrl,
                  prefixIcon: Icons.trending_up_rounded,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly
                  ],
                ),
                const SizedBox(height: 14),
                AppTextField(
                  label: 'Actual Yield (kg)',
                  hint: 'Fill after harvest',
                  controller: controller.actualYieldCtrl,
                  prefixIcon: Icons.inventory_2_outlined,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly
                  ],
                ),
              ],
            ),

            // Status & Notes
            FormCard(
              title: 'STATUS & NOTES',
              children: [
                Obx(() => AppDropdownField<String>(
                      label: 'Crop Status *',
                      value: controller.selectedCropStatus.value,
                      items: AppConstants.cropStatuses,
                      itemLabel: (e) => e,
                      onChanged: (v) =>
                          controller.selectedCropStatus.value = v!,
                      prefixIcon: Icons.flag_outlined,
                    )),
                const SizedBox(height: 14),
                AppTextField(
                  label: 'Notes',
                  hint: 'Any additional observations…',
                  controller: controller.notesCtrl,
                  prefixIcon: Icons.notes_rounded,
                  maxLines: 3,
                  textCapitalization: TextCapitalization.sentences,
                ),
              ],
            ),

            // Save button
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Obx(() => PrimaryButton(
                    label: controller.isEditing
                        ? 'Update Record'
                        : 'Save Crop Record',
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
