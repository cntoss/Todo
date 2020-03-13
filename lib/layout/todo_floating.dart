import 'package:flutter/material.dart';
import 'package:unlimit/model/todo_model.dart';
import 'package:unlimit/screen/add_todo.dart';
class TodoFloatingButton extends StatefulWidget {
  @override
  _TodoFloatingButtonState createState() => _TodoFloatingButtonState();
}

class _TodoFloatingButtonState extends State<TodoFloatingButton> {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context)
        {
          return TodoDetails(
              Todo(0, ' ', ' '),
              'Add Todo');
        }));
      },
      tooltip: 'Add Todo',
      child: Icon(
        Icons.add,
        color: Colors.white,
        size: 30.0,
      ),
      backgroundColor: Color(0xff108F87),
    );
  }
}
