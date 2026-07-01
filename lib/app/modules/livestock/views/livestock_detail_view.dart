import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/livestock_model.dart';
import '../../../routes/app_routes.dart';
import '../../../theme/app_theme.dart';
import '../../../utils/constants.dart';
import '../../../utils/formatters.dart';
import '../../../widgets/status_badge.dart';
import '../controllers/livestock_controller.dart';

class LivestockDetailView extends GetView<LivestockController> {
  const LivestockDetailView({super.key});

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
    final item = Get.arguments as Livestock;
    final color = _healthColor(item.healthStatus);

    return Scaffold(
      appBar: AppBar(
        title: Text(item.animalType),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () {
              controller.prepareForEdit(item);
              Get.toNamed(Routes.livestockForm)?.then((_) => Get.back());
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () async {
              await controller.deleteAnimal(item);
              if (!controller.animals.contains(item)) Get.back();
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              StatusBadge(label: item.healthStatus, color: color),
              const Spacer(),
              Text(
                '${item.quantity} head',
                style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _DetailCard(
            children: [
              _DetailRow(label: 'Breed', value: item.breed ?? '—'),
              _DetailRow(label: 'Tag / Batch ID', value: item.tagId ?? '—'),
              _DetailRow(label: 'Gender', value: item.gender ?? '—'),
              _DetailRow(
                label: 'Average Weight',
                value: item.averageWeightKg != null
                    ? '${AppFormatters.decimal(item.averageWeightKg!)} kg'
                    : '—',
              ),
              _DetailRow(
                label: 'Date Acquired',
                value: AppFormatters.displayDate(item.dateAcquired),
              ),
              _DetailRow(
                label: 'Last Vaccination',
                value: item.lastVaccinationDate != null
                    ? AppFormatters.displayDate(item.lastVaccinationDate!)
                    : '—',
              ),
            ],
          ),
          if (item.notes != null && item.notes!.isNotEmpty) ...[
            const SizedBox(height: 14),
            _DetailCard(title: 'Notes', children: [Text(item.notes!)]),
          ],
        ],
      ),
    );
  }
}

class _DetailCard extends StatelessWidget {
  final String? title;
  final List<Widget> children;

  const _DetailCard({this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title != null) ...[
              Text(title!, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
              const SizedBox(height: 10),
            ],
            ...children,
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13.5)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13.5)),
        ],
      ),
    );
  }
}
