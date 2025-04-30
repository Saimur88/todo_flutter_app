import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback onMarkAllComplete;
  final VoidCallback onMarkAllIncomolete;

  const CustomAppBar({Key? key,
    required this.title,
    required this.onMarkAllComplete,
    required this.onMarkAllIncomolete,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'complete_all') {
                onMarkAllIncomolete;
              } else if (value == 'incomplete_all') {
                onMarkAllIncomolete;
              }
            },
            itemBuilder: (context) =>
            [
              PopupMenuItem(
                value: 'complete_all',
                child: Text("Mark All Tasks Done"),
              ),
              PopupMenuItem(
                  value: 'incomplete_all',
                  child: Text("Mark All As Incomplete"))

            ],),

          Text("To Do List", style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.black),),
          Container(

            height: 40,
            width: 40,
            child: ClipRRect(
              child: Image.asset('assets/images/user.png'),

            ),
          ),

        ],
      ),
    );
  }
}