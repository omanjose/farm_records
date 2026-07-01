/// Represents the single farm profile / business identity record.
class FarmProfile {
  final int? id;
  final String farmName;
  final String ownerName;
  final String location;
  final String? phone;
  final String? email;
  final double? farmSizeAcres;
  final String? establishedDate;
  final String? notes;

  FarmProfile({
    this.id,
    required this.farmName,
    required this.ownerName,
    required this.location,
    this.phone,
    this.email,
    this.farmSizeAcres,
    this.establishedDate,
    this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'farm_name': farmName,
      'owner_name': ownerName,
      'location': location,
      'phone': phone,
      'email': email,
      'farm_size_acres': farmSizeAcres,
      'established_date': establishedDate,
      'notes': notes,
    };
  }

  factory FarmProfile.fromMap(Map<String, dynamic> map) {
    return FarmProfile(
      id: map['id'] as int?,
      farmName: map['farm_name'] as String,
      ownerName: map['owner_name'] as String,
      location: map['location'] as String,
      phone: map['phone'] as String?,
      email: map['email'] as String?,
      farmSizeAcres: (map['farm_size_acres'] as num?)?.toDouble(),
      establishedDate: map['established_date'] as String?,
      notes: map['notes'] as String?,
    );
  }

  FarmProfile copyWith({
    int? id,
    String? farmName,
    String? ownerName,
    String? location,
    String? phone,
    String? email,
    double? farmSizeAcres,
    String? establishedDate,
    String? notes,
  }) {
    return FarmProfile(
      id: id ?? this.id,
      farmName: farmName ?? this.farmName,
      ownerName: ownerName ?? this.ownerName,
      location: location ?? this.location,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      farmSizeAcres: farmSizeAcres ?? this.farmSizeAcres,
      establishedDate: establishedDate ?? this.establishedDate,
      notes: notes ?? this.notes,
    );
  }
}
