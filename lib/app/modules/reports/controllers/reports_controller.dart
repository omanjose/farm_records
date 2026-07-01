import 'package:get/get.dart';

import '../../../data/repositories/crop_repository.dart';
import '../../../data/repositories/livestock_repository.dart';
import '../../../data/repositories/transaction_repository.dart';
import '../../../utils/constants.dart';

/// Aggregates data across all record types to power the Reports &
/// Analytics screen (financial summary, crop status split, top expense
/// categories, livestock health split).
class ReportsController extends GetxController {
  final CropRepository _cropRepo = CropRepository();
  final LivestockRepository _livestockRepo = LivestockRepository();
  final TransactionRepository _txRepo = TransactionRepository();

  final RxBool isLoading = true.obs;

  final RxDouble totalIncome = 0.0.obs;
  final RxDouble totalExpense = 0.0.obs;
  final RxMap<String, double> expenseByCategory = <String, double>{}.obs;
  final RxMap<String, double> incomeByCategory = <String, double>{}.obs;

  final RxMap<String, int> cropsByStatus = <String, int>{}.obs;
  final RxMap<String, int> livestockByHealth = <String, int>{}.obs;

  @override
  void onInit() {
    super.onInit();
    loadReports();
  }

  Future<void> loadReports() async {
    isLoading.value = true;

    totalIncome.value = await _txRepo.totalByType(TransactionType.income);
    totalExpense.value = await _txRepo.totalByType(TransactionType.expense);
    expenseByCategory.value =
        await _txRepo.totalsByCategory(TransactionType.expense);
    incomeByCategory.value =
        await _txRepo.totalsByCategory(TransactionType.income);

    final cropStatusCounts = <String, int>{};
    for (final status in CropStatus.all) {
      cropStatusCounts[status] = await _cropRepo.countByStatus(status);
    }
    cropsByStatus.value = cropStatusCounts;

    final healthCounts = <String, int>{};
    for (final status in HealthStatus.all) {
      healthCounts[status] = await _livestockRepo.countByHealthStatus(status);
    }
    livestockByHealth.value = healthCounts;

    isLoading.value = false;
  }
}
