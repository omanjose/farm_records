import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/routes/app_routes.dart';
import '../../app/theme/app_theme.dart';
import '../../core/utils/app_date_utils.dart';
import '../../core/widgets/empty_state_widget.dart';
import '../../data/models/livestock_model.dart';
import 'livestock_controller.dart';

class LivestockListView extends GetView<LivestockController> {
  const LivestockListView({super.key});

  static const _healthColors = {
    'Healthy': Color(0xFF2E7D32),
    'Sick': AppColors.error,
    'Under Treatment': AppColors.orange,
    'Quarantined': AppColors.purple,
    'Deceased': AppColors.textSecondary,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Livestock'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: controller.loadLivestock,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'livestock_fab',
        onPressed: () {
          controller.prepareNew();
          Get.toNamed(AppRoutes.livestockForm);
        },
        child: const Icon(Icons.add_rounded),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.livestock.isEmpty) {
          return EmptyState(
            title: 'No Livestock Records',
            message: 'Tap the + button to add your first livestock entry.',
            icon: Icons.pets_rounded,
            actionLabel: 'Add Livestock',
            onAction: () {
              controller.prepareNew();
              Get.toNamed(AppRoutes.livestockForm);
            },
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.only(bottom: 100, top: 8),
          itemCount: controller.livestock.length,
          itemBuilder: (_, i) =>
              _LivestockCard(item: controller.livestock[i]),
        );
      }),
    );
  }
}

class _LivestockCard extends GetView<LivestockController> {
  final LivestockModel item;
  const _LivestockCard({required this.item});

  static const _healthColors = {
    'Healthy': Color(0xFF2E7D32),
    'Sick': AppColors.error,
    'Under Treatment': AppColors.orange,
    'Quarantined': AppColors.purple,
    'Deceased': AppColors.textSecondary,
  };
  
  get _animalIcons => null;

  @override
  Widget build(BuildContext context) {
    final healthColor =
        _healthColors[item.healthStatus] ?? AppColors.textSecondary;
    final emoji = _animalIcons[item.animalType] ?? '🐾';
    final isOverdue = item.vaccinationOverdue;

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          controller.prepareEdit(item);
          Get.toNamed(AppRoutes.livestockForm);
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                        child: Text(emoji,
                            style: const TextStyle(fontSize: 24))),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.animalType,
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary)),
                        if (item.breed != null)
                          Text(item.breed!,
                              style: TextStyle(
                                  fontSize: 12, color: Colors.grey[500])),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        AppDateUtils.formatNumber(item.quantity),
                        style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary),
                      ),
                      Text('animals',
                          style: TextStyle(
                              fontSize: 11, color: Colors.grey[500])),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(height: 1, color: AppColors.cardBorder),
              const SizedBox(height: 12),
              Row(
                children: [
                  StatusBadge(
                      status: item.healthStatus,
                      colorMap: _healthColors),
                  const Spacer(),
                  if (item.nextVaccination != null) ...[
                    Icon(
                      isOverdue
                          ? Icons.warning_amber_rounded
                          : Icons.vaccines_rounded,
                      size: 14,
                      color:
                          isOverdue ? AppColors.error : AppColors.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Vacc: ${AppDateUtils.toDisplay(item.nextVaccination)}',
                      style: TextStyle(
                          fontSize: 11,
                          color: isOverdue
                              ? AppColors.error
                              : AppColors.textSecondary,
                          fontWeight: isOverdue
                              ? FontWeight.bold
                              : FontWeight.normal),
                    ),
                  ],
                ],
              ),
              if (item.notes != null) ...[
                const SizedBox(height: 8),
                Text(item.notes!,
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis),
              ],
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    onPressed: () {
                      controller.prepareEdit(item);
                      Get.toNamed(AppRoutes.livestockForm);
                    },
                    icon: const Icon(Icons.edit_outlined, size: 16),
                    label: const Text('Edit'),
                    style: TextButton.styleFrom(
                        foregroundColor: AppColors.secondary),
                  ),
                  const SizedBox(width: 4),
                  TextButton.icon(
                    onPressed: () => controller.delete(item),
                    icon: const Icon(Icons.delete_outline, size: 16),
                    label: const Text('Delete'),
                    style: TextButton.styleFrom(
                        foregroundColor: AppColors.error),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
