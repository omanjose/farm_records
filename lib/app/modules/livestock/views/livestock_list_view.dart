import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/livestock_model.dart';
import '../../../routes/app_routes.dart';
import '../../../theme/app_theme.dart';
import '../../../utils/constants.dart';
import '../../../utils/formatters.dart';
import '../../../widgets/empty_state.dart';
import '../../../widgets/status_badge.dart';
import '../controllers/livestock_controller.dart';

class LivestockListView extends GetView<LivestockController> {
  const LivestockListView({super.key});

  Color _healthColor(String status) {
    switch (status) {
      case HealthStatus.healthy:
        return AppColors.primary;
      case HealthStatus.sick:
        return AppColors.danger;
      case HealthStatus.deceased:
        return AppColors.textSecondary;
      default:
        return AppColors.warning;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Livestock Records')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
            child: Column(
              children: [
                TextField(
                  onChanged: (v) => controller.searchQuery.value = v,
                  decoration: InputDecoration(
                    hintText: 'Search by animal type...',
                    prefixIcon: const Icon(Icons.search, size: 20),
                    contentPadding: EdgeInsets.zero,
                    filled: true,
                    fillColor: AppColors.surface,
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                    height: 34,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _filterChip('All'),
                        ...HealthStatus.all.map(_filterChip),
                      ],
                    ),
                  ),
                
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              final list = controller.filteredAnimals;
              if (list.isEmpty) {
                return EmptyState(
                  icon: Icons.pets_rounded,
                  title: 'No Livestock Records Yet',
                  message: 'Add your first batch of animals to start tracking them.',
                  actionLabel: 'Add Livestock',
                  onAction: () {
                    controller.prepareForCreate();
                    Get.toNamed(Routes.livestockForm);
                  },
                );
              }
              return RefreshIndicator(
                onRefresh: controller.loadAnimals,
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 90),
                  itemCount: list.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) => _LivestockTile(
                    item: list[index],
                    color: _healthColor(list[index].healthStatus),
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
          Get.toNamed(Routes.livestockForm);
        },
        heroTag: 'Add New Livestock',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _filterChip(String value) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Obx(() {
        final selected = controller.healthFilter.value == value;
        return ChoiceChip(
          label: Text(value),
          selected: selected,
          onSelected: (_) => controller.healthFilter.value = value,
        );
      }),
    );
  }
}

class _LivestockTile extends StatelessWidget {
  final Livestock item;
  final Color color;

  const _LivestockTile({required this.item, required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => Get.toNamed(Routes.livestockDetail, arguments: item),
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
                child: Icon(Icons.pets_rounded, color: color),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${item.animalType}${item.breed != null ? " · ${item.breed}" : ""}',
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${item.quantity} head · Acquired ${AppFormatters.displayDate(item.dateAcquired)}',
                      style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              StatusBadge(label: item.healthStatus, color: color),
            ],
          ),
        ),
      ),
    );
  }
}
