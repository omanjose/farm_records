import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/routes/app_routes.dart';
import '../../app/theme/app_theme.dart';
import '../../core/utils/app_date_utils.dart';
import '../../core/widgets/empty_state_widget.dart';
import '../../data/models/expense_model.dart';
import 'finance_controller.dart';

class FinanceListView extends GetView<FinanceController> {
  const FinanceListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Finance'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: controller.loadTransactions,
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton.small(
            heroTag: 'income_fab',
            backgroundColor: const Color(0xFF00695C),
            onPressed: () {
              controller.prepareNew(defaultType: 'Income');
              Get.toNamed(AppRoutes.financeForm);
            },
            child: const Icon(Icons.add_rounded, color: Colors.white),
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            heroTag: 'expense_fab',
            backgroundColor: AppColors.orange,
            onPressed: () {
              controller.prepareNew(defaultType: 'Expense');
              Get.toNamed(AppRoutes.financeForm);
            },
            child: const Icon(Icons.remove_rounded, color: Colors.white),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return Column(
          children: [
            _buildSummaryBanner(),
            _buildFilterRow(),
            Expanded(
              child: controller.filteredTransactions.isEmpty
                  ? EmptyState(
                      title: 'No Transactions',
                      message:
                          'Use the buttons below to record income or expenses.',
                      icon: Icons.account_balance_wallet_rounded,
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.only(bottom: 120, top: 4),
                      itemCount: controller.filteredTransactions.length,
                      itemBuilder: (_, i) => _TransactionTile(
                          transaction:
                              controller.filteredTransactions[i]),
                    ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildSummaryBanner() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: _SummaryBox(
              label: 'Income',
              amount: controller.totalIncome.value,
              color: const Color(0xFF2E7D32),
              icon: Icons.arrow_downward_rounded,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _SummaryBox(
              label: 'Expenses',
              amount: controller.totalExpense.value,
              color: AppColors.orange,
              icon: Icons.arrow_upward_rounded,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _SummaryBox(
              label: 'Balance',
              amount: controller.netBalance,
              color: controller.netBalance >= 0
                  ? AppColors.secondary
                  : AppColors.error,
              icon: Icons.account_balance_rounded,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterRow() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Row(
        children: [
          _FilterBtn(
            label: 'All',
            isSelected: controller.selectedTypeFilter.value.isEmpty,
            onTap: () => controller.filterByType(''),
          ),
          const SizedBox(width: 8),
          _FilterBtn(
            label: 'Income',
            isSelected: controller.selectedTypeFilter.value == 'Income',
            onTap: () => controller.filterByType('Income'),
            color: const Color(0xFF2E7D32),
          ),
          const SizedBox(width: 8),
          _FilterBtn(
            label: 'Expenses',
            isSelected: controller.selectedTypeFilter.value == 'Expense',
            onTap: () => controller.filterByType('Expense'),
            color: AppColors.orange,
          ),
        ],
      ),
    );
  }
}

class _SummaryBox extends StatelessWidget {
  final String label;
  final double amount;
  final Color color;
  final IconData icon;

  const _SummaryBox({
    required this.label,
    required this.amount,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: color),
              const SizedBox(width: 4),
              Text(label,
                  style: TextStyle(
                      fontSize: 11,
                      color: color,
                      fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            _format(amount.abs()),
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: color),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  String _format(double v) {
    if (v >= 1000000) return '₦${(v / 1000000).toStringAsFixed(1)}M';
    if (v >= 1000) return '₦${(v / 1000).toStringAsFixed(0)}K';
    return '₦${v.toStringAsFixed(0)}';
  }
}

class _FilterBtn extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? color;

  const _FilterBtn({
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppColors.primary;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? c : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? c : AppColors.divider),
        ),
        child: Text(label,
            style: TextStyle(
                fontSize: 12,
                color: isSelected ? Colors.white : AppColors.textSecondary,
                fontWeight: isSelected
                    ? FontWeight.bold
                    : FontWeight.normal)),
      ),
    );
  }
}

class _TransactionTile extends GetView<FinanceController> {
  final ExpenseModel transaction;
  const _TransactionTile({required this.transaction});

  @override
  Widget build(BuildContext context) {
    final isIncome = transaction.isIncome;
    final color = isIncome ? const Color(0xFF2E7D32) : AppColors.orange;

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          controller.prepareEdit(transaction);
          Get.toNamed(AppRoutes.financeForm);
        },
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  isIncome
                      ? Icons.arrow_downward_rounded
                      : Icons.arrow_upward_rounded,
                  color: color,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(transaction.category,
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary)),
                    if (transaction.description != null)
                      Text(transaction.description!,
                          style: TextStyle(
                              fontSize: 12, color: Colors.grey[500]),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 2),
                    Text(
                      AppDateUtils.toDisplay(
                          transaction.transactionDate),
                      style: TextStyle(
                          fontSize: 11, color: Colors.grey[400]),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${isIncome ? '+' : '-'}${AppDateUtils.formatCompact(transaction.amount)}',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: color),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () {
                          controller.prepareEdit(transaction);
                          Get.toNamed(AppRoutes.financeForm);
                        },
                        child: const Icon(Icons.edit_outlined,
                            size: 16, color: AppColors.secondary),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: () => controller.delete(transaction),
                        child: const Icon(Icons.delete_outline,
                            size: 16, color: AppColors.error),
                      ),
                    ],
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
