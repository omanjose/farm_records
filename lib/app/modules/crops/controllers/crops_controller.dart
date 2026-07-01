import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/crop_model.dart';
import '../../../data/repositories/crop_repository.dart';
import '../../../utils/constants.dart';
import '../../../utils/formatters.dart';
import '../../../widgets/confirm_dialog.dart';

/// Manages the list of crop records plus the add/edit form state.
class CropsController extends GetxController {
  final CropRepository _repo = CropRepository();

  final RxList<Crop> crops = <Crop>[].obs;
  final RxBool isLoading = true.obs;
  final RxString searchQuery = ''.obs;
  final RxString statusFilter = 'All'.obs;

  // ---- Form state ----
  final formKey = GlobalKey<FormState>();
  final cropNameCtrl = TextEditingController();
  final varietyCtrl = TextEditingController();
  final fieldLocationCtrl = TextEditingController();
  final areaPlantedCtrl = TextEditingController();
  final expectedYieldCtrl = TextEditingController();
  final actualYieldCtrl = TextEditingController();
  final notesCtrl = TextEditingController();

  final Rx<DateTime> plantingDate = DateTime.now().obs;
  final Rx<DateTime?> expectedHarvestDate = Rx<DateTime?>(null);
  final Rx<DateTime?> actualHarvestDate = Rx<DateTime?>(null);
  final RxString status = CropStatus.planted.obs;

  int? _editingId;
  bool get isEditing => _editingId != null;

  @override
  void onInit() {
    super.onInit();
    loadCrops();
  }

  @override
  void onClose() {
    cropNameCtrl.dispose();
    varietyCtrl.dispose();
    fieldLocationCtrl.dispose();
    areaPlantedCtrl.dispose();
    expectedYieldCtrl.dispose();
    actualYieldCtrl.dispose();
    notesCtrl.dispose();
    super.onClose();
  }

  Future<void> loadCrops() async {
    isLoading.value = true;
    crops.value = await _repo.getAll();
    isLoading.value = false;
  }

  List<Crop> get filteredCrops {
    return crops.where((c) {
      final matchesSearch = searchQuery.value.isEmpty ||
          c.cropName.toLowerCase().contains(searchQuery.value.toLowerCase());
      final matchesStatus =
          statusFilter.value == 'All' || c.status == statusFilter.value;
      return matchesSearch && matchesStatus;
    }).toList();
  }

  void prepareForCreate() {
    _editingId = null;
    cropNameCtrl.clear();
    varietyCtrl.clear();
    fieldLocationCtrl.clear();
    areaPlantedCtrl.clear();
    expectedYieldCtrl.clear();
    actualYieldCtrl.clear();
    notesCtrl.clear();
    plantingDate.value = DateTime.now();
    expectedHarvestDate.value = null;
    actualHarvestDate.value = null;
    status.value = CropStatus.planted;
  }

  void prepareForEdit(Crop crop) {
    _editingId = crop.id;
    cropNameCtrl.text = crop.cropName;
    varietyCtrl.text = crop.variety ?? '';
    fieldLocationCtrl.text = crop.fieldLocation ?? '';
    areaPlantedCtrl.text = crop.areaPlanted.toString();
    expectedYieldCtrl.text = crop.expectedYieldKg?.toString() ?? '';
    actualYieldCtrl.text = crop.actualYieldKg?.toString() ?? '';
    notesCtrl.text = crop.notes ?? '';
    plantingDate.value = DateTime.tryParse(crop.plantingDate) ?? DateTime.now();
    expectedHarvestDate.value = crop.expectedHarvestDate != null
        ? DateTime.tryParse(crop.expectedHarvestDate!)
        : null;
    actualHarvestDate.value = crop.actualHarvestDate != null
        ? DateTime.tryParse(crop.actualHarvestDate!)
        : null;
    status.value = crop.status;
  }

  Future<bool> submit() async {
    if (!formKey.currentState!.validate()) return false;

    final crop = Crop(
      id: _editingId,
      cropName: cropNameCtrl.text.trim(),
      variety: varietyCtrl.text.trim().isEmpty ? null : varietyCtrl.text.trim(),
      fieldLocation: fieldLocationCtrl.text.trim().isEmpty
          ? null
          : fieldLocationCtrl.text.trim(),
      areaPlanted: double.parse(areaPlantedCtrl.text.trim()),
      plantingDate: AppFormatters.toStorageDate(plantingDate.value),
      expectedHarvestDate: expectedHarvestDate.value != null
          ? AppFormatters.toStorageDate(expectedHarvestDate.value!)
          : null,
      actualHarvestDate: actualHarvestDate.value != null
          ? AppFormatters.toStorageDate(actualHarvestDate.value!)
          : null,
      expectedYieldKg: expectedYieldCtrl.text.trim().isEmpty
          ? null
          : double.tryParse(expectedYieldCtrl.text.trim()),
      actualYieldKg: actualYieldCtrl.text.trim().isEmpty
          ? null
          : double.tryParse(actualYieldCtrl.text.trim()),
      status: status.value,
      notes: notesCtrl.text.trim().isEmpty ? null : notesCtrl.text.trim(),
      createdAt: AppFormatters.nowTimestamp(),
    );

    if (isEditing) {
      await _repo.update(crop);
    } else {
      await _repo.create(crop);
    }
    await loadCrops();
    return true;
  }

  Future<void> deleteCrop(Crop crop) async {
    final confirmed = await showConfirmDialog(
      title: 'Delete Crop Record',
      message:
          'Are you sure you want to delete "${crop.cropName}"? This cannot be undone.',
    );
    if (confirmed == true && crop.id != null) {
      await _repo.delete(crop.id!);
      await loadCrops();
    }
  }
}
