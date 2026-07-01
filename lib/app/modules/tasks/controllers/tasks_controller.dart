import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/task_model.dart';
import '../../../data/repositories/task_repository.dart';
import '../../../utils/constants.dart';
import '../../../utils/formatters.dart';
import '../../../widgets/confirm_dialog.dart';

class TasksController extends GetxController {
  final TaskRepository _repo = TaskRepository();

  final RxList<FarmTask> tasks = <FarmTask>[].obs;
  final RxBool isLoading = true.obs;
  final RxString statusFilter = 'All'.obs;

  // ---- Form state ----
  final formKey = GlobalKey<FormState>();
  final titleCtrl = TextEditingController();
  final descriptionCtrl = TextEditingController();

  final RxString category = TaskCategories.all.first.obs;
  final RxString priority = TaskPriority.medium.obs;
  final RxString status = TaskStatus.pending.obs;
  final Rx<DateTime> dueDate = DateTime.now().obs;

  int? _editingId;
  String? _createdAt;
  bool get isEditing => _editingId != null;

  @override
  void onInit() {
    super.onInit();
    loadTasks();
  }

  @override
  void onClose() {
    titleCtrl.dispose();
    descriptionCtrl.dispose();
    super.onClose();
  }

  Future<void> loadTasks() async {
    isLoading.value = true;
    final all = await _repo.getAll();
    // Sort: pending/in-progress first (by due date), then completed last.
    all.sort((a, b) {
      final aDone = a.status == TaskStatus.completed;
      final bDone = b.status == TaskStatus.completed;
      if (aDone != bDone) return aDone ? 1 : -1;
      return a.dueDate.compareTo(b.dueDate);
    });
    tasks.value = all;
    isLoading.value = false;
  }

  List<FarmTask> get filteredTasks {
    if (statusFilter.value == 'All') return tasks;
    return tasks.where((t) => t.status == statusFilter.value).toList();
  }

  void prepareForCreate() {
    _editingId = null;
    _createdAt = null;
    titleCtrl.clear();
    descriptionCtrl.clear();
    category.value = TaskCategories.all.first;
    priority.value = TaskPriority.medium;
    status.value = TaskStatus.pending;
    dueDate.value = DateTime.now();
  }

  void prepareForEdit(FarmTask task) {
    _editingId = task.id;
    _createdAt = task.createdAt;
    titleCtrl.text = task.title;
    descriptionCtrl.text = task.description ?? '';
    category.value = task.category;
    priority.value = task.priority;
    status.value = task.status;
    dueDate.value = DateTime.tryParse(task.dueDate) ?? DateTime.now();
  }

  Future<bool> submit() async {
    if (!formKey.currentState!.validate()) return false;

    final task = FarmTask(
      id: _editingId,
      title: titleCtrl.text.trim(),
      description:
          descriptionCtrl.text.trim().isEmpty ? null : descriptionCtrl.text.trim(),
      category: category.value,
      dueDate: AppFormatters.toStorageDate(dueDate.value),
      priority: priority.value,
      status: status.value,
      createdAt: _createdAt ?? AppFormatters.nowTimestamp(),
      completedAt: status.value == TaskStatus.completed
          ? AppFormatters.nowTimestamp()
          : null,
    );

    if (isEditing) {
      await _repo.update(task);
    } else {
      await _repo.create(task);
    }
    await loadTasks();
    return true;
  }

  Future<void> toggleComplete(FarmTask task) async {
    final updated = task.copyWith(
      status: task.status == TaskStatus.completed
          ? TaskStatus.pending
          : TaskStatus.completed,
      completedAt: task.status == TaskStatus.completed
          ? null
          : AppFormatters.nowTimestamp(),
    );
    await _repo.update(updated);
    await loadTasks();
  }

  Future<void> deleteTask(FarmTask task) async {
    final confirmed = await showConfirmDialog(
      title: 'Delete Task',
      message: 'Are you sure you want to delete "${task.title}"? This cannot be undone.',
    );
    if (confirmed == true && task.id != null) {
      await _repo.delete(task.id!);
      await loadTasks();
    }
  }
}
