/// Represents a scheduled farm activity / task.
class FarmTask {
  final int? id;
  final String title;
  final String? description;
  final String category;
  final String dueDate; // ISO 8601 string
  final String priority;
  final String status;
  final String createdAt;
  final String? completedAt;

  FarmTask({
    this.id,
    required this.title,
    this.description,
    required this.category,
    required this.dueDate,
    required this.priority,
    required this.status,
    required this.createdAt,
    this.completedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'due_date': dueDate,
      'priority': priority,
      'status': status,
      'created_at': createdAt,
      'completed_at': completedAt,
    };
  }

  factory FarmTask.fromMap(Map<String, dynamic> map) {
    return FarmTask(
      id: map['id'] as int?,
      title: map['title'] as String,
      description: map['description'] as String?,
      category: map['category'] as String,
      dueDate: map['due_date'] as String,
      priority: map['priority'] as String,
      status: map['status'] as String,
      createdAt: map['created_at'] as String,
      completedAt: map['completed_at'] as String?,
    );
  }

  FarmTask copyWith({
    int? id,
    String? title,
    String? description,
    String? category,
    String? dueDate,
    String? priority,
    String? status,
    String? createdAt,
    String? completedAt,
  }) {
    return FarmTask(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}
