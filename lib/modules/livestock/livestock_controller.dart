import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/validators.dart';
import '../../data/models/livestock_model.dart';
import '../../data/repositories/livestock_repository.dart';
import '../main/main_controller.dart';

class LivestockController extends GetxController {
  final _repo = LivestockRepository();

  final livestock  = <LivestockModel>[].obs;
  final isLoading  = true.obs;   // start with spinner
  final isSaving   = false.obs;

  // Form
  final formKey               = GlobalKey<FormState>();
  final breedCtrl             = TextEditingController();
  final quantityCtrl          = TextEditingController();
  final notesCtrl             = TextEditingController();
  final vaccinationDateCtrl   = TextEditingController();
  final nextVaccinationCtrl   = TextEditingController();
  final selectedAnimalType    = AppConstants.animalTypes.first.obs;
  final selectedHealthStatus  = AppConstants.healthStatuses.first.obs;

  LivestockModel? _editing;
  bool get isEditing => _editing != null;

  int get farmId => Get.find<MainController>().farmId;

  @override
  void onReady() {
    super.onReady();
    loadLivestock();
  }

  Future<void> loadLivestock() async {
    isLoading.value = true;
    try {
      livestock.value = await _repo.getAll(farmId);
    } finally {
      isLoading.value = false;
    }
  }

  void prepareNew() {
    _editing = null;
    _clearForm();
  }

  void prepareEdit(LivestockModel item) {
    _editing = item;
    selectedAnimalType.value   = item.animalType;
    breedCtrl.text             = item.breed            ?? '';
    quantityCtrl.text          = item.quantity.toString();
    selectedHealthStatus.value = item.healthStatus;
    vaccinationDateCtrl.text   = item.vaccinationDate  ?? '';
    nextVaccinationCtrl.text   = item.nextVaccination  ?? '';
    notesCtrl.text             = item.notes            ?? '';
  }

  Future<void> save() async {
    if (!formKey.currentState!.validate()) return;
    isSaving.value = true;
    try {
      final now  = DateTime.now().toIso8601String();
      final item = LivestockModel(
        id:               _editing?.id,
        farmId:           farmId,
        animalType:       selectedAnimalType.value,
        breed:            breedCtrl.text.trim().isEmpty    ? null : breedCtrl.text.trim(),
        quantity:         int.parse(quantityCtrl.text),
        healthStatus:     selectedHealthStatus.value,
        vaccinationDate:  vaccinationDateCtrl.text.isEmpty ? null : vaccinationDateCtrl.text,
        nextVaccination:  nextVaccinationCtrl.text.isEmpty ? null : nextVaccinationCtrl.text,
        notes:            notesCtrl.text.trim().isEmpty    ? null : notesCtrl.text.trim(),
        createdAt:        _editing?.createdAt              ?? now,
      );

      if (isEditing) {
        await _repo.update(item);
      } else {
        await _repo.create(item);
      }

      await loadLivestock();
      Get.back();
      Get.snackbar(
        isEditing ? 'Updated' : 'Saved',
        'Livestock record ${isEditing ? 'updated' : 'added'} successfully.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade700,     // ← fixed
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

  Future<void> delete(LivestockModel item) async {
    final confirmed = await Get.defaultDialog<bool>(
      title: 'Delete Record',
      middleText: 'Delete ${item.animalType} record? This cannot be undone.',
      textConfirm: 'Delete',
      textCancel: 'Cancel',
      confirmTextColor: Colors.white,
      buttonColor: Colors.red.shade700,              // ← fixed
      onConfirm: () => Get.back(result: true),
      onCancel:  () => Get.back(result: false),
    );
    if (confirmed != true) return;
    await _repo.delete(item.id!);
    await loadLivestock();
    Get.snackbar('Deleted', 'Livestock record removed.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2));
  }

  void _clearForm() {
    selectedAnimalType.value   = AppConstants.animalTypes.first;
    breedCtrl.clear();
    quantityCtrl.clear();
    selectedHealthStatus.value = AppConstants.healthStatuses.first;
    vaccinationDateCtrl.clear();
    nextVaccinationCtrl.clear();
    notesCtrl.clear();
  }

  String? validateQuantity(String? v) => Validators.integer(v, 'Quantity');

  @override
  void onClose() {
    breedCtrl.dispose();
    quantityCtrl.dispose();
    notesCtrl.dispose();
    vaccinationDateCtrl.dispose();
    nextVaccinationCtrl.dispose();
    super.onClose();
  }
}
