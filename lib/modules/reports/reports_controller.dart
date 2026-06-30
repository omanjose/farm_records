import 'package:get/get.dart';
import '../../data/models/crop_model.dart';
import '../../data/models/livestock_model.dart';
import '../../data/models/expense_model.dart';
import '../../data/repositories/crop_repository.dart';
import '../../data/repositories/livestock_repository.dart';
import '../../data/repositories/expense_repository.dart';
import '../main/main_controller.dart';

class ReportsController extends GetxController {
  final _cropRepo = CropRepository();
  final _liveRepo = LivestockRepository();
  final _expRepo = ExpenseRepository();

  final isLoading = true.obs;

  // Crop
  final crops = <CropModel>[].obs;
  final cropStats = <String, dynamic>{}.obs;
  final yieldByCrop = <Map<String, dynamic>>[].obs;

  // Livestock
  final livestock = <LivestockModel>[].obs;
  final livestockStats = <String, dynamic>{}.obs;
  final animalTypes = <Map<String, dynamic>>[].obs;

  // Finance
  final financeSummary = <String, dynamic>{}.obs;
  final expenseByCategory = <Map<String, dynamic>>[].obs;
  final monthlyFlow = <Map<String, dynamic>>[].obs;
  final allTransactions = <ExpenseModel>[].obs;

  int get farmId => Get.find<MainController>().farmId;

  @override
  void onReady() {
    super.onReady();
    loadAll();
  }

  Future<void> loadAll() async {
    isLoading.value = true;
    try {
      await Future.wait([
        _loadCrops(),
        _loadLivestock(),
        _loadFinance(),
      ]);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _loadCrops() async {
    crops.value = await _cropRepo.getAll(farmId);
    cropStats.value = await _cropRepo.getStats(farmId);
    yieldByCrop.value = await _cropRepo.getYieldByCropType(farmId);
  }

  Future<void> _loadLivestock() async {
    livestock.value = await _liveRepo.getAll(farmId);
    livestockStats.value = await _liveRepo.getStats(farmId);
    animalTypes.value = await _liveRepo.getByAnimalType(farmId);
  }

  Future<void> _loadFinance() async {
    allTransactions.value = await _expRepo.getAll(farmId);
    financeSummary.value = await _expRepo.getSummary(farmId);
    expenseByCategory.value = await _expRepo.getExpenseByCategory(farmId);
    monthlyFlow.value = await _expRepo.getMonthlyFlow(farmId);
  }

  // ── Convenience getters ────────────────────────────────────────────────────
  int get totalCropRecords =>
      (cropStats['total'] as int?) ?? crops.length;
  double get totalCropArea =>
      ((cropStats['total_area'] as num?) ?? 0).toDouble();
  int get harvestedCrops =>
      (cropStats['harvested'] as int?) ?? 0;
  int get growingCrops =>
      (cropStats['growing'] as int?) ?? 0;
  double get totalExpectedYield =>
      ((cropStats['expected_yield'] as num?) ?? 0).toDouble();
  double get totalActualYield =>
      ((cropStats['actual_yield'] as num?) ?? 0).toDouble();

  int get totalAnimalTypes =>
      (livestockStats['types'] as int?) ?? 0;
  int get totalHeadcount =>
      (livestockStats['total'] as int?) ?? 0;
  int get healthyCount =>
      (livestockStats['healthy'] as int?) ?? 0;
  int get attentionCount =>
      (livestockStats['attention'] as int?) ?? 0;

  double get totalIncome =>
      ((financeSummary['total_income'] as num?) ?? 0).toDouble();
  double get totalExpense =>
      ((financeSummary['total_expense'] as num?) ?? 0).toDouble();
  double get netBalance => totalIncome - totalExpense;
  int get totalTransactions =>
      (financeSummary['total_transactions'] as int?) ?? 0;

  double get yieldEfficiency {
    if (totalExpectedYield <= 0) return 0;
    return (totalActualYield / totalExpectedYield) * 100;
  }
}
