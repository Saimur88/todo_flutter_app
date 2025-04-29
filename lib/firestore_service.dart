import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_app/models/task.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Fetch tasks from Firestore
  Future<List<Task>> getTasks() async {
    try {
      // Fetch tasks collection from Firestore
      QuerySnapshot snapshot = await _db.collection('tasks').get();

      // Map the documents to a list of Task objects
      List<Task> tasks = snapshot.docs.map((doc) {
        return Task(
          title: doc['title'],
          description: doc['description'],
          isDone: doc['isDone'],
          createdAt: (doc['createdAt'] as Timestamp).toDate(),
          deadline: doc['deadline'] != null ? (doc['deadline'] as Timestamp).toDate() : null,
        );
      }).toList();

      return tasks;
    } catch (e) {
      print("Error fetching tasks: $e");
      return [];
    }
  }

  // Add task to Firestore
  Future<void> addTask(Task task) async {
    try {
      await _db.collection('tasks').add({
        'title': task.title,
        'description': task.description,
        'isDone': task.isDone,
        'createdAt': task.createdAt,
        'deadline': task.deadline != null ? Timestamp.fromDate(task.deadline!) : null,
      });
    } catch (e) {
      print("Error adding task: $e");
    }
  }
}
