class ExpenseModel {
  final int? id;
  final int farmId;
  final String type; // 'Expense' | 'Income'
  final String category;
  final double amount;
  final String? description;
  final String transactionDate;
  final String createdAt;

  const ExpenseModel({
    this.id,
    required this.farmId,
    required this.type,
    required this.category,
    required this.amount,
    this.description,
    required this.transactionDate,
    required this.createdAt,
  });

  factory ExpenseModel.fromMap(Map<String, dynamic> m) => ExpenseModel(
        id: m['id'] as int?,
        farmId: m['farm_id'] as int,
        type: m['type'] as String,
        category: m['category'] as String,
        amount: (m['amount'] as num).toDouble(),
        description: m['description'] as String?,
        transactionDate: m['transaction_date'] as String,
        createdAt: m['created_at'] as String,
      );

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'farm_id': farmId,
        'type': type,
        'category': category,
        'amount': amount,
        if (description != null) 'description': description,
        'transaction_date': transactionDate,
        'created_at': createdAt,
      };

  ExpenseModel copyWith({
    int? id,
    int? farmId,
    String? type,
    String? category,
    double? amount,
    String? description,
    String? transactionDate,
    String? createdAt,
  }) =>
      ExpenseModel(
        id: id ?? this.id,
        farmId: farmId ?? this.farmId,
        type: type ?? this.type,
        category: category ?? this.category,
        amount: amount ?? this.amount,
        description: description ?? this.description,
        transactionDate: transactionDate ?? this.transactionDate,
        createdAt: createdAt ?? this.createdAt,
      );

  bool get isIncome => type == 'Income';
  bool get isExpense => type == 'Expense';
}
