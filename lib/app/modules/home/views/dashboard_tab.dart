import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_routes.dart';
import '../../../theme/app_theme.dart';
import '../../../utils/constants.dart';
import '../../../utils/formatters.dart';
import '../../../widgets/section_header.dart';
import '../../../widgets/stat_card.dart';
import '../../crops/controllers/crops_controller.dart';
import '../../livestock/controllers/livestock_controller.dart';
import '../../tasks/controllers/tasks_controller.dart';
import '../controllers/home_controller.dart';

/// The Dashboard tab: a snapshot of the whole farm's digital records.
class DashboardTab extends GetView<HomeController> {
  const DashboardTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(controller.farmName.value)),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart_rounded),
            tooltip: 'Reports',
            onPressed: () => Get.toNamed(Routes.reports),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Settings',
            onPressed: () => Get.toNamed(Routes.settings),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return RefreshIndicator(
          onRefresh: controller.loadDashboard,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 30),
            children: [
              const Text(
                'Farm Overview',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              const Text(
                'A live snapshot of your digital farm records.',
                style: TextStyle(fontSize: 12.5, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 16),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.5,
                children: [
                  StatCard(
                    label: 'Crop Records',
                    value: '${controller.cropCount.value}',
                    icon: Icons.grass_rounded,
                    color: AppColors.primary,
                    onTap: () => controller.changeTab(1),
                  ),
                  StatCard(
                    label: 'Livestock (head)',
                    value: '${controller.livestockHeadCount.value}',
                    icon: Icons.pets_rounded,
                    color: AppColors.accent,
                    onTap: () => controller.changeTab(2),
                  ),
                  StatCard(
                    label: 'Active Farm Area',
                    value: '${AppFormatters.decimal(controller.totalActiveArea.value)} ac',
                    icon: Icons.landscape_rounded,
                    color: AppColors.primaryDark,
                    onTap: () => controller.changeTab(1),
                  ),
                  StatCard(
                    label: 'Pending Tasks',
                    value: '${controller.pendingTasks.value}',
                    icon: Icons.checklist_rounded,
                    color: AppColors.warning,
                    onTap: () => controller.changeTab(4),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Card(
                color: AppColors.primaryDark,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Net Farm Balance',
                        style: TextStyle(color: Colors.white70, fontSize: 12.5),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        AppFormatters.currency(controller.netBalance.value),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          _miniStat('Income', controller.totalIncome.value, Colors.greenAccent),
                          const SizedBox(width: 18),
                          _miniStat('Expense', controller.totalExpense.value, Colors.redAccent),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SectionHeader(
                title: 'Upcoming Tasks',
                actionLabel: 'View all',
                onAction: () => controller.changeTab(4),
              ),
              const SizedBox(height: 10),
              _UpcomingTasksPreview(),
              const SizedBox(height: 24),
              const SectionHeader(title: 'Recent Crop Activity'),
              const SizedBox(height: 10),
              _RecentCropsPreview(),
              const SizedBox(height: 24),
              const SectionHeader(title: 'Livestock Snapshot'),
              const SizedBox(height: 10),
              _LivestockPreview(),
            ],
          ),
        );
      }),
    );
  }

  Widget _miniStat(String label, double value, Color dotColor) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          '$label: ${AppFormatters.currency(value)}',
          style: const TextStyle(color: Colors.white, fontSize: 11.5),
        ),
      ],
    );
  }
}

class _UpcomingTasksPreview extends GetView<TasksController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final upcoming = controller.tasks
          .where((t) => t.status != TaskStatus.completed)
          .take(3)
          .toList();
      if (upcoming.isEmpty) {
        return const Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Text('No pending tasks. Great job staying on top of the farm!',
                style: TextStyle(fontSize: 12.5, color: AppColors.textSecondary)),
          ),
        );
      }
      return Card(
        child: Column(
          children: upcoming
              .map(
                (t) => ListTile(
                  leading: const Icon(Icons.circle, size: 8, color: AppColors.warning),
                  title: Text(t.title, style: const TextStyle(fontSize: 13.5)),
                  subtitle: Text(
                    'Due ${AppFormatters.displayDate(t.dueDate)}',
                    style: const TextStyle(fontSize: 11.5),
                  ),
                ),
              )
              .toList(),
        ),
      );
    });
  }
}

class _RecentCropsPreview extends GetView<CropsController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final recent = controller.crops.take(3).toList();
      if (recent.isEmpty) {
        return const Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Text('No crop records yet. Add your first crop to get started.',
                style: TextStyle(fontSize: 12.5, color: AppColors.textSecondary)),
          ),
        );
      }
      return Card(
        child: Column(
          children: recent
              .map(
                (c) => ListTile(
                  leading: const Icon(Icons.grass_rounded, color: AppColors.primary),
                  title: Text(c.cropName, style: const TextStyle(fontSize: 13.5)),
                  subtitle: Text('${c.status} · ${c.areaPlanted} acres',
                      style: const TextStyle(fontSize: 11.5)),
                ),
              )
              .toList(),
        ),
      );
    });
  }
}

class _LivestockPreview extends GetView<LivestockController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final recent = controller.animals.take(3).toList();
      if (recent.isEmpty) {
        return const Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Text('No livestock records yet. Add your first batch to get started.',
                style: TextStyle(fontSize: 12.5, color: AppColors.textSecondary)),
          ),
        );
      }
      return Card(
        child: Column(
          children: recent
              .map(
                (a) => ListTile(
                  leading: const Icon(Icons.pets_rounded, color: AppColors.accent),
                  title: Text(a.animalType, style: const TextStyle(fontSize: 13.5)),
                  subtitle: Text('${a.quantity} head · ${a.healthStatus}',
                      style: const TextStyle(fontSize: 11.5)),
                ),
              )
              .toList(),
        ),
      );
    });
  }
}
