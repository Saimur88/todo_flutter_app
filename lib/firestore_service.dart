import 'package:cloud_firestore/cloud_firestore.dart';
import 'models/task.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Fetch tasks from Firestore
  Future<List<Task>> getTasks() async {
    var result = await _db.collection('tasks').get();
    return result.docs
        .map((doc) => Task(
      title: doc['title'],
      description: doc['description'],
      isDone: doc['isDone'],
      createdAt: (doc['createdAt'] as Timestamp).toDate(),
      deadline: doc['deadline'] != null
          ? (doc['deadline'] as Timestamp).toDate()
          : null,
    ))
        .toList();
  }

  // Add a task to Firestore
  Future<void> addTask(Task task) async {
    await _db.collection('tasks').add({
      'title': task.title,
      'description': task.description,
      'isDone': task.isDone,
      'createdAt': task.createdAt,
      'deadline': task.deadline != null ? task.deadline : null,
    });
  }

  // Update a task in Firestore
  Future<void> updateTask(Task task, String docId) async {
    await _db.collection('tasks').doc(docId).update({
      'title': task.title,
      'description': task.description,
      'isDone': task.isDone,
      'createdAt': task.createdAt,
      'deadline': task.deadline,
    });
  }

  // Delete a task from Firestore
  Future<void> deleteTask(String docId) async {
    await _db.collection('tasks').doc(docId).delete();
  }
}
