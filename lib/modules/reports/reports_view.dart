import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../app/theme/app_theme.dart';
import '../../core/utils/app_date_utils.dart';
import '../../core/widgets/empty_state_widget.dart';
import '../../core/widgets/stat_card.dart';
import 'reports_controller.dart';

class ReportsView extends GetView<ReportsController> {
  const ReportsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Reports & Analytics'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: controller.loadAll,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return RefreshIndicator(
          onRefresh: controller.loadAll,
          color: AppColors.primary,
          child: ListView(
            padding: const EdgeInsets.only(bottom: 40),
            children: [
              _buildReportHeader(),
              _buildCropReport(),
              _buildLivestockReport(),
              _buildFinanceReport(),
              _buildTransactionLog(),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildReportHeader() {
    final now = DateTime.now();
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primaryDark, AppColors.primary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.summarize_rounded,
                  color: Colors.white, size: 28),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Farm Report',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                  Text('Sunrise Agro Limited',
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.75),
                          fontSize: 13)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'Generated: ${AppDateUtils.toDisplay(AppDateUtils.today())}',
              style: const TextStyle(
                  color: Colors.white, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  // ── CROP SECTION ──────────────────────────────────────────────────────────
  Widget _buildCropReport() {
    return _Section(
      title: 'CROP PRODUCTION',
      icon: Icons.grass_rounded,
      color: AppColors.primary,
      children: [
        GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 1.6,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _MiniStat('Records', '${controller.totalCropRecords}',
                AppColors.primary),
            _MiniStat(
                'Total Area',
                '${controller.totalCropArea.toStringAsFixed(1)} ha',
                AppColors.secondary),
            _MiniStat('Harvested', '${controller.harvestedCrops}',
                const Color(0xFF00695C)),
            _MiniStat('Growing', '${controller.growingCrops}',
                AppColors.orange),
          ],
        ),
        if (controller.totalExpectedYield > 0) ...[
          const SizedBox(height: 14),
          _buildYieldEfficiencyBar(),
        ],
        if (controller.yieldByCrop.isNotEmpty) ...[
          const SizedBox(height: 16),
          const Text('Yield by Crop Type',
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textSecondary)),
          const SizedBox(height: 10),
          ...controller.yieldByCrop
              .map((row) => _buildCropYieldRow(row)),
        ],
        if (controller.crops.isNotEmpty) ...[
          const SizedBox(height: 16),
          const Text('All Crop Records',
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textSecondary)),
          const SizedBox(height: 8),
          _buildCropTable(),
        ],
      ],
    );
  }

  Widget _buildYieldEfficiencyBar() {
    final eff = controller.yieldEfficiency;
    final color = eff >= 80
        ? AppColors.primary
        : eff >= 60
            ? AppColors.orange
            : AppColors.error;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Overall Yield Efficiency',
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary)),
            Text('${eff.toStringAsFixed(1)}%',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: color)),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: (eff / 100).clamp(0, 1).toDouble(),
            minHeight: 10,
            backgroundColor: AppColors.primaryLight,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
                'Expected: ${AppDateUtils.formatNumber(controller.totalExpectedYield)} kg',
                style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary)),
            Text(
                'Actual: ${AppDateUtils.formatNumber(controller.totalActualYield)} kg',
                style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary)),
          ],
        ),
      ],
    );
  }

  Widget _buildCropYieldRow(Map<String, dynamic> row) {
    final total = controller.yieldByCrop.fold(
        0.0, (s, r) => s + ((r['total_yield'] as num?) ?? 0).toDouble());
    final val = ((row['total_yield'] as num?) ?? 0).toDouble();
    final pct = total > 0 ? val / total : 0;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
              width: 80,
              child: Text(row['crop_type'] as String,
                  style: const TextStyle(
                      fontSize: 12, color: AppColors.textSecondary))),
          const SizedBox(width: 8),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: pct.toDouble(),
                minHeight: 8,
                backgroundColor: AppColors.primaryLight,
                valueColor: const AlwaysStoppedAnimation<Color>(
                    AppColors.primary),
              ),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 70,
            child: Text(
              '${AppDateUtils.formatNumber(val)} kg',
              textAlign: TextAlign.right,
              style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCropTable() {
    return Table(
      border: TableBorder.all(color: AppColors.cardBorder, width: 1),
      columnWidths: const {
        0: FlexColumnWidth(2),
        1: FlexColumnWidth(1.2),
        2: FlexColumnWidth(1.5),
        3: FlexColumnWidth(1.5),
      },
      children: [
        _tableHeader(['Crop', 'Area(ha)', 'Expected', 'Status']),
        ...controller.crops.map((c) => TableRow(children: [
              _tableCell(c.cropType),
              _tableCell('${c.areaHa}'),
              _tableCell(c.expectedYieldKg != null
                  ? '${AppDateUtils.formatNumber(c.expectedYieldKg!)} kg'
                  : '—'),
              _tableCell(c.status),
            ])),
      ],
    );
  }

  // ── LIVESTOCK SECTION ─────────────────────────────────────────────────────
  Widget _buildLivestockReport() {
    return _Section(
      title: 'LIVESTOCK',
      icon: Icons.pets_rounded,
      color: AppColors.secondary,
      children: [
        GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 1.6,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _MiniStat('Animal Types',
                '${controller.totalAnimalTypes}', AppColors.secondary),
            _MiniStat('Total Headcount',
                AppDateUtils.formatNumber(controller.totalHeadcount),
                AppColors.primary),
            _MiniStat('Healthy',
                '${controller.healthyCount}', const Color(0xFF00695C)),
            _MiniStat(
                'Need Attention',
                '${controller.attentionCount}',
                controller.attentionCount > 0
                    ? AppColors.error
                    : AppColors.textSecondary),
          ],
        ),
        if (controller.animalTypes.isNotEmpty) ...[
          const SizedBox(height: 16),
          const Text('Headcount by Animal Type',
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textSecondary)),
          const SizedBox(height: 10),
          ...controller.animalTypes.map((row) => _buildAnimalRow(row)),
          const SizedBox(height: 12),
          _buildLivestockTable(),
        ],
      ],
    );
  }

  Widget _buildAnimalRow(Map<String, dynamic> row) {
    final total = controller.animalTypes.fold(
        0.0, (s, r) => s + ((r['total'] as num?) ?? 0).toDouble());
    final val = ((row['total'] as num?) ?? 0).toDouble();
    final pct = total > 0 ? val / total : 0;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
              width: 72,
              child: Text(row['animal_type'] as String,
                  style: const TextStyle(
                      fontSize: 12, color: AppColors.textSecondary))),
          const SizedBox(width: 8),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: pct.toDouble(),
                minHeight: 8,
                backgroundColor: AppColors.secondaryLight,
                valueColor: const AlwaysStoppedAnimation<Color>(
                    AppColors.secondary),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text('${val.toInt()}',
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.secondary)),
        ],
      ),
    );
  }

  Widget _buildLivestockTable() {
    return Table(
      border: TableBorder.all(color: AppColors.cardBorder, width: 1),
      columnWidths: const {
        0: FlexColumnWidth(1.5),
        1: FlexColumnWidth(1),
        2: FlexColumnWidth(1),
        3: FlexColumnWidth(2),
      },
      children: [
        _tableHeader(['Animal', 'Qty', 'Health', 'Next Vacc.']),
        ...controller.livestock.map((l) => TableRow(children: [
              _tableCell(l.animalType),
              _tableCell('${l.quantity}'),
              _tableCell(l.healthStatus),
              _tableCell(AppDateUtils.toDisplay(l.nextVaccination)),
            ])),
      ],
    );
  }

  // ── FINANCE SECTION ───────────────────────────────────────────────────────
  Widget _buildFinanceReport() {
    final net = controller.netBalance;
    return _Section(
      title: 'FINANCIAL SUMMARY',
      icon: Icons.account_balance_wallet_rounded,
      color: AppColors.orange,
      children: [
        Row(
          children: [
            Expanded(
                child: _FinCard('Total Income',
                    AppDateUtils.formatCompact(controller.totalIncome),
                    const Color(0xFF2E7D32))),
            const SizedBox(width: 10),
            Expanded(
                child: _FinCard('Total Expenses',
                    AppDateUtils.formatCompact(controller.totalExpense),
                    AppColors.orange)),
          ],
        ),
        const SizedBox(height: 10),
        _FinCard(
          net >= 0 ? 'Net Profit' : 'Net Deficit',
          AppDateUtils.formatCompact(net.abs()),
          net >= 0 ? AppColors.primary : AppColors.error,
          isBig: true,
        ),
        if (controller.monthlyFlow.isNotEmpty) ...[
          const SizedBox(height: 16),
          const Text('Monthly Cash Flow',
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textSecondary)),
          const SizedBox(height: 10),
          SizedBox(height: 160, child: _buildMonthlyChart()),
          const SizedBox(height: 8),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            _dot(const Color(0xFF2E7D32), 'Income'),
            const SizedBox(width: 20),
            _dot(AppColors.orange, 'Expense'),
          ]),
        ],
        if (controller.expenseByCategory.isNotEmpty) ...[
          const SizedBox(height: 16),
          const Text('Expense by Category',
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textSecondary)),
          const SizedBox(height: 8),
          _buildExpenseCategoryTable(),
        ],
      ],
    );
  }

  Widget _buildMonthlyChart() {
    final colors = [const Color(0xFF2E7D32), AppColors.orange];
    final List<BarChartGroupData> groups = [];
    for (var i = 0; i < controller.monthlyFlow.length; i++) {
      final row = controller.monthlyFlow[i];
      groups.add(BarChartGroupData(
        x: i,
        barsSpace: 4,
        barRods: [
          BarChartRodData(
              toY: ((row['income'] as num?) ?? 0).toDouble(),
              color: colors[0],
              width: 12,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(4))),
          BarChartRodData(
              toY: ((row['expense'] as num?) ?? 0).toDouble(),
              color: colors[1],
              width: 12,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(4))),
        ],
      ));
    }
    return BarChart(BarChartData(
      barGroups: groups,
      alignment: BarChartAlignment.spaceAround,
      titlesData: FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (v, m) {
              final i = v.toInt();
              if (i >= controller.monthlyFlow.length) {
                return const SizedBox.shrink();
              }
              final month =
                  (controller.monthlyFlow[i]['month'] as String)
                      .substring(5);
              return Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(month,
                    style: const TextStyle(
                        fontSize: 10,
                        color: AppColors.textSecondary)),
              );
            },
          ),
        ),
        leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false)),
        topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false)),
        rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false)),
      ),
      gridData: const FlGridData(show: false),
      borderData: FlBorderData(show: false),
    ));
  }

  Widget _buildExpenseCategoryTable() {
    return Table(
      border: TableBorder.all(color: AppColors.cardBorder, width: 1),
      columnWidths: const {
        0: FlexColumnWidth(2),
        1: FlexColumnWidth(1),
        2: FlexColumnWidth(1.5),
      },
      children: [
        _tableHeader(['Category', 'Count', 'Total Amount']),
        ...controller.expenseByCategory.map((row) => TableRow(children: [
              _tableCell(row['category'] as String),
              _tableCell('${row['count']}'),
              _tableCell(AppDateUtils.formatCompact(
                  ((row['total'] as num?) ?? 0).toDouble())),
            ])),
      ],
    );
  }

  // ── TRANSACTION LOG ───────────────────────────────────────────────────────
  Widget _buildTransactionLog() {
    if (controller.allTransactions.isEmpty) return const SizedBox.shrink();
    return _Section(
      title: 'TRANSACTION LOG',
      icon: Icons.receipt_long_rounded,
      color: AppColors.purple,
      children: [
        Table(
          border: TableBorder.all(color: AppColors.cardBorder, width: 1),
          columnWidths: const {
            0: FlexColumnWidth(1.4),
            1: FlexColumnWidth(1.2),
            2: FlexColumnWidth(1),
            3: FlexColumnWidth(1.6),
          },
          children: [
            _tableHeader(['Date', 'Type', 'Category', 'Amount']),
            ...controller.allTransactions.take(20).map((t) =>
                TableRow(children: [
                  _tableCell(AppDateUtils.toDisplay(t.transactionDate)),
                  _tableCell(t.type),
                  _tableCell(t.category),
                  _tableCell(
                    '${t.isIncome ? '+' : '-'}${AppDateUtils.formatCompact(t.amount)}',
                    color: t.isIncome
                        ? const Color(0xFF2E7D32)
                        : AppColors.orange,
                  ),
                ])),
          ],
        ),
        if (controller.allTransactions.length > 20)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
                '+ ${controller.allTransactions.length - 20} more transactions',
                style: TextStyle(
                    fontSize: 12, color: Colors.grey[400])),
          ),
      ],
    );
  }

  // ── Shared table helpers ──────────────────────────────────────────────────
  TableRow _tableHeader(List<String> headers) {
    return TableRow(
      decoration:
          const BoxDecoration(color: AppColors.primaryDark),
      children: headers
          .map((h) => Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 8),
                child: Text(h,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold)),
              ))
          .toList(),
    );
  }

  TableCell _tableCell(String text, {Color? color}) {
    return TableCell(
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: 8, vertical: 7),
        child: Text(text,
            style: TextStyle(
                fontSize: 11,
                color: color ?? AppColors.textPrimary)),
      ),
    );
  }

  Widget _dot(Color color, String label) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
              width: 10,
              height: 10,
              decoration:
                  BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 5),
          Text(label,
              style: const TextStyle(
                  fontSize: 11, color: AppColors.textSecondary)),
        ],
      );
}

// ── Shared section widget ────────────────────────────────────────────────────
class _Section extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final List<Widget> children;

  const _Section({
    required this.title,
    required this.icon,
    required this.color,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 3))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.08),
              borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 10),
                Text(title,
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: color,
                        letterSpacing: 0.5)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _MiniStat(this.label, this.value, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10),
        border:
            Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(value,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: color)),
          const SizedBox(height: 2),
          Text(label,
              style: TextStyle(
                  fontSize: 11, color: Colors.grey[500])),
        ],
      ),
    );
  }
}

class _FinCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final bool isBig;
  const _FinCard(this.label, this.value, this.color,
      {this.isBig = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(isBig ? 16 : 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500)),
          const SizedBox(height: 4),
          Text(value,
              style: TextStyle(
                  fontSize: isBig ? 20 : 16,
                  fontWeight: FontWeight.bold,
                  color: color)),
        ],
      ),
    );
  }
}
