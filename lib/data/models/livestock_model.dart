class LivestockModel {
  final int? id;
  final int farmId;
  final String animalType;
  final String? breed;
  final int quantity;
  final String healthStatus;
  final String? vaccinationDate;
  final String? nextVaccination;
  final String? notes;
  final String createdAt;

  const LivestockModel({
    this.id,
    required this.farmId,
    required this.animalType,
    this.breed,
    required this.quantity,
    required this.healthStatus,
    this.vaccinationDate,
    this.nextVaccination,
    this.notes,
    required this.createdAt,
  });

  factory LivestockModel.fromMap(Map<String, dynamic> m) => LivestockModel(
        id: m['id'] as int?,
        farmId: m['farm_id'] as int,
        animalType: m['animal_type'] as String,
        breed: m['breed'] as String?,
        quantity: m['quantity'] as int,
        healthStatus: m['health_status'] as String,
        vaccinationDate: m['vaccination_date'] as String?,
        nextVaccination: m['next_vaccination'] as String?,
        notes: m['notes'] as String?,
        createdAt: m['created_at'] as String,
      );

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'farm_id': farmId,
        'animal_type': animalType,
        if (breed != null) 'breed': breed,
        'quantity': quantity,
        'health_status': healthStatus,
        if (vaccinationDate != null) 'vaccination_date': vaccinationDate,
        if (nextVaccination != null) 'next_vaccination': nextVaccination,
        if (notes != null) 'notes': notes,
        'created_at': createdAt,
      };

  LivestockModel copyWith({
    int? id,
    int? farmId,
    String? animalType,
    String? breed,
    int? quantity,
    String? healthStatus,
    String? vaccinationDate,
    String? nextVaccination,
    String? notes,
    String? createdAt,
  }) =>
      LivestockModel(
        id: id ?? this.id,
        farmId: farmId ?? this.farmId,
        animalType: animalType ?? this.animalType,
        breed: breed ?? this.breed,
        quantity: quantity ?? this.quantity,
        healthStatus: healthStatus ?? this.healthStatus,
        vaccinationDate: vaccinationDate ?? this.vaccinationDate,
        nextVaccination: nextVaccination ?? this.nextVaccination,
        notes: notes ?? this.notes,
        createdAt: createdAt ?? this.createdAt,
      );

  bool get vaccinationOverdue {
    if (nextVaccination == null) return false;
    final date = DateTime.tryParse(nextVaccination!);
    return date != null && date.isBefore(DateTime.now());
  }
}
