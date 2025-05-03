import 'package:flutter/material.dart';
import 'package:todo_app/models/task.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final ValueChanged<bool?> onToggleDone;

  const TaskCard({

    Key? key,
    required this.task,
    required this.onEdit,
    required this.onDelete,
    required this.onToggleDone,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(10),
      child: ListTile(
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
                onPressed:onEdit,
                icon: Icon(Icons.edit_note)),
            IconButton(
              onPressed: onDelete,

              icon: Icon(Icons.delete_forever),
              color: Colors.red,
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(task.description),
            SizedBox(height: 4),
            SizedBox(height: 4),
            Text(
              task.deadline != null
                  ? 'Deadline: ${task.deadline!.day}/${task.deadline!
                  .month}/${task.deadline!.year}'
                  : "No Deadline",
              style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(width: 4,),
            Text(
              task.createdAt != null
                  ? "Created At: ${TimeOfDay
                  .fromDateTime(task.createdAt)
                  .format(
                  context)}"
                  : "Created At: unknown",
              style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold),
            )

          ],
        ),
        leading: Checkbox(
          value: task.isDone,
          onChanged: onToggleDone,
        ),
        title: Text(
          task.title,
          style: TextStyle(
            decoration:
            task.isDone ? TextDecoration.lineThrough : null,
          ),
        ),
      ),
    );
  }
}