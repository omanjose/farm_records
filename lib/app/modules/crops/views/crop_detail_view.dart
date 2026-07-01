import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/crop_model.dart';
import '../../../routes/app_routes.dart';
import '../../../theme/app_theme.dart';
import '../../../utils/constants.dart';
import '../../../utils/formatters.dart';
import '../../../widgets/status_badge.dart';
import '../controllers/crops_controller.dart';

class CropDetailView extends GetView<CropsController> {
  const CropDetailView({super.key});

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
    final crop = Get.arguments as Crop;
    final color = _statusColor(crop.status);

    return Scaffold(
      appBar: AppBar(
        title: Text(crop.cropName),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () {
              controller.prepareForEdit(crop);
              Get.toNamed(Routes.cropForm)?.then((_) => Get.back());
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () async {
              await controller.deleteCrop(crop);
              if (!controller.crops.contains(crop)) Get.back();
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              StatusBadge(label: crop.status, color: color),
              const Spacer(),
              Text(
                '${crop.areaPlanted} acres',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _DetailCard(
            children: [
              _DetailRow(label: 'Variety', value: crop.variety ?? '—'),
              _DetailRow(label: 'Field / Plot', value: crop.fieldLocation ?? '—'),
              _DetailRow(
                label: 'Planting Date',
                value: AppFormatters.displayDate(crop.plantingDate),
              ),
              _DetailRow(
                label: 'Expected Harvest',
                value: crop.expectedHarvestDate != null
                    ? AppFormatters.displayDate(crop.expectedHarvestDate!)
                    : '—',
              ),
              _DetailRow(
                label: 'Actual Harvest',
                value: crop.actualHarvestDate != null
                    ? AppFormatters.displayDate(crop.actualHarvestDate!)
                    : '—',
              ),
            ],
          ),
          const SizedBox(height: 14),
          _DetailCard(
            title: 'Yield Tracking',
            children: [
              _DetailRow(
                label: 'Expected Yield',
                value: crop.expectedYieldKg != null
                    ? '${AppFormatters.decimal(crop.expectedYieldKg!)} kg'
                    : '—',
              ),
              _DetailRow(
                label: 'Actual Yield',
                value: crop.actualYieldKg != null
                    ? '${AppFormatters.decimal(crop.actualYieldKg!)} kg'
                    : '—',
              ),
            ],
          ),
          if (crop.notes != null && crop.notes!.isNotEmpty) ...[
            const SizedBox(height: 14),
            _DetailCard(title: 'Notes', children: [Text(crop.notes!)]),
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
              Text(
                title!,
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
              ),
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
