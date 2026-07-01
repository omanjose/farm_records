import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/task_model.dart';
import '../../../routes/app_routes.dart';
import '../../../theme/app_theme.dart';
import '../../../utils/constants.dart';
import '../../../utils/formatters.dart';
import '../../../widgets/empty_state.dart';
import '../../../widgets/status_badge.dart';
import '../controllers/tasks_controller.dart';

class TasksListView extends GetView<TasksController> {
  const TasksListView({super.key});

  Color _priorityColor(String priority) {
    switch (priority) {
      case TaskPriority.high:
        return AppColors.danger;
      case TaskPriority.medium:
        return AppColors.warning;
      default:
        return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Farm Activities')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
            child:  SizedBox(
                height: 34,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                     _filterChip('All'),
                    ...TaskStatus.all.map(_filterChip),
                  ],
                ),
              ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              final list = controller.filteredTasks;
              if (list.isEmpty) {
                return EmptyState(
                  icon: Icons.checklist_rounded,
                  title: 'No Tasks Scheduled',
                  message: 'Plan your farm activities and never miss a deadline.',
                  actionLabel: 'Add Task',
                  onAction: () {
                    controller.prepareForCreate();
                    Get.toNamed(Routes.taskForm);
                  },
                );
              }
              return RefreshIndicator(
                onRefresh: controller.loadTasks,
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 90),
                  itemCount: list.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) => _TaskTile(
                    task: list[index],
                    color: _priorityColor(list[index].priority),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.prepareForCreate();
          Get.toNamed(Routes.taskForm);
        },
        child: const Icon(Icons.add),
        heroTag: 'Add New',
      ),
    );
  }

  Widget _filterChip(String value) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Obx(() {
        final selected = controller.statusFilter.value == value;
        return ChoiceChip(
          label: Text(value),
          selected: selected,
          onSelected: (_) => controller.statusFilter.value = value,
        );
      }),
    );
  }
}

class _TaskTile extends StatelessWidget {
  final FarmTask task;
  final Color color;

  const _TaskTile({required this.task, required this.color});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TasksController>();
    final isCompleted = task.status == TaskStatus.completed;
    final daysLeft = AppFormatters.daysFromToday(task.dueDate);
    final isOverdue = !isCompleted && daysLeft < 0;

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {
          controller.prepareForEdit(task);
          Get.toNamed(Routes.taskForm);
        },
        onLongPress: () => controller.deleteTask(task),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Checkbox(
                value: isCompleted,
                activeColor: AppColors.primary,
                onChanged: (_) => controller.toggleComplete(task),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        decoration: isCompleted ? TextDecoration.lineThrough : null,
                        color: isCompleted ? AppColors.textSecondary : AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${task.category} · Due ${AppFormatters.displayDate(task.dueDate)}'
                      '${isOverdue ? " (Overdue)" : ""}',
                      style: TextStyle(
                        fontSize: 12,
                        color: isOverdue ? AppColors.danger : AppColors.textSecondary,
                        fontWeight: isOverdue ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
              StatusBadge(label: task.priority, color: color),
            ],
          ),
        ),
      ),
    );
  }
}
