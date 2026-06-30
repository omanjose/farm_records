import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/app_date_utils.dart';
import '../../core/utils/validators.dart';
import '../../data/models/crop_model.dart';
import '../../data/repositories/crop_repository.dart';
import '../main/main_controller.dart';

class CropController extends GetxController {
  final _repo = CropRepository();

  final crops           = <CropModel>[].obs;
  final filteredCrops   = <CropModel>[].obs;
  final isLoading       = true.obs;   // start with spinner
  final isSaving        = false.obs;
  final selectedStatus  = ''.obs;

  // Form
  final formKey             = GlobalKey<FormState>();
  final seedVarietyCtrl     = TextEditingController();
  final areaCtrl            = TextEditingController();
  final datePlantedCtrl     = TextEditingController();
  final expectedYieldCtrl   = TextEditingController();
  final actualYieldCtrl     = TextEditingController();
  final fertilizerCtrl      = TextEditingController();
  final notesCtrl           = TextEditingController();
  final selectedCropType    = AppConstants.cropTypes.first.obs;
  final selectedSeason      = AppConstants.seasons.first.obs;
  final selectedCropStatus  = AppConstants.cropStatuses.first.obs;

  CropModel? _editing;
  bool get isEditing => _editing != null;

  int get farmId => Get.find<MainController>().farmId;

  @override
  void onReady() {
    super.onReady();
    loadCrops();
  }

  Future<void> loadCrops() async {
    isLoading.value = true;
    try {
      final data = await _repo.getAll(farmId);
      crops.value = data;
      _applyFilter();
    } finally {
      isLoading.value = false;
    }
  }

  void filterByStatus(String status) {
    selectedStatus.value = status;
    _applyFilter();
  }

  void _applyFilter() {
    filteredCrops.value = selectedStatus.value.isEmpty
        ? crops.toList()
        : crops.where((c) => c.status == selectedStatus.value).toList();
  }

  void prepareNew() {
    _editing = null;
    _clearForm();
    datePlantedCtrl.text = AppDateUtils.today();
  }

  void prepareEdit(CropModel crop) {
    _editing = crop;
    selectedCropType.value   = crop.cropType;
    seedVarietyCtrl.text     = crop.seedVariety ?? '';
    areaCtrl.text            = crop.areaHa.toString();
    datePlantedCtrl.text     = crop.datePlanted;
    expectedYieldCtrl.text   = crop.expectedYieldKg?.toString() ?? '';
    actualYieldCtrl.text     = crop.actualYieldKg?.toString()   ?? '';
    fertilizerCtrl.text      = crop.fertilizerUsed              ?? '';
    selectedSeason.value     = crop.season;
    selectedCropStatus.value = crop.status;
    notesCtrl.text           = crop.notes                       ?? '';
  }

  Future<void> save() async {
    if (!formKey.currentState!.validate()) return;
    isSaving.value = true;
    try {
      final now  = DateTime.now().toIso8601String();
      final crop = CropModel(
        id:               _editing?.id,
        farmId:           farmId,
        cropType:         selectedCropType.value,
        seedVariety:      seedVarietyCtrl.text.trim().isEmpty   ? null : seedVarietyCtrl.text.trim(),
        areaHa:           double.parse(areaCtrl.text),
        datePlanted:      datePlantedCtrl.text,
        expectedYieldKg:  expectedYieldCtrl.text.isEmpty ? null : double.tryParse(expectedYieldCtrl.text),
        actualYieldKg:    actualYieldCtrl.text.isEmpty   ? null : double.tryParse(actualYieldCtrl.text),
        fertilizerUsed:   fertilizerCtrl.text.trim().isEmpty    ? null : fertilizerCtrl.text.trim(),
        season:           selectedSeason.value,
        status:           selectedCropStatus.value,
        notes:            notesCtrl.text.trim().isEmpty          ? null : notesCtrl.text.trim(),
        createdAt:        _editing?.createdAt ?? now,
      );

      if (isEditing) {
        await _repo.update(crop);
      } else {
        await _repo.create(crop);
      }

      await loadCrops();
      Get.back();
      Get.snackbar(
        isEditing ? 'Updated' : 'Saved',
        'Crop record ${isEditing ? 'updated' : 'created'} successfully.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade700,   // ← fixed
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

  Future<void> delete(CropModel crop) async {
    final confirmed = await Get.defaultDialog<bool>(
      title: 'Delete Record',
      middleText: 'Delete ${crop.cropType} record? This cannot be undone.',
      textConfirm: 'Delete',
      textCancel: 'Cancel',
      confirmTextColor: Colors.white,
      buttonColor: Colors.red.shade700,            // ← fixed
      onConfirm: () => Get.back(result: true),
      onCancel:  () => Get.back(result: false),
    );
    if (confirmed != true) return;
    await _repo.delete(crop.id!);
    await loadCrops();
    Get.snackbar('Deleted', 'Crop record removed.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2));
  }

  void _clearForm() {
    selectedCropType.value   = AppConstants.cropTypes.first;
    seedVarietyCtrl.clear();
    areaCtrl.clear();
    datePlantedCtrl.clear();
    expectedYieldCtrl.clear();
    actualYieldCtrl.clear();
    fertilizerCtrl.clear();
    selectedSeason.value     = AppConstants.seasons.first;
    selectedCropStatus.value = AppConstants.cropStatuses.first;
    notesCtrl.clear();
  }

  String? validateRequired(String? v)  => Validators.required(v);
  String? validateArea(String? v)       => Validators.positiveNumber(v, 'Area');
  String? validateDate(String? v)       => Validators.required(v, 'Date');

  @override
  void onClose() {
    seedVarietyCtrl.dispose();
    areaCtrl.dispose();
    datePlantedCtrl.dispose();
    expectedYieldCtrl.dispose();
    actualYieldCtrl.dispose();
    fertilizerCtrl.dispose();
    notesCtrl.dispose();
    super.onClose();
  }
}
