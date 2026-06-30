import 'package:get/get.dart';
import '../../core/constants/app_constants.dart';
import '../../data/repositories/crop_repository.dart';
import '../../data/repositories/livestock_repository.dart';
import '../../data/repositories/expense_repository.dart';
import '../main/main_controller.dart';

class DashboardController extends GetxController {
  final _cropRepo = CropRepository();
  final _liveRepo = LivestockRepository();
  final _expRepo = ExpenseRepository();

  final isLoading = true.obs;

  // KPIs
  final totalCropRecords = 0.obs;
  final totalCropArea = 0.0.obs;
  final totalLivestock = 0.obs;
  final totalIncome = 0.0.obs;
  final totalExpense = 0.0.obs;
  final overdueVaccinations = 0.obs;

  // Chart data
  final yieldData = <Map<String, dynamic>>[].obs;
  final expenseCategoryData = <Map<String, dynamic>>[].obs;
  final monthlyFlow = <Map<String, dynamic>>[].obs;

  int get farmId => Get.find<MainController>().farmId;
  String get fullName => Get.find<MainController>().fullName;
  String get role => Get.find<MainController>().role;

  @override
  void onReady() {
    super.onReady();
    loadData();
  }

  Future<void> loadData() async {
    isLoading.value = true;
    try {
      await Future.wait([
        _loadCropStats(),
        _loadLivestockStats(),
        _loadFinanceStats(),
        _loadChartData(),
      ]);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _loadCropStats() async {
    final stats = await _cropRepo.getStats(farmId);
    totalCropRecords.value = (stats['total'] as int?) ?? 0;
    totalCropArea.value =
        ((stats['total_area'] as num?) ?? 0).toDouble();
  }

  Future<void> _loadLivestockStats() async {
    final stats = await _liveRepo.getStats(farmId);
    totalLivestock.value = ((stats['total'] as int?) ?? 0);
    final overdue = await _liveRepo.getOverdueVaccinations(farmId);
    overdueVaccinations.value = overdue.length;
  }

  Future<void> _loadFinanceStats() async {
    final summary = await _expRepo.getSummary(farmId);
    totalIncome.value =
        ((summary['total_income'] as num?) ?? 0).toDouble();
    totalExpense.value =
        ((summary['total_expense'] as num?) ?? 0).toDouble();
  }

  Future<void> _loadChartData() async {
    yieldData.value = await _cropRepo.getYieldByCropType(farmId);
    expenseCategoryData.value =
        await _expRepo.getExpenseByCategory(farmId);
    monthlyFlow.value = await _expRepo.getMonthlyFlow(farmId);
  }

  double get netBalance => totalIncome.value - totalExpense.value;
}
