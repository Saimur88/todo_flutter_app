import 'package:flutter/material.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/firestore_service.dart';
import 'package:todo_app/widgets/task_card.dart';
import 'package:todo_app/widgets/custom_app_bar.dart';



class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();

}

enum SortOrder {newestFirst, oldestFirst}

enum TaskFilter { all, completed, incomplete }
TaskFilter _selectedfilter = TaskFilter.all;

class _HomePageState extends State<HomePage> {
  final TextEditingController _taskController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _deadlineController = TextEditingController();

  SortOrder _sortOrder = SortOrder.newestFirst;

  String _searchQuery= '';

  void _showAddTaskDialog(){
    _taskController.clear();
    _descController.clear();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Add New Task"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _taskController,
              decoration: InputDecoration(hintText: "Enter Task Title"),
            ),
            TextField(
              controller: _descController,
              decoration: InputDecoration(hintText: "Enter Task Description"),
              keyboardType: TextInputType.multiline,
              maxLines: null,
            ),
            TextField(
              controller: _deadlineController,
              decoration: InputDecoration(
                  hintText: "Select Deadline",
                suffixIcon: Icon(Icons.calendar_today)
              ),
              readOnly: true,
              onTap: () async {
                DateTime? pickDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000), lastDate: DateTime(2101),
                );
                if (pickDate != null) {
                  setState(() {
                    _deadlineController.text =
                        "${pickDate.day}/${pickDate.month}/${pickDate.year}";
                  });
                }
              },
              keyboardType: TextInputType.datetime,

            )
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), //dismisses the current screen
              child: Text("Cancel")),
          TextButton(
              onPressed: () {
                _addTask();
                Navigator.pop(context);
              }, child: Text("Add"))
        ],
      ),
    );
  }
  void _confirmDelete(int index){
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Delete Task"),
        content: Text("Are You Sure You Want To Delete This Task"),
        actions: [
          TextButton(
              onPressed: (){
                Navigator.pop(context);
              }, child: Text("Cancel")),
          TextButton(
              onPressed: () async {
                  await _firestoreService.deleteTask(tasks[index].id!);
                  await _loadTasks();
                Navigator.pop(context);
              },
              child: Text("Delete",style: TextStyle(color: Colors.red),)),
        ],
      ),);
  }
  Future<void> _addTask() async {
    String newTaskTitle = _taskController.text;
    String newDesc = _descController.text;
    DateTime? deadline;
    if (_deadlineController.text.isNotEmpty){
      try {
        List<String> parts = _deadlineController.text.split('/');
        if (parts.length == 3) {
          int day = int.parse(parts[0]);
          int month = int.parse(parts[1]);
          int year = int.parse(parts[2]);
          deadline = DateTime(year, month, day);
        }
      } catch (e) {
        print("Invalid date format: $e");
      }
    }
    if (newTaskTitle.isNotEmpty && newDesc.isNotEmpty){
      Task newTask = Task(
        title: newTaskTitle,
        description: newDesc,
        isDone: false,
        createdAt: DateTime.now(),
        deadline: deadline,
      );

        await _firestoreService.addTask(newTask);
        await _loadTasks();

        _taskController.clear();
        _descController.clear();
        _deadlineController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Task Added Successfully"),
            duration: Duration(seconds: 2),
          ));
    }
  }
  void _markAllTasksComplete(){
    setState(() {
      for (var task in tasks){
        task.isDone = true;
      }
    });
  }
  void _markAllTasksIncomplete(){
    setState(() {
      for (var task in tasks){
        task.isDone = false;
      }
    });
  }
  Future<void> _editTask(int index) async {
    _taskController.text = tasks[index].title;
    _descController.text = tasks[index].description;
    _deadlineController.text = tasks[index].deadline != null
    ? '${tasks[index].deadline!.day}/${tasks[index].deadline!.month}/${tasks[index].deadline!.year}'
        : '';
    showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text("Edit Task"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _taskController,
                  decoration: InputDecoration(labelText: "Task Title"),
                ),
                TextField(
                  controller: _descController,
                  decoration: InputDecoration(labelText: "Task Description"),
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                ),
                TextField(
                  controller: _deadlineController,
                  decoration: InputDecoration(
                    labelText: "Select Deadline",
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  readOnly: true,
                  onTap: () async {
                    DateTime? pickDate = await showDatePicker(
                        context: context,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101)
                    );
                    if (pickDate != null) {
                      setState(() {
                        _deadlineController.text =
                            "${pickDate.day}/${pickDate.month}/${pickDate.year}";
                      });

                    }
                  },
                )
              ],
            ),
            actions: [
              TextButton(
                  onPressed: (){
                    Navigator.pop(context);
                  }, child: Text("Cancel")),
              TextButton(
                  onPressed: () async {
                    setState(() {
                      tasks[index].title = _taskController.text;
                      tasks[index].description = _descController.text;
                     if (_deadlineController.text.isNotEmpty){
                       try {
                         List<String> dateParts = _deadlineController.text.split('/');
                         if (dateParts.length == 3){
                           int day = int.parse(dateParts[0]);
                           int month = int.parse(dateParts[1]);
                           int year = int.parse(dateParts[2]);
                           tasks[index].deadline = DateTime(year, month, day);

                         }
                       } catch (e) {
                         print("Invalid date format: $e");
                       }
                     }else {
                       tasks[index].deadline = null;
                     }

                    });
                    await _firestoreService.updateTask(tasks[index]);
                    Navigator.pop(context);
                  }, child: Text("Save"))
            ],
          );

        });

  }

  List<Task> tasks = [];

  @override
  void initState(){
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    var fetchedTasks = await _firestoreService.getTasks();
    setState(() {
      tasks = fetchedTasks;
    });
  }

  final FirestoreService _firestoreService = FirestoreService();


  @override
  Widget build(BuildContext context) {
 final filteredTasks = tasks.where ( (task) {
   final matchesSearch = task.title.toLowerCase().contains(_searchQuery.toLowerCase());

   if (_selectedfilter == TaskFilter.all){
     return matchesSearch;
   } else if (_selectedfilter == TaskFilter.completed){
     return matchesSearch && task.isDone;
   }
   else if (_selectedfilter == TaskFilter.incomplete){
     return matchesSearch && !task.isDone;
   }
   return false;}).toList();

 filteredTasks.sort((a, b){
   if (_sortOrder == SortOrder.newestFirst){
     return b.createdAt.compareTo(a.createdAt);
   } else {
     return a.createdAt.compareTo(b.createdAt);
   }
    });

    return Scaffold(
      appBar: CustomAppBar(
          title: 'My ToDo App',
          onMarkAllComplete: _markAllTasksComplete,
          onMarkAllIncomplete: _markAllTasksIncomplete,
      ),
      floatingActionButton: FloatingActionButton.small(
        onPressed: () {
          _showAddTaskDialog();
        },
        backgroundColor: Colors.green,
        child: Icon(Icons.add, color: Colors.black,),),
      body: Column(
        children: [
          Padding(
              padding: const EdgeInsets.all(10),
          child: TextField(
            onChanged: (value){
              setState(() {
                _searchQuery = value;
              });
            },
            decoration: InputDecoration(
              hintText: 'Search Task',
                  prefixIcon: Icon(Icons.search_sharp),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ) ,
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
            FilterChip(label: Text("All"),
                selected: _selectedfilter == TaskFilter.all,
                onSelected:
                (_) {
                  setState(() {
                    _selectedfilter = TaskFilter.all;
                  });
                },
            ),

            FilterChip(label: Text("Completed"),
                selected: _selectedfilter == TaskFilter.completed,
                onSelected: (_) {
                  setState(() {
                    _selectedfilter = TaskFilter.completed;
                  });
                }),
              FilterChip(label: Text("Incomplete"),
                selected: _selectedfilter == TaskFilter.incomplete,
                onSelected: (_){
                  setState(() {
                    _selectedfilter = TaskFilter.incomplete;
                  });
                },),
             DropdownButtonHideUnderline(
               child: DropdownButton<SortOrder>(
                  value: _sortOrder,
                  icon: Icon(Icons.arrow_drop_down),

                  onChanged: (SortOrder? newValue)  {
                    setState(() {
                      _sortOrder = newValue!;
                    });
                  },
                  items: [
                    DropdownMenuItem(
                      value: SortOrder.newestFirst,
                      child: Text("Newest First"),
                    ),
                    DropdownMenuItem(
                        value: SortOrder.oldestFirst,
                        child: Text("Oldest First"))
                  ],
                 selectedItemBuilder: (BuildContext context){
                    return SortOrder.values.map((value){
                      return Row(
                        children: [
                          //Icon(Icons.sort,color: Colors.black),
                          SizedBox(width: 4),
                          Text(
                            value == SortOrder.newestFirst ? "Newest" : "Oldest",
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      );
                    }).toList();
                 },
                ),
             )

            ]
          ),

          Expanded(
            child: ListView.builder(
              itemCount: filteredTasks.length,
              itemBuilder: (context, index) {
                final task = filteredTasks[index];
                return TaskCard(
                    task: task,
                    onEdit: () => _editTask(index),
                    onDelete: () => _confirmDelete(index),
                    onToggleDone: (value) async {
                      setState(() {
                        task.isDone = value!;
                      });
                      await _firestoreService.updateTask(task);
                    }
                    );
              },
            ),
          ),
        ],
      ),
    );
  }
}
