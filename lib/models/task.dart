class Task{
  String? id;
  String title;
  String description;
  bool isDone;
  DateTime createdAt;
  DateTime? deadline;
  Task({
    this.id,
    required this.title,
    required this.description,
    required this.isDone,
    required this.createdAt,
    this.deadline,
  });

  Map<String, dynamic> toMap(){
    return {
      'title' : title,
      'description' : description,
      'isDone' : isDone,
      'createdAt' : createdAt.toIso8601String(),
      'deadline' : deadline?.toIso8601String(),
    };
  }

  static Task fromMap(Map<String, dynamic> map, String documentId){
    return Task(
        id: documentId,
        title: map['title'],
        description: map['description'],
        isDone: map['isDone'],
        createdAt: DateTime.parse(map['createdAt']),
      deadline:
        map['deadline'] != null ? DateTime.parse(map['deadline']) : null,
    );
  }
}