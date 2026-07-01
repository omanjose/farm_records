import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_routes.dart';
import '../../../theme/app_theme.dart';
import '../../../utils/constants.dart';
import '../controllers/settings_controller.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        final profile = controller.profile.value;
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              child: ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.agriculture_rounded, color: AppColors.primary),
                ),
                title: Text(
                  profile?.farmName ?? AppStrings.appName,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                subtitle: Text(
                  profile != null
                      ? '${profile.ownerName} · ${profile.location}'
                      : 'Tap to set up your farm profile',
                  style: const TextStyle(fontSize: 12.5),
                ),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => Get.toNamed(Routes.farmProfileForm),
              ),
            ),
            const SizedBox(height: 18),
            const _SectionLabel('General'),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.bar_chart_rounded, color: AppColors.primary),
                    title: const Text('Reports & Analytics'),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => Get.toNamed(Routes.reports),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.storage_rounded, color: AppColors.primary),
                    title: const Text('Local Data Storage'),
                    subtitle: const Text(
                      'All your records are stored securely on this device using SQLite.',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            const _SectionLabel('About'),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.appName,
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'MOUAU Agro Farm is a digital record-keeping application built to '
                      'transform how small and medium-scale farms manage crops, livestock, '
                      'finances, and daily activities — replacing paper logbooks with '
                      'reliable, offline-first digital records for better planning, '
                      'accountability, and future-focused farm management.',
                      style: TextStyle(fontSize: 12.5, color: AppColors.textSecondary, height: 1.5),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Version 1.0.0',
                      style: TextStyle(fontSize: 11.5, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel(this.label);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(
        label.toUpperCase(),
        style: const TextStyle(
          fontSize: 11.5,
          fontWeight: FontWeight.w700,
          color: AppColors.textSecondary,
          letterSpacing: 0.6,
        ),
      ),
    );
  }
}
