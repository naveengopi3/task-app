class Task {
  String id;
  String taskName;
  DateTime date;
  bool isCompleted;
  String userId;

  Task({
    required this.id,
    required this.taskName,
    required this.date,
    required this.isCompleted,
    required this.userId,
  });

  // Create a Task from a JSON map
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      taskName: json['task_name'], // Ensure this matches the column name
      date: DateTime.parse(json['date']),
      isCompleted: json['is_completed'],
      userId: json['user_id'],
    );
  }

  // Convert Task to JSON format
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'task_name': taskName, // Ensure this matches the column name
      'date': date.toIso8601String(),
      'is_completed': isCompleted,
      'user_id': userId,
    };
  }

  Task copyWith({
    String? id,
    String? taskName,
    DateTime? date,
    bool? isCompleted,
    String? userId,
  }) {
    return Task(
      id: id ?? this.id,
      taskName: taskName ?? this.taskName,
      date: date ?? this.date,
      isCompleted: isCompleted ?? this.isCompleted,
      userId: userId ?? this.userId,
    );
  }
}
