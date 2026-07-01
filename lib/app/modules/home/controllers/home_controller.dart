import 'package:get/get.dart';

import '../../../data/repositories/crop_repository.dart';
import '../../../data/repositories/farm_repository.dart';
import '../../../data/repositories/livestock_repository.dart';
import '../../../data/repositories/task_repository.dart';
import '../../../data/repositories/transaction_repository.dart';
import '../../../utils/constants.dart';

/// Controls the bottom-navigation tab index for the main app shell and
/// aggregates the summary metrics shown on the Dashboard tab.
class HomeController extends GetxController {
  final CropRepository _cropRepo = CropRepository();
  final LivestockRepository _livestockRepo = LivestockRepository();
  final TransactionRepository _txRepo = TransactionRepository();
  final TaskRepository _taskRepo = TaskRepository();
  final FarmRepository _farmRepo = FarmRepository();

  final RxInt tabIndex = 0.obs;

  // Dashboard summary values
  final RxInt cropCount = 0.obs;
  final RxInt livestockHeadCount = 0.obs;
  final RxDouble totalActiveArea = 0.0.obs;
  final RxDouble netBalance = 0.0.obs;
  final RxDouble totalIncome = 0.0.obs;
  final RxDouble totalExpense = 0.0.obs;
  final RxInt pendingTasks = 0.obs;
  final RxString farmName = AppStrings.appName.obs;
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadDashboard();
  }

  void changeTab(int index) => tabIndex.value = index;

  Future<void> loadDashboard() async {
    isLoading.value = true;
    final results = await Future.wait([
      _cropRepo.countAll(),
      _livestockRepo.totalHeadCount(),
      _cropRepo.totalActiveArea(),
      _txRepo.totalByType(TransactionType.income),
      _txRepo.totalByType(TransactionType.expense),
      _taskRepo.countPending(),
    ]);

cropCount.value          = results[0].toInt();
livestockHeadCount.value = results[1].toInt();
totalActiveArea.value    = results[2].toDouble();
totalIncome.value        = results[3].toDouble();
totalExpense.value       = results[4].toDouble();
netBalance.value         = totalIncome.value - totalExpense.value;
pendingTasks.value       = results[5].toInt();

    final profile = await _farmRepo.getProfile();
    if (profile != null) {
      farmName.value = profile.farmName;
    }

    isLoading.value = false;
  }
}
