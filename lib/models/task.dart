class Task {
  int? id;
  String name;
  String description;
  String? category;
  String? priority;
  DateTime? dueDate;
  bool isImportant;
  bool reminderEnabled;
  bool completed;

  Task({
    this.id,
    required this.name,
    required this.description,
    this.category,
    this.priority,
    this.dueDate,
    this.isImportant = false,
    this.reminderEnabled = false,
    this.completed = false,
  });
}