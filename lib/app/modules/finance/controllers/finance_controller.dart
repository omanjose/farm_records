import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/transaction_model.dart';
import '../../../data/repositories/transaction_repository.dart';
import '../../../utils/constants.dart';
import '../../../utils/formatters.dart';
import '../../../widgets/confirm_dialog.dart';

class FinanceController extends GetxController {
  final TransactionRepository _repo = TransactionRepository();

  final RxList<FarmTransaction> transactions = <FarmTransaction>[].obs;
  final RxBool isLoading = true.obs;
  final RxString typeFilter = 'All'.obs;

  final RxDouble totalIncome = 0.0.obs;
  final RxDouble totalExpense = 0.0.obs;
  final RxDouble netBalance = 0.0.obs;

  // ---- Form state ----
  final formKey = GlobalKey<FormState>();
  final amountCtrl = TextEditingController();
  final descriptionCtrl = TextEditingController();

  final RxString type = TransactionType.income.obs;
  final RxString category = IncomeCategories.all.first.obs;
  final Rx<DateTime> date = DateTime.now().obs;

  int? _editingId;
  bool get isEditing => _editingId != null;

  List<String> get categoryOptions =>
      type.value == TransactionType.income ? IncomeCategories.all : ExpenseCategories.all;

  @override
  void onInit() {
    super.onInit();
    loadTransactions();
  }

  @override
  void onClose() {
    amountCtrl.dispose();
    descriptionCtrl.dispose();
    super.onClose();
  }

  Future<void> loadTransactions() async {
    isLoading.value = true;
    transactions.value = await _repo.getAll();
    totalIncome.value = await _repo.totalByType(TransactionType.income);
    totalExpense.value = await _repo.totalByType(TransactionType.expense);
    netBalance.value = totalIncome.value - totalExpense.value;
    isLoading.value = false;
  }

  List<FarmTransaction> get filteredTransactions {
    if (typeFilter.value == 'All') return transactions;
    return transactions.where((t) => t.type == typeFilter.value).toList();
  }

  void switchType(String newType) {
    type.value = newType;
    category.value = categoryOptions.first;
  }

  void prepareForCreate({String? initialType}) {
    _editingId = null;
    amountCtrl.clear();
    descriptionCtrl.clear();
    date.value = DateTime.now();
    type.value = initialType ?? TransactionType.income;
    category.value = categoryOptions.first;
  }

  void prepareForEdit(FarmTransaction tx) {
    _editingId = tx.id;
    amountCtrl.text = tx.amount.toString();
    descriptionCtrl.text = tx.description ?? '';
    date.value = DateTime.tryParse(tx.date) ?? DateTime.now();
    type.value = tx.type;
    category.value = tx.category;
  }

  Future<bool> submit() async {
    if (!formKey.currentState!.validate()) return false;

    final tx = FarmTransaction(
      id: _editingId,
      type: type.value,
      category: category.value,
      amount: double.parse(amountCtrl.text.trim()),
      date: AppFormatters.toStorageDate(date.value),
      description:
          descriptionCtrl.text.trim().isEmpty ? null : descriptionCtrl.text.trim(),
      createdAt: AppFormatters.nowTimestamp(),
    );

    if (isEditing) {
      await _repo.update(tx);
    } else {
      await _repo.create(tx);
    }
    await loadTransactions();
    return true;
  }

  Future<void> deleteTransaction(FarmTransaction tx) async {
    final confirmed = await showConfirmDialog(
      title: 'Delete Transaction',
      message: 'Are you sure you want to delete this record? This cannot be undone.',
    );
    if (confirmed == true && tx.id != null) {
      await _repo.delete(tx.id!);
      await loadTransactions();
    }
  }
}
