import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../app/theme/app_theme.dart';
import '../../core/utils/app_date_utils.dart';
import '../../core/widgets/empty_state_widget.dart';
import '../../core/widgets/stat_card.dart';
import '../main/main_controller.dart';
import 'dashboard_controller.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return RefreshIndicator(
          onRefresh: controller.loadData,
          color: AppColors.primary,
          child: CustomScrollView(
            slivers: [
              _buildAppBar(context),
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildKpiGrid(),
                    if (controller.overdueVaccinations.value > 0)
                      _buildAlertBanner(),
                    _buildYieldChart(),
                    _buildFinanceSummary(),
                    _buildExpensePieChart(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    final mc = Get.find<MainController>();
    return SliverAppBar(
      expandedHeight: 130,
      pinned: true,
      backgroundColor: AppColors.primary,
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh_rounded),
          onPressed: controller.loadData,
          tooltip: 'Refresh',
        ),
        IconButton(
          icon: const Icon(Icons.logout_rounded),
          onPressed: mc.logout,
          tooltip: 'Sign Out',
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primary, AppColors.primaryDark],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: const EdgeInsets.fromLTRB(20, 60, 20, 16),
          child: GetBuilder<MainController>(
            builder: (mc) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('Good day, ${mc.fullName.split(' ').first} 👋',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(
                  'Sunrise Agro Ltd  ·  ${mc.role.capitalizeFirst}',
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.75), fontSize: 13),
                ),
              ],
            ),
          ),
        ),
        title: const Text('Dashboard'),
        titlePadding: const EdgeInsets.only(left: 16, bottom: 14),
      ),
    );
  }

  Widget _buildKpiGrid() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Overview',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary)),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.35,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              StatCard(
                label: 'Crop Records',
                value: '${controller.totalCropRecords.value}',
                subtitle:
                    '${AppDateUtils.formatNumber(controller.totalCropArea.value)} ha',
                icon: Icons.grass_rounded,
                color: AppColors.primary,
              ),
              StatCard(
                label: 'Total Livestock',
                value:
                    AppDateUtils.formatNumber(controller.totalLivestock.value),
                icon: Icons.pets_rounded,
                color: AppColors.secondary,
              ),
              StatCard(
                label: 'Total Income',
                value: _compact(controller.totalIncome.value),
                icon: Icons.trending_up_rounded,
                color: const Color(0xFF00695C),
              ),
              StatCard(
                label: 'Total Expenses',
                value: _compact(controller.totalExpense.value),
                icon: Icons.trending_down_rounded,
                color: AppColors.orange,
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Net balance chip
          Container(
            width: double.infinity,
            padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: controller.netBalance >= 0
                    ? [const Color(0xFF1B5E20), const Color(0xFF2E7D32)]
                    : [const Color(0xFFB71C1C), const Color(0xFFC62828)],
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Icon(
                  controller.netBalance >= 0
                      ? Icons.account_balance_rounded
                      : Icons.warning_rounded,
                  color: Colors.white,
                  size: 28,
                ),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Net Balance',
                        style: TextStyle(
                            color: Colors.white70, fontSize: 12)),
                    Text(
                      AppDateUtils.formatCompact(
                          controller.netBalance.abs()),
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  controller.netBalance >= 0 ? 'PROFIT' : 'DEFICIT',
                  style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlertBanner() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.orange[50],
        borderRadius: BorderRadius.circular(12),
        border:
            Border.all(color: Colors.orange[300]!, width: 1),
      ),
      child: Row(
        children: [
          Icon(Icons.vaccines_rounded,
              color: Colors.orange[700], size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              '${controller.overdueVaccinations.value} livestock record(s) have overdue vaccinations',
              style: TextStyle(
                  color: Colors.orange[800],
                  fontSize: 13,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildYieldChart() {
    if (controller.yieldData.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Container(
        padding: const EdgeInsets.all(16),
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
            const Text('Crop Yield by Type (kg)',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary)),
            const SizedBox(height: 16),
            SizedBox(
              height: 180,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  barGroups: _buildBarGroups(),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (v, m) {
                          final idx = v.toInt();
                          if (idx >= controller.yieldData.length) {
                            return const SizedBox.shrink();
                          }
                          final label = (controller.yieldData[idx]
                                      ['crop_type'] as String)
                                  .split(' ')
                                  .first;
                          return Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(label,
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
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      // tooltipBgColor: AppColors.primaryDark,
                      getTooltipItem: (group, groupIndex, rod, rodIndex) =>
                          BarTooltipItem(
                        '${AppDateUtils.formatNumber(rod.toY)} kg',
                        const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<BarChartGroupData> _buildBarGroups() {
    final colors = [
      AppColors.primary,
      AppColors.secondary,
      AppColors.purple,
      AppColors.orange,
      const Color(0xFF00838F),
    ];
    return controller.yieldData.asMap().entries.map((e) {
      final color = colors[e.key % colors.length];
      return BarChartGroupData(
        x: e.key,
        barRods: [
          BarChartRodData(
            toY: ((e.value['total_yield'] as num?) ?? 0).toDouble(),
            color: color,
            width: 24,
            borderRadius: const BorderRadius.vertical(
                top: Radius.circular(6)),
          )
        ],
      );
    }).toList();
  }

  Widget _buildFinanceSummary() {
    if (controller.monthlyFlow.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Container(
        padding: const EdgeInsets.all(16),
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
            const Text('Monthly Cash Flow',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary)),
            const SizedBox(height: 4),
            Text('Income vs Expenses',
                style: TextStyle(
                    fontSize: 12, color: Colors.grey[500])),
            const SizedBox(height: 16),
            SizedBox(
              height: 160,
              child: LineChart(
                LineChartData(
                  lineBarsData: [
                    _lineBar(
                        controller.monthlyFlow
                            .map((e) =>
                                ((e['income'] as num?) ?? 0).toDouble())
                            .toList(),
                        const Color(0xFF2E7D32)),
                    _lineBar(
                        controller.monthlyFlow
                            .map((e) =>
                                ((e['expense'] as num?) ?? 0).toDouble())
                            .toList(),
                        AppColors.orange),
                  ],
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (v, m) {
                          final idx = v.toInt();
                          if (idx >= controller.monthlyFlow.length) {
                            return const SizedBox.shrink();
                          }
                          final month =
                              (controller.monthlyFlow[idx]['month']
                                      as String)
                                  .substring(5);
                          return Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(month,
                                style: const TextStyle(
                                    fontSize: 10,
                                    color: AppColors.textSecondary)),
                          );
                        },
                        interval: 1,
                      ),
                    ),
                    leftTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    topTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    rightTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 200000,
                    getDrawingHorizontalLine: (_) => const FlLine(
                        color: AppColors.cardBorder, strokeWidth: 1),
                  ),
                  borderData: FlBorderData(show: false),
                  lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                      // tooltipBgColor: Colors.blueGrey[800]!,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _legend(const Color(0xFF2E7D32), 'Income'),
                const SizedBox(width: 20),
                _legend(AppColors.orange, 'Expense'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  LineChartBarData _lineBar(List<double> values, Color color) {
    return LineChartBarData(
      spots: values.asMap().entries
          .map((e) => FlSpot(e.key.toDouble(), e.value))
          .toList(),
      isCurved: true,
      color: color,
      barWidth: 2.5,
      dotData: const FlDotData(show: false),
      belowBarData: BarAreaData(
          show: true, color: color.withOpacity(0.08)),
    );
  }

  Widget _buildExpensePieChart() {
    if (controller.expenseCategoryData.isEmpty) return const SizedBox.shrink();
    final colors = [
      AppColors.primary, AppColors.secondary, AppColors.purple,
      AppColors.orange, const Color(0xFF00838F), const Color(0xFF6D4C41),
    ];
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Container(
        padding: const EdgeInsets.all(16),
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
            const Text('Expense Breakdown',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary)),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 160,
                    child: PieChart(
                      PieChartData(
                        sections: controller.expenseCategoryData
                            .asMap()
                            .entries
                            .map((e) {
                          final color = colors[e.key % colors.length];
                          final total = controller.expenseCategoryData.fold(
                            0.0,
                            (s, row) =>
                                s + ((row['total'] as num?) ?? 0).toDouble(),
                          );
                          final val =
                              ((e.value['total'] as num?) ?? 0).toDouble();
                          final pct = total > 0 ? (val / total * 100) : 0;
                          return PieChartSectionData(
                            value: val,
                            color: color,
                            title: '${pct.toStringAsFixed(0)}%',
                            radius: 60,
                            titleStyle: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold),
                          );
                        }).toList(),
                        sectionsSpace: 2,
                        centerSpaceRadius: 28,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: controller.expenseCategoryData
                      .asMap()
                      .entries
                      .map((e) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: _legend(
                              colors[e.key % colors.length],
                              e.value['category'] as String,
                              amount: ((e.value['total'] as num?) ?? 0)
                                  .toDouble(),
                            ),
                          ))
                      .toList(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _legend(Color color, String label, {double? amount}) => Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration:
                BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            amount != null
                ? '$label\n${_compact(amount)}'
                : label,
            style: const TextStyle(
                fontSize: 11, color: AppColors.textSecondary),
          ),
        ],
      );

  String _compact(double v) {
    if (v >= 1000000) {
      return '₦${(v / 1000000).toStringAsFixed(1)}M';
    } else if (v >= 1000) {
      return '₦${(v / 1000).toStringAsFixed(0)}K';
    }
    return '₦${v.toStringAsFixed(0)}';
  }
}
