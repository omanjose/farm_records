import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/constants.dart';
import '../../../utils/formatters.dart';
import '../../../utils/validators.dart';
import '../../../widgets/custom_dropdown.dart';
import '../../../widgets/custom_text_field.dart';
import '../controllers/tasks_controller.dart';

class TaskFormView extends GetView<TasksController> {
  const TaskFormView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(controller.isEditing ? 'Edit Task' : 'Add Task'),
      ),
      body: Form(
        key: controller.formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 30),
          children: [
            CustomTextField(
              controller: controller.titleCtrl,
              label: 'Task Title *',
              hint: 'e.g. Apply fertilizer to Field A',
              validator: (v) => Validators.required(v, field: 'Task title'),
            ),
            const SizedBox(height: 14),
            Obx(
              () => CustomDropdown<String>(
                value: controller.category.value,
                label: 'Category',
                items: TaskCategories.all,
                itemLabel: (v) => v,
                onChanged: (v) => controller.category.value = v ?? controller.category.value,
              ),
            ),
            const SizedBox(height: 14),
            Obx(
              () => CustomDropdown<String>(
                value: controller.priority.value,
                label: 'Priority',
                items: TaskPriority.all,
                itemLabel: (v) => v,
                onChanged: (v) => controller.priority.value = v ?? controller.priority.value,
              ),
            ),
            const SizedBox(height: 14),
            Obx(
              () => CustomDropdown<String>(
                value: controller.status.value,
                label: 'Status',
                items: TaskStatus.all,
                itemLabel: (v) => v,
                onChanged: (v) => controller.status.value = v ?? controller.status.value,
              ),
            ),
            const SizedBox(height: 14),
            Obx(
              () => InkWell(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: controller.dueDate.value,
                    firstDate: DateTime(2015),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) controller.dueDate.value = picked;
                },
                borderRadius: BorderRadius.circular(12),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Due Date',
                    suffixIcon: Icon(Icons.calendar_today_outlined, size: 18),
                  ),
                  child: Text(
                    AppFormatters.displayDate(
                      AppFormatters.toStorageDate(controller.dueDate.value),
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
                    controller.isEditing ? 'Task updated successfully.' : 'Task added successfully.',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                }
              },
              child: const Text('Save Task'),
            ),
          ],
        ),
      ),
    );
  }
}
