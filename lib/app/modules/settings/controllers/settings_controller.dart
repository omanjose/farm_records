import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/farm_profile_model.dart';
import '../../../data/repositories/farm_repository.dart';
import '../../../utils/validators.dart';

class SettingsController extends GetxController {
  final FarmRepository _repo = FarmRepository();

  final Rx<FarmProfile?> profile = Rx<FarmProfile?>(null);
  final RxBool isLoading = true.obs;

  final formKey = GlobalKey<FormState>();
  final farmNameCtrl = TextEditingController();
  final ownerNameCtrl = TextEditingController();
  final locationCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final farmSizeCtrl = TextEditingController();
  final notesCtrl = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }

  @override
  void onClose() {
    farmNameCtrl.dispose();
    ownerNameCtrl.dispose();
    locationCtrl.dispose();
    phoneCtrl.dispose();
    emailCtrl.dispose();
    farmSizeCtrl.dispose();
    notesCtrl.dispose();
    super.onClose();
  }

  Future<void> loadProfile() async {
    isLoading.value = true;
    profile.value = await _repo.getProfile();
    _populateForm();
    isLoading.value = false;
  }

  void _populateForm() {
    final p = profile.value;
    farmNameCtrl.text = p?.farmName ?? 'MOUAU Agro Farm';
    ownerNameCtrl.text = p?.ownerName ?? '';
    locationCtrl.text = p?.location ?? '';
    phoneCtrl.text = p?.phone ?? '';
    emailCtrl.text = p?.email ?? '';
    farmSizeCtrl.text = p?.farmSizeAcres?.toString() ?? '';
    notesCtrl.text = p?.notes ?? '';
  }

  Future<bool> submit() async {
    if (!formKey.currentState!.validate()) return false;

    final updated = FarmProfile(
      id: profile.value?.id,
      farmName: farmNameCtrl.text.trim(),
      ownerName: ownerNameCtrl.text.trim(),
      location: locationCtrl.text.trim(),
      phone: phoneCtrl.text.trim().isEmpty ? null : phoneCtrl.text.trim(),
      email: emailCtrl.text.trim().isEmpty ? null : emailCtrl.text.trim(),
      farmSizeAcres: farmSizeCtrl.text.trim().isEmpty
          ? null
          : double.tryParse(farmSizeCtrl.text.trim()),
      establishedDate: profile.value?.establishedDate,
      notes: notesCtrl.text.trim().isEmpty ? null : notesCtrl.text.trim(),
    );

    await _repo.saveProfile(updated);
    await loadProfile();
    return true;
  }

  String? validateEmail(String? v) => Validators.email(v);
}
