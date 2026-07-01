import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/livestock_model.dart';
import '../../../data/repositories/livestock_repository.dart';
import '../../../utils/constants.dart';
import '../../../utils/formatters.dart';
import '../../../widgets/confirm_dialog.dart';

class LivestockController extends GetxController {
  final LivestockRepository _repo = LivestockRepository();

  final RxList<Livestock> animals = <Livestock>[].obs;
  final RxBool isLoading = true.obs;
  final RxString searchQuery = ''.obs;
  final RxString healthFilter = 'All'.obs;

  // ---- Form state ----
  final formKey = GlobalKey<FormState>();
  final animalTypeCtrl = TextEditingController();
  final breedCtrl = TextEditingController();
  final tagIdCtrl = TextEditingController();
  final quantityCtrl = TextEditingController();
  final weightCtrl = TextEditingController();
  final notesCtrl = TextEditingController();

  final Rx<DateTime> dateAcquired = DateTime.now().obs;
  final Rx<DateTime?> lastVaccinationDate = Rx<DateTime?>(null);
  final RxString healthStatus = HealthStatus.healthy.obs;
  final RxString gender = 'Mixed'.obs;

  int? _editingId;
  bool get isEditing => _editingId != null;

  @override
  void onInit() {
    super.onInit();
    loadAnimals();
  }

  @override
  void onClose() {
    animalTypeCtrl.dispose();
    breedCtrl.dispose();
    tagIdCtrl.dispose();
    quantityCtrl.dispose();
    weightCtrl.dispose();
    notesCtrl.dispose();
    super.onClose();
  }

  Future<void> loadAnimals() async {
    isLoading.value = true;
    animals.value = await _repo.getAll();
    isLoading.value = false;
  }

  List<Livestock> get filteredAnimals {
    return animals.where((a) {
      final matchesSearch = searchQuery.value.isEmpty ||
          a.animalType.toLowerCase().contains(searchQuery.value.toLowerCase());
      final matchesHealth =
          healthFilter.value == 'All' || a.healthStatus == healthFilter.value;
      return matchesSearch && matchesHealth;
    }).toList();
  }

  void prepareForCreate() {
    _editingId = null;
    animalTypeCtrl.clear();
    breedCtrl.clear();
    tagIdCtrl.clear();
    quantityCtrl.clear();
    weightCtrl.clear();
    notesCtrl.clear();
    dateAcquired.value = DateTime.now();
    lastVaccinationDate.value = null;
    healthStatus.value = HealthStatus.healthy;
    gender.value = 'Mixed';
  }

  void prepareForEdit(Livestock item) {
    _editingId = item.id;
    animalTypeCtrl.text = item.animalType;
    breedCtrl.text = item.breed ?? '';
    tagIdCtrl.text = item.tagId ?? '';
    quantityCtrl.text = item.quantity.toString();
    weightCtrl.text = item.averageWeightKg?.toString() ?? '';
    notesCtrl.text = item.notes ?? '';
    dateAcquired.value = DateTime.tryParse(item.dateAcquired) ?? DateTime.now();
    lastVaccinationDate.value = item.lastVaccinationDate != null
        ? DateTime.tryParse(item.lastVaccinationDate!)
        : null;
    healthStatus.value = item.healthStatus;
    gender.value = item.gender ?? 'Mixed';
  }

  Future<bool> submit() async {
    if (!formKey.currentState!.validate()) return false;

    final item = Livestock(
      id: _editingId,
      animalType: animalTypeCtrl.text.trim(),
      breed: breedCtrl.text.trim().isEmpty ? null : breedCtrl.text.trim(),
      tagId: tagIdCtrl.text.trim().isEmpty ? null : tagIdCtrl.text.trim(),
      quantity: int.parse(quantityCtrl.text.trim()),
      gender: gender.value,
      averageWeightKg: weightCtrl.text.trim().isEmpty
          ? null
          : double.tryParse(weightCtrl.text.trim()),
      dateAcquired: AppFormatters.toStorageDate(dateAcquired.value),
      healthStatus: healthStatus.value,
      lastVaccinationDate: lastVaccinationDate.value != null
          ? AppFormatters.toStorageDate(lastVaccinationDate.value!)
          : null,
      notes: notesCtrl.text.trim().isEmpty ? null : notesCtrl.text.trim(),
      createdAt: AppFormatters.nowTimestamp(),
    );

    if (isEditing) {
      await _repo.update(item);
    } else {
      await _repo.create(item);
    }
    await loadAnimals();
    return true;
  }

  Future<void> deleteAnimal(Livestock item) async {
    final confirmed = await showConfirmDialog(
      title: 'Delete Livestock Record',
      message:
          'Are you sure you want to delete this "${item.animalType}" record? This cannot be undone.',
    );
    if (confirmed == true && item.id != null) {
      await _repo.delete(item.id!);
      await loadAnimals();
    }
  }
}
