import 'package:cloud_firestore/cloud_firestore.dart';



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
      'createdAt' : createdAt,
      'deadline' : deadline,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map, String documentId){
    return Task(
        id: documentId,
        title: map['title'],
        description: map['description'],
        isDone: map['isDone'],
        createdAt: (map['createdAt'] as Timestamp).toDate(),
      deadline:
        map['deadline'] != null ? (map['deadline'] as Timestamp).toDate() : null,
    );
  }
}