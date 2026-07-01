import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/transaction_model.dart';
import '../../../routes/app_routes.dart';
import '../../../theme/app_theme.dart';
import '../../../utils/constants.dart';
import '../../../utils/formatters.dart';
import '../../../widgets/empty_state.dart';
import '../controllers/finance_controller.dart';

class FinanceListView extends GetView<FinanceController> {
  const FinanceListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Farm Finance')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
              child: Row(
                children: [
                  Expanded(
                    child: _SummaryTile(
                      label: 'Income',
                      value: controller.totalIncome.value,
                      color: AppColors.primary,
                      icon: Icons.arrow_downward_rounded,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _SummaryTile(
                      label: 'Expense',
                      value: controller.totalExpense.value,
                      color: AppColors.danger,
                      icon: Icons.arrow_upward_rounded,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Card(
                color: AppColors.primaryDark,
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Net Balance',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        AppFormatters.currency(controller.netBalance.value),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: SizedBox(
                height: 34,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _filterChip('All'),
                    _filterChip(TransactionType.income),
                    _filterChip(TransactionType.expense),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Builder(builder: (context) {
                final list = controller.filteredTransactions;
                if (list.isEmpty) {
                  return EmptyState(
                    icon: Icons.receipt_long_rounded,
                    title: 'No Transactions Yet',
                    message: 'Log your farm income and expenses to track profitability.',
                    actionLabel: 'Add Transaction',
                    onAction: () {
                      controller.prepareForCreate();
                      Get.toNamed(Routes.financeForm);
                    },
                  );
                }
                return RefreshIndicator(
                  onRefresh: controller.loadTransactions,
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 90),
                    itemCount: list.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) => _TransactionTile(tx: list[index]),
                  ),
                );
              }),
            ),
          ],
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.prepareForCreate();
          Get.toNamed(Routes.financeForm);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _filterChip(String value) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Obx(() {
        final selected = controller.typeFilter.value == value;
        return ChoiceChip(
          label: Text(value),
          selected: selected,
          onSelected: (_) => controller.typeFilter.value = value,
        );
      }),
    );
  }
}

class _SummaryTile extends StatelessWidget {
  final String label;
  final double value;
  final Color color;
  final IconData icon;

  const _SummaryTile({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 18),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary)),
                  Text(
                    AppFormatters.currency(value),
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TransactionTile extends StatelessWidget {
  final FarmTransaction tx;

  const _TransactionTile({required this.tx});

  @override
  Widget build(BuildContext context) {
    final isIncome = tx.type == TransactionType.income;
    final color = isIncome ? AppColors.primary : AppColors.danger;
    final controller = Get.find<FinanceController>();

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {
          controller.prepareForEdit(tx);
          Get.toNamed(Routes.financeForm);
        },
        onLongPress: () => controller.deleteTransaction(tx),
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
                child: Icon(
                  isIncome ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded,
                  color: color,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(tx.category, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                    const SizedBox(height: 3),
                    Text(
                      AppFormatters.displayDate(tx.date),
                      style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              Text(
                '${isIncome ? "+" : "-"}${AppFormatters.currency(tx.amount)}',
                style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 13.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
