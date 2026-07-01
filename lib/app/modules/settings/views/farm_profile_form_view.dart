import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/validators.dart';
import '../../../widgets/custom_text_field.dart';
import '../controllers/settings_controller.dart';

class FarmProfileFormView extends GetView<SettingsController> {
  const FarmProfileFormView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Farm Profile')),
      body: Form(
        key: controller.formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 30),
          children: [
            CustomTextField(
              controller: controller.farmNameCtrl,
              label: 'Farm Name *',
              validator: (v) => Validators.required(v, field: 'Farm name'),
            ),
            const SizedBox(height: 14),
            CustomTextField(
              controller: controller.ownerNameCtrl,
              label: 'Owner / Manager Name *',
              validator: (v) => Validators.required(v, field: 'Owner name'),
            ),
            const SizedBox(height: 14),
            CustomTextField(
              controller: controller.locationCtrl,
              label: 'Farm Location *',
              validator: (v) => Validators.required(v, field: 'Location'),
            ),
            const SizedBox(height: 14),
            CustomTextField(
              controller: controller.phoneCtrl,
              label: 'Phone Number (optional)',
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 14),
            CustomTextField(
              controller: controller.emailCtrl,
              label: 'Email (optional)',
              keyboardType: TextInputType.emailAddress,
              validator: controller.validateEmail,
            ),
            const SizedBox(height: 14),
            CustomTextField(
              controller: controller.farmSizeCtrl,
              label: 'Total Farm Size (acres, optional)',
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: (v) => Validators.optionalNumber(v, field: 'Farm size'),
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
                    'Farm profile updated successfully.',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                }
              },
              child: const Text('Save Farm Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
