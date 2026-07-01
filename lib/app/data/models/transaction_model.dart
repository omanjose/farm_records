/// Represents a single financial transaction (income or expense).
class FarmTransaction {
  final int? id;
  final String type; // Income | Expense
  final String category;
  final double amount;
  final String date; // ISO 8601 string
  final String? description;
  final String createdAt;

  FarmTransaction({
    this.id,
    required this.type,
    required this.category,
    required this.amount,
    required this.date,
    this.description,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'category': category,
      'amount': amount,
      'date': date,
      'description': description,
      'created_at': createdAt,
    };
  }

  factory FarmTransaction.fromMap(Map<String, dynamic> map) {
    return FarmTransaction(
      id: map['id'] as int?,
      type: map['type'] as String,
      category: map['category'] as String,
      amount: (map['amount'] as num).toDouble(),
      date: map['date'] as String,
      description: map['description'] as String?,
      createdAt: map['created_at'] as String,
    );
  }

  FarmTransaction copyWith({
    int? id,
    String? type,
    String? category,
    double? amount,
    String? date,
    String? description,
    String? createdAt,
  }) {
    return FarmTransaction(
      id: id ?? this.id,
      type: type ?? this.type,
      category: category ?? this.category,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
