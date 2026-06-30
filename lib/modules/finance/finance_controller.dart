import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/app_date_utils.dart';
import '../../core/utils/validators.dart';
import '../../data/models/expense_model.dart';
import '../../data/repositories/expense_repository.dart';
import '../main/main_controller.dart';

class FinanceController extends GetxController {
  final _repo = ExpenseRepository();

  final transactions         = <ExpenseModel>[].obs;
  final filteredTransactions = <ExpenseModel>[].obs;
  final isLoading            = true.obs;    // start with spinner
  final isSaving             = false.obs;

  final totalIncome  = 0.0.obs;
  final totalExpense = 0.0.obs;

  final selectedTypeFilter = ''.obs;

  // Form
  final formKey         = GlobalKey<FormState>();
  final amountCtrl      = TextEditingController();
  final descriptionCtrl = TextEditingController();
  final dateCtrl        = TextEditingController();
  final selectedType     = 'Expense'.obs;
  final selectedCategory = AppConstants.expenseCategories.first.obs;

  ExpenseModel? _editing;
  bool get isEditing => _editing != null;

  int get farmId => Get.find<MainController>().farmId;

  List<String> get categoryOptions => selectedType.value == 'Income'
      ? AppConstants.incomeCategories
      : AppConstants.expenseCategories;

  @override
  void onReady() {
    super.onReady();
    loadTransactions();
  }

  Future<void> loadTransactions() async {
    isLoading.value = true;
    try {
      transactions.value = await _repo.getAll(farmId);
      _calcTotals();
      _applyFilter();
    } finally {
      isLoading.value = false;
    }
  }

  void _calcTotals() {
    totalIncome.value  = transactions.where((t) => t.isIncome) .fold(0.0, (s, t) => s + t.amount);
    totalExpense.value = transactions.where((t) => t.isExpense).fold(0.0, (s, t) => s + t.amount);
  }

  void filterByType(String type) {
    selectedTypeFilter.value = type;
    _applyFilter();
  }

  void _applyFilter() {
    filteredTransactions.value = selectedTypeFilter.value.isEmpty
        ? transactions.toList()
        : transactions.where((t) => t.type == selectedTypeFilter.value).toList();
  }

  void prepareNew({String? defaultType}) {
    _editing = null;
    selectedType.value     = defaultType ?? 'Expense';
    selectedCategory.value = categoryOptions.first;
    amountCtrl.clear();
    descriptionCtrl.clear();
    dateCtrl.text = AppDateUtils.today();
  }

  void onTypeChanged(String type) {
    selectedType.value     = type;
    selectedCategory.value = categoryOptions.first;
  }

  void prepareEdit(ExpenseModel expense) {
    _editing = expense;
    selectedType.value     = expense.type;
    selectedCategory.value = expense.category;
    amountCtrl.text        = expense.amount.toStringAsFixed(2);
    descriptionCtrl.text   = expense.description ?? '';
    dateCtrl.text          = expense.transactionDate;
  }

  Future<void> save() async {
    if (!formKey.currentState!.validate()) return;
    isSaving.value = true;
    try {
      final now = DateTime.now().toIso8601String();
      final t   = ExpenseModel(
        id:              _editing?.id,
        farmId:          farmId,
        type:            selectedType.value,
        category:        selectedCategory.value,
        amount:          double.parse(amountCtrl.text.replaceAll(',', '')),
        description:     descriptionCtrl.text.trim().isEmpty ? null : descriptionCtrl.text.trim(),
        transactionDate: dateCtrl.text,
        createdAt:       _editing?.createdAt ?? now,
      );

      if (isEditing) {
        await _repo.update(t);
      } else {
        await _repo.create(t);
      }

      await loadTransactions();
      Get.back();

      final isInc = selectedType.value == 'Income';
      Get.snackbar(
        isEditing ? 'Updated' : 'Saved',
        'Transaction ${isEditing ? 'updated' : 'recorded'} successfully.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: isInc ? Colors.green.shade700 : Colors.blue.shade700,  // ← fixed
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 10,
        duration: const Duration(seconds: 2),
      );
    } catch (_) {
      Get.snackbar('Error', 'Failed to save. Please try again.',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> delete(ExpenseModel expense) async {
    final confirmed = await Get.defaultDialog<bool>(
      title: 'Delete Transaction',
      middleText: 'Delete this ${expense.type.toLowerCase()} entry?',
      textConfirm: 'Delete',
      textCancel: 'Cancel',
      confirmTextColor: Colors.white,
      buttonColor: Colors.red.shade700,              // ← fixed
      onConfirm: () => Get.back(result: true),
      onCancel:  () => Get.back(result: false),
    );
    if (confirmed != true) return;
    await _repo.delete(expense.id!);
    await loadTransactions();
    Get.snackbar('Deleted', 'Transaction removed.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2));
  }

  double get netBalance => totalIncome.value - totalExpense.value;

  String? validateAmount(String? v) => Validators.positiveNumber(v, 'Amount');
  String? validateDate(String? v)   => Validators.required(v, 'Date');

  @override
  void onClose() {
    amountCtrl.dispose();
    descriptionCtrl.dispose();
    dateCtrl.dispose();
    super.onClose();
  }
}
