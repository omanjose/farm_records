/// Represents a single livestock / animal batch record.
class Livestock {
  final int? id;
  final String animalType;
  final String? breed;
  final String? tagId;
  final int quantity;
  final String? gender;
  final double? averageWeightKg;
  final String dateAcquired; // ISO 8601 string
  final String healthStatus;
  final String? lastVaccinationDate;
  final String? notes;
  final String createdAt;

  Livestock({
    this.id,
    required this.animalType,
    this.breed,
    this.tagId,
    required this.quantity,
    this.gender,
    this.averageWeightKg,
    required this.dateAcquired,
    required this.healthStatus,
    this.lastVaccinationDate,
    this.notes,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'animal_type': animalType,
      'breed': breed,
      'tag_id': tagId,
      'quantity': quantity,
      'gender': gender,
      'average_weight_kg': averageWeightKg,
      'date_acquired': dateAcquired,
      'health_status': healthStatus,
      'last_vaccination_date': lastVaccinationDate,
      'notes': notes,
      'created_at': createdAt,
    };
  }

  factory Livestock.fromMap(Map<String, dynamic> map) {
    return Livestock(
      id: map['id'] as int?,
      animalType: map['animal_type'] as String,
      breed: map['breed'] as String?,
      tagId: map['tag_id'] as String?,
      quantity: map['quantity'] as int,
      gender: map['gender'] as String?,
      averageWeightKg: (map['average_weight_kg'] as num?)?.toDouble(),
      dateAcquired: map['date_acquired'] as String,
      healthStatus: map['health_status'] as String,
      lastVaccinationDate: map['last_vaccination_date'] as String?,
      notes: map['notes'] as String?,
      createdAt: map['created_at'] as String,
    );
  }

  Livestock copyWith({
    int? id,
    String? animalType,
    String? breed,
    String? tagId,
    int? quantity,
    String? gender,
    double? averageWeightKg,
    String? dateAcquired,
    String? healthStatus,
    String? lastVaccinationDate,
    String? notes,
    String? createdAt,
  }) {
    return Livestock(
      id: id ?? this.id,
      animalType: animalType ?? this.animalType,
      breed: breed ?? this.breed,
      tagId: tagId ?? this.tagId,
      quantity: quantity ?? this.quantity,
      gender: gender ?? this.gender,
      averageWeightKg: averageWeightKg ?? this.averageWeightKg,
      dateAcquired: dateAcquired ?? this.dateAcquired,
      healthStatus: healthStatus ?? this.healthStatus,
      lastVaccinationDate: lastVaccinationDate ?? this.lastVaccinationDate,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
