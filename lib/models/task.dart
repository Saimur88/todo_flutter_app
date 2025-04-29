class Task{
  String title;
  String description;
  bool isDone;
  DateTime createdAt;
  DateTime? deadline;
  Task({
    required this.title,
    required this.description,
    required this.isDone,
    required this.createdAt,
    this.deadline,
  });
}