import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To Do App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyan),
      ),
      home: const MyHomePage(title: 'To Do App'),
    );
  }
}

class Task{
  String title;
  bool isDone;
  Task({required this.title, required this.isDone});
}



class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();

}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _taskController = TextEditingController();
  void _showAddTaskDialog(){
    showDialog(
        context: context, 
        builder: (context) => AlertDialog(
          title: Text("Add New Task"),
          content: TextField(
            controller: _taskController,
            decoration: InputDecoration(hintText: "Enter Task Title Here"),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
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
  void _addTask(){
    String newTaskTitle = _taskController.text;

    if (newTaskTitle.isNotEmpty){
      setState(() {
        tasks.add(Task(title: newTaskTitle, isDone: false));
      });
      _taskController.clear();
    }
  }

  List<Task> tasks = [
    Task(title: 'Learn Flutter', isDone: false),
    Task(title: 'Build To Do App', isDone: false),
    Task(title: 'Study For Final', isDone: false),
    Task(title: 'Eat', isDone: false),
    Task(title: 'Sleep', isDone: false),
  ];


  @override
  Widget build(BuildContext context) {
    var time = DateTime.now();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(Icons.menu, color: Colors.black,),
            Container(
              child: Text("To Do List", style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.black),),
            ),
            Container(

              height: 40,
              width: 40,
              child: ClipRRect(
                child: Image.asset('assets/images/user.png'),

              ),
            )

          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.small(onPressed: () {
        _showAddTaskDialog();
      },

        backgroundColor: Colors.green,
        child: Icon(Icons.add, color: Colors.black,),),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 6,
            margin: EdgeInsets.all(10),
            child: ListTile(
              trailing: IconButton(
                  onPressed: (){
                    setState(() {
                      tasks.removeAt(index);
                    });
                  },

                icon: Icon(Icons.delete_forever),
              color: Colors.red,
              ),
              subtitle: Text("Daily Task"),
              leading: Checkbox(
                value: tasks[index].isDone,
                onChanged: (value) {
                  setState(() {
                    tasks[index].isDone = value!;
                  });
                },
              ),
              title: Text(
                tasks[index].title,
                style: TextStyle(
                  decoration:
                  tasks[index].isDone ? TextDecoration.lineThrough : null,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}