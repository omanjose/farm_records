import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/crop_model.dart';
import '../../../routes/app_routes.dart';
import '../../../theme/app_theme.dart';
import '../../../utils/constants.dart';
import '../../../utils/formatters.dart';
import '../../../widgets/empty_state.dart';
import '../../../widgets/status_badge.dart';
import '../controllers/crops_controller.dart';

class CropsListView extends GetView<CropsController> {
  const CropsListView({super.key});

  Color _statusColor(String status) {
    switch (status) {
      case CropStatus.harvested:
        return AppColors.primary;
      case CropStatus.growing:
        return AppColors.accent;
      case CropStatus.failed:
        return AppColors.danger;
      default:
        return AppColors.warning;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crop Records')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
            child: Column(
              children: [
                TextField(
                  onChanged: (v) => controller.searchQuery.value = v,
                  decoration: InputDecoration(
                    hintText: 'Search crops by name...',
                    prefixIcon: const Icon(Icons.search, size: 20),
                    contentPadding: EdgeInsets.zero,
                    filled: true,
                    fillColor: AppColors.surface,
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              final list = controller.filteredCrops;
              if (list.isEmpty) {
                return EmptyState(
                  icon: Icons.grass_rounded,
                  title: 'No Crop Records Yet',
                  message:
                      'Start digitizing your farm by adding your first crop record.',
                  actionLabel: 'Add Crop',
                  onAction: () {
                    controller.prepareForCreate();
                    Get.toNamed(Routes.cropForm);
                  },
                );
              }
              return RefreshIndicator(
                onRefresh: controller.loadCrops,
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 90),
                  itemCount: list.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) =>
                      _CropTile(crop: list[index], color: _statusColor(list[index].status)),
                ),
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.prepareForCreate();
          Get.toNamed(Routes.cropForm);
        },
        heroTag: 'Add New Crop',
        child: const Icon(Icons.add),
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

class _CropTile extends StatelessWidget {
  final Crop crop;
  final Color color;

  const _CropTile({required this.crop, required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => Get.toNamed(Routes.cropDetail, arguments: crop),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.grass_rounded, color: color),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      crop.cropName,
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${crop.areaPlanted} acres · Planted ${AppFormatters.displayDate(crop.plantingDate)}',
                      style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              StatusBadge(label: crop.status, color: color),
            ],
          ),
        ),
      ),
    );
  }
}
