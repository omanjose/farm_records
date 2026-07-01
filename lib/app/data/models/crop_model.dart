/// Represents a single crop production record.
class Crop {
  final int? id;
  final String cropName;
  final String? variety;
  final String? fieldLocation;
  final double areaPlanted; // in acres
  final String plantingDate; // ISO 8601 string
  final String? expectedHarvestDate;
  final String? actualHarvestDate;
  final double? expectedYieldKg;
  final double? actualYieldKg;
  final String status;
  final String? notes;
  final String createdAt;

  Crop({
    this.id,
    required this.cropName,
    this.variety,
    this.fieldLocation,
    required this.areaPlanted,
    required this.plantingDate,
    this.expectedHarvestDate,
    this.actualHarvestDate,
    this.expectedYieldKg,
    this.actualYieldKg,
    required this.status,
    this.notes,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'crop_name': cropName,
      'variety': variety,
      'field_location': fieldLocation,
      'area_planted': areaPlanted,
      'planting_date': plantingDate,
      'expected_harvest_date': expectedHarvestDate,
      'actual_harvest_date': actualHarvestDate,
      'expected_yield_kg': expectedYieldKg,
      'actual_yield_kg': actualYieldKg,
      'status': status,
      'notes': notes,
      'created_at': createdAt,
    };
  }

  factory Crop.fromMap(Map<String, dynamic> map) {
    return Crop(
      id: map['id'] as int?,
      cropName: map['crop_name'] as String,
      variety: map['variety'] as String?,
      fieldLocation: map['field_location'] as String?,
      areaPlanted: (map['area_planted'] as num).toDouble(),
      plantingDate: map['planting_date'] as String,
      expectedHarvestDate: map['expected_harvest_date'] as String?,
      actualHarvestDate: map['actual_harvest_date'] as String?,
      expectedYieldKg: (map['expected_yield_kg'] as num?)?.toDouble(),
      actualYieldKg: (map['actual_yield_kg'] as num?)?.toDouble(),
      status: map['status'] as String,
      notes: map['notes'] as String?,
      createdAt: map['created_at'] as String,
    );
  }

  Crop copyWith({
    int? id,
    String? cropName,
    String? variety,
    String? fieldLocation,
    double? areaPlanted,
    String? plantingDate,
    String? expectedHarvestDate,
    String? actualHarvestDate,
    double? expectedYieldKg,
    double? actualYieldKg,
    String? status,
    String? notes,
    String? createdAt,
  }) {
    return Crop(
      id: id ?? this.id,
      cropName: cropName ?? this.cropName,
      variety: variety ?? this.variety,
      fieldLocation: fieldLocation ?? this.fieldLocation,
      areaPlanted: areaPlanted ?? this.areaPlanted,
      plantingDate: plantingDate ?? this.plantingDate,
      expectedHarvestDate: expectedHarvestDate ?? this.expectedHarvestDate,
      actualHarvestDate: actualHarvestDate ?? this.actualHarvestDate,
      expectedYieldKg: expectedYieldKg ?? this.expectedYieldKg,
      actualYieldKg: actualYieldKg ?? this.actualYieldKg,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
