import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../app/theme/app_theme.dart';
import '../../core/constants/app_constants.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/custom_text_field.dart';
import '../../core/widgets/empty_state_widget.dart';
import 'livestock_controller.dart';

class LivestockFormView extends GetView<LivestockController> {
  const LivestockFormView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Obx(() => Text(controller.isEditing
            ? 'Edit Livestock'
            : 'Add Livestock')),
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
            FormCard(
              title: 'ANIMAL INFORMATION',
              children: [
                Obx(() => AppDropdownField<String>(
                      label: 'Animal Type *',
                      value: controller.selectedAnimalType.value,
                      items: AppConstants.animalTypes,
                      itemLabel: (e) => e,
                      onChanged: (v) =>
                          controller.selectedAnimalType.value = v!,
                      prefixIcon: Icons.pets_rounded,
                      validator: (v) =>
                          v == null ? 'Select an animal type' : null,
                    )),
                const SizedBox(height: 14),
                AppTextField(
                  label: 'Breed',
                  hint: 'e.g. Bunaji, Noiler, Large White',
                  controller: controller.breedCtrl,
                  prefixIcon: Icons.category_outlined,
                  textCapitalization: TextCapitalization.words,
                ),
                const SizedBox(height: 14),
                AppTextField(
                  label: 'Quantity *',
                  hint: 'Number of animals',
                  controller: controller.quantityCtrl,
                  prefixIcon: Icons.numbers_rounded,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  validator: controller.validateQuantity,
                ),
              ],
            ),
            FormCard(
              title: 'HEALTH & VACCINATION',
              children: [
                Obx(() => AppDropdownField<String>(
                      label: 'Health Status *',
                      value: controller.selectedHealthStatus.value,
                      items: AppConstants.healthStatuses,
                      itemLabel: (e) => e,
                      onChanged: (v) =>
                          controller.selectedHealthStatus.value = v!,
                      prefixIcon: Icons.health_and_safety_outlined,
                    )),
                const SizedBox(height: 14),
                DatePickerField(
                  label: 'Last Vaccination Date',
                  controller: controller.vaccinationDateCtrl,
                  lastDate: DateTime.now(),
                ),
                const SizedBox(height: 14),
                DatePickerField(
                  label: 'Next Vaccination Due',
                  controller: controller.nextVaccinationCtrl,
                  firstDate: DateTime.now(),
                  lastDate:
                      DateTime.now().add(const Duration(days: 730)),
                ),
              ],
            ),
            FormCard(
              title: 'NOTES',
              children: [
                AppTextField(
                  label: 'Notes',
                  hint:
                      'Health observations, feeding notes, etc.',
                  controller: controller.notesCtrl,
                  prefixIcon: Icons.notes_rounded,
                  maxLines: 3,
                  textCapitalization: TextCapitalization.sentences,
                ),
              ],
            ),
            Padding(
              padding:
                  const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Obx(() => PrimaryButton(
                    label: controller.isEditing
                        ? 'Update Record'
                        : 'Save Livestock Record',
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
