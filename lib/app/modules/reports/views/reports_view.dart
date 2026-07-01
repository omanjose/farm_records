import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../theme/app_theme.dart';
import '../../../utils/constants.dart';
import '../../../utils/formatters.dart';
import '../../../widgets/section_header.dart';
import '../controllers/reports_controller.dart';

class ReportsView extends GetView<ReportsController> {
  const ReportsView({super.key});

  static const List<Color> _palette = [
    AppColors.primary,
    AppColors.accent,
    AppColors.warning,
    AppColors.danger,
    AppColors.primaryLight,
    Color(0xFF5E35B1),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reports & Analytics')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return RefreshIndicator(
          onRefresh: controller.loadReports,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 30),
            children: [
              const SectionHeader(title: 'Income vs Expense'),
              const SizedBox(height: 12),
              _IncomeExpenseChart(
                income: controller.totalIncome.value,
                expense: controller.totalExpense.value,
              ),
              const SizedBox(height: 26),
              const SectionHeader(title: 'Expense Breakdown'),
              const SizedBox(height: 12),
              controller.expenseByCategory.isEmpty
                  ? _noDataCard('No expense records yet.')
                  : _CategoryPieChart(
                      data: controller.expenseByCategory,
                      palette: _palette,
                    ),
              const SizedBox(height: 26),
              const SectionHeader(title: 'Crop Status Distribution'),
              const SizedBox(height: 12),
              _StatusBarChart(
                data: controller.cropsByStatus,
                colorFor: (label) {
                  switch (label) {
                    case CropStatus.harvested:
                      return AppColors.primary;
                    case CropStatus.growing:
                      return AppColors.accent;
                    case CropStatus.failed:
                      return AppColors.danger;
                    default:
                      return AppColors.warning;
                  }
                },
              ),
              const SizedBox(height: 26),
              const SectionHeader(title: 'Livestock Health Distribution'),
              const SizedBox(height: 12),
              _StatusBarChart(
                data: controller.livestockByHealth,
                colorFor: (label) {
                  switch (label) {
                    case HealthStatus.healthy:
                      return AppColors.primary;
                    case HealthStatus.sick:
                      return AppColors.danger;
                    case HealthStatus.deceased:
                      return AppColors.textSecondary;
                    default:
                      return AppColors.warning;
                  }
                },
              ),
            ],
          ),
        );
      }),
    );
  }

  static Widget _noDataCard(String message) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Text(message, style: const TextStyle(color: AppColors.textSecondary)),
        ),
      ),
    );
  }
}

class _IncomeExpenseChart extends StatelessWidget {
  final double income;
  final double expense;

  const _IncomeExpenseChart({required this.income, required this.expense});

  @override
  Widget build(BuildContext context) {
    final maxVal = [income, expense, 1.0].reduce((a, b) => a > b ? a : b);
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
        child: SizedBox(
          height: 180,
          child: BarChart(
            BarChartData(
              maxY: maxVal * 1.2,
              gridData: const FlGridData(show: false),
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      final label = value == 0 ? 'Income' : 'Expense';
                      return Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(label, style: const TextStyle(fontSize: 12)),
                      );
                    },
                  ),
                ),
              ),
              barGroups: [
                BarChartGroupData(x: 0, barRods: [
                  BarChartRodData(
                    toY: income,
                    color: AppColors.primary,
                    width: 40,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ]),
                BarChartGroupData(x: 1, barRods: [
                  BarChartRodData(
                    toY: expense,
                    color: AppColors.danger,
                    width: 40,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CategoryPieChart extends StatelessWidget {
  final Map<String, double> data;
  final List<Color> palette;

  const _CategoryPieChart({required this.data, required this.palette});

  @override
  Widget build(BuildContext context) {
    final entries = data.entries.toList();
    final total = entries.fold<double>(0, (sum, e) => sum + e.value);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(
              height: 180,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
                  sections: List.generate(entries.length, (i) {
                    final pct = total == 0 ? 0 : (entries[i].value / total * 100);
                    return PieChartSectionData(
                      value: entries[i].value,
                      color: palette[i % palette.length],
                      title: '${pct.toStringAsFixed(0)}%',
                      radius: 46,
                      titleStyle: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    );
                  }),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 14,
              runSpacing: 8,
              children: List.generate(entries.length, (i) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: palette[i % palette.length],
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${entries[i].key} (${AppFormatters.currency(entries[i].value)})',
                      style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary),
                    ),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusBarChart extends StatelessWidget {
  final Map<String, int> data;
  final Color Function(String) colorFor;

  const _StatusBarChart({required this.data, required this.colorFor});

  @override
  Widget build(BuildContext context) {
    final entries = data.entries.toList();
    final maxVal = entries.isEmpty
        ? 1
        : entries.map((e) => e.value).reduce((a, b) => a > b ? a : b);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: entries.map((entry) {
            final ratio = maxVal == 0 ? 0.0 : entry.value / maxVal;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  SizedBox(
                    width: 92,
                    child: Text(
                      entry.key,
                      style: const TextStyle(fontSize: 12.5, color: AppColors.textSecondary),
                    ),
                  ),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: ratio,
                        minHeight: 12,
                        backgroundColor: AppColors.divider,
                        valueColor: AlwaysStoppedAnimation(colorFor(entry.key)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '${entry.value}',
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
