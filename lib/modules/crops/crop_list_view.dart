import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/routes/app_routes.dart';
import '../../app/theme/app_theme.dart';
import '../../core/utils/app_date_utils.dart';
import '../../core/widgets/empty_state_widget.dart';
import '../../data/models/crop_model.dart';
import 'crop_controller.dart';

class CropListView extends GetView<CropController> {
  const CropListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Crop Records'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: controller.loadCrops,
            tooltip: 'Refresh',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'crop_fab',
        onPressed: () {
          controller.prepareNew();
          Get.toNamed(AppRoutes.cropForm);
        },
        child: const Icon(Icons.add_rounded),
      ),
      body: Column(
        children: [
          _buildFilterChips(),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (controller.filteredCrops.isEmpty) {
                return EmptyState(
                  title: 'No Crop Records',
                  message:
                      'Tap the + button to add your first crop record.',
                  icon: Icons.grass_rounded,
                  actionLabel: 'Add Crop',
                  onAction: () {
                    controller.prepareNew();
                    Get.toNamed(AppRoutes.cropForm);
                  },
                );
              }
              return ListView.builder(
                padding:
                    const EdgeInsets.only(bottom: 100, top: 4),
                itemCount: controller.filteredCrops.length,
                itemBuilder: (_, i) =>
                    _CropCard(crop: controller.filteredCrops[i]),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    final statuses = ['', ...controller.crops.map((c) => c.status).toSet()];
    return Obx(() => Container(
          color: Colors.white,
          padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: statuses.map((s) {
                final label = s.isEmpty ? 'All' : s;
                final selected = controller.selectedStatus.value == s;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(label),
                    selected: selected,
                    onSelected: (_) => controller.filterByStatus(s),
                    selectedColor: AppColors.primaryLight,
                    checkmarkColor: AppColors.primary,
                    labelStyle: TextStyle(
                      color: selected
                          ? AppColors.primary
                          : AppColors.textSecondary,
                      fontWeight: selected
                          ? FontWeight.w600
                          : FontWeight.normal,
                      fontSize: 12,
                    ),
                    side: BorderSide(
                      color: selected
                          ? AppColors.primary
                          : AppColors.divider,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ));
  }
}

class _CropCard extends GetView<CropController> {
  final CropModel crop;
  const _CropCard({required this.crop});
  
  get _statusColors => null;

  @override
  Widget build(BuildContext context) {
    final statusColor =
        _statusColors[crop.status] ?? AppColors.textSecondary;
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          controller.prepareEdit(crop);
          Get.toNamed(AppRoutes.cropForm);
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.grass_rounded,
                        color: AppColors.primary, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(crop.cropType,
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary)),
                        if (crop.seedVariety != null)
                          Text(crop.seedVariety!,
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[500])),
                      ],
                    ),
                  ),
                  StatusBadge(
                      status: crop.status, colorMap: _statusColors),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(height: 1, color: AppColors.cardBorder),
              const SizedBox(height: 12),
              Row(
                children: [
                  _InfoChip(
                      icon: Icons.straighten_rounded,
                      label: '${crop.areaHa} ha'),
                  const SizedBox(width: 8),
                  _InfoChip(
                      icon: Icons.calendar_today_outlined,
                      label:
                          AppDateUtils.toDisplay(crop.datePlanted)),
                  const SizedBox(width: 8),
                  _InfoChip(
                      icon: Icons.wb_sunny_outlined,
                      label: crop.season),
                ],
              ),
              if (crop.expectedYieldKg != null) ...[
                const SizedBox(height: 10),
                _buildYieldProgress(),
              ],
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    onPressed: () {
                      controller.prepareEdit(crop);
                      Get.toNamed(AppRoutes.cropForm);
                    },
                    icon: const Icon(Icons.edit_outlined, size: 16),
                    label: const Text('Edit'),
                    style: TextButton.styleFrom(
                        foregroundColor: AppColors.secondary),
                  ),
                  const SizedBox(width: 4),
                  TextButton.icon(
                    onPressed: () => controller.delete(crop),
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

  Widget _buildYieldProgress() {
    final efficiency = crop.yieldEfficiency;
    final hasActual = crop.actualYieldKg != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Yield Progress',
                style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[500],
                    fontWeight: FontWeight.w500)),
            if (hasActual)
              Text('${efficiency.toStringAsFixed(0)}%',
                  style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary)),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: hasActual
                ? (efficiency / 100).clamp(0, 1).toDouble()
                : 0,
            minHeight: 6,
            backgroundColor: AppColors.primaryLight,
            valueColor: AlwaysStoppedAnimation<Color>(
              hasActual ? AppColors.primary : AppColors.divider,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Expected: ${AppDateUtils.formatNumber(crop.expectedYieldKg!)} kg',
              style: TextStyle(fontSize: 10, color: Colors.grey[500]),
            ),
            if (hasActual)
              Text(
                'Actual: ${AppDateUtils.formatNumber(crop.actualYieldKg!)} kg',
                style: TextStyle(fontSize: 10, color: Colors.grey[500]),
              ),
          ],
        ),
      ],
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AppColors.textSecondary),
          const SizedBox(width: 4),
          Text(label,
              style: const TextStyle(
                  fontSize: 11, color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}
