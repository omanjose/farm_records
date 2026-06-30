class CropModel {
  final int? id;
  final int farmId;
  final String cropType;
  final String? seedVariety;
  final double areaHa;
  final String datePlanted;
  final double? expectedYieldKg;
  final double? actualYieldKg;
  final String? fertilizerUsed;
  final String season;
  final String status;
  final String? notes;
  final String createdAt;

  const CropModel({
    this.id,
    required this.farmId,
    required this.cropType,
    this.seedVariety,
    required this.areaHa,
    required this.datePlanted,
    this.expectedYieldKg,
    this.actualYieldKg,
    this.fertilizerUsed,
    required this.season,
    required this.status,
    this.notes,
    required this.createdAt,
  });

  factory CropModel.fromMap(Map<String, dynamic> m) => CropModel(
        id: m['id'] as int?,
        farmId: m['farm_id'] as int,
        cropType: m['crop_type'] as String,
        seedVariety: m['seed_variety'] as String?,
        areaHa: (m['area_ha'] as num).toDouble(),
        datePlanted: m['date_planted'] as String,
        expectedYieldKg: m['expected_yield_kg'] != null
            ? (m['expected_yield_kg'] as num).toDouble()
            : null,
        actualYieldKg: m['actual_yield_kg'] != null
            ? (m['actual_yield_kg'] as num).toDouble()
            : null,
        fertilizerUsed: m['fertilizer_used'] as String?,
        season: m['season'] as String,
        status: m['status'] as String,
        notes: m['notes'] as String?,
        createdAt: m['created_at'] as String,
      );

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'farm_id': farmId,
        'crop_type': cropType,
        if (seedVariety != null) 'seed_variety': seedVariety,
        'area_ha': areaHa,
        'date_planted': datePlanted,
        if (expectedYieldKg != null) 'expected_yield_kg': expectedYieldKg,
        if (actualYieldKg != null) 'actual_yield_kg': actualYieldKg,
        if (fertilizerUsed != null) 'fertilizer_used': fertilizerUsed,
        'season': season,
        'status': status,
        if (notes != null) 'notes': notes,
        'created_at': createdAt,
      };

  CropModel copyWith({
    int? id,
    int? farmId,
    String? cropType,
    String? seedVariety,
    double? areaHa,
    String? datePlanted,
    double? expectedYieldKg,
    double? actualYieldKg,
    String? fertilizerUsed,
    String? season,
    String? status,
    String? notes,
    String? createdAt,
  }) =>
      CropModel(
        id: id ?? this.id,
        farmId: farmId ?? this.farmId,
        cropType: cropType ?? this.cropType,
        seedVariety: seedVariety ?? this.seedVariety,
        areaHa: areaHa ?? this.areaHa,
        datePlanted: datePlanted ?? this.datePlanted,
        expectedYieldKg: expectedYieldKg ?? this.expectedYieldKg,
        actualYieldKg: actualYieldKg ?? this.actualYieldKg,
        fertilizerUsed: fertilizerUsed ?? this.fertilizerUsed,
        season: season ?? this.season,
        status: status ?? this.status,
        notes: notes ?? this.notes,
        createdAt: createdAt ?? this.createdAt,
      );

  double get yieldEfficiency {
    if (expectedYieldKg == null || expectedYieldKg! <= 0) return 0;
    if (actualYieldKg == null) return 0;
    return (actualYieldKg! / expectedYieldKg!) * 100;
  }
}
