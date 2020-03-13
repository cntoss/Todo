import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//import 'package:toast/toast.dart';
import 'package:date_format/date_format.dart';
import 'package:sqflite/sqflite.dart';
import 'add_todo.dart';
import 'package:unlimit/model/todo_model.dart';
import 'package:unlimit/controller/todo_helper.dart';

class ContactList extends StatefulWidget {
  static const String id = "contact_screen";
  @override
  _ContactListState createState() => _ContactListState();
}

class _ContactListState extends State<ContactList> {
  TodoHelper todoHelper = TodoHelper();
  List<Todo> todoList = List();
  int count = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    //main function
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 4.0, right: 4.0),
          children: <Widget>[
            FutureBuilder(
                future: todoHelper.getTodoList(),
                builder:  (context, snapshot) {
                  return snapshot.data != null
                      ? listViewWidget(snapshot.data)
                      : Container();
                  //Center(child: Text('no response',style: TextStyle(height: 20.0,color: Colors.red),),);
                }),
          ],
        ),
      ),
    );
  }

  _setCheck(bool checkable, Todo todo){
    if(checkable == true){
      setState(() {
        todo.completed = 1;
      });
      todoHelper.updateTodo(todo);
    } else {
      setState(() {
        todo.completed = 0;
      });
      todoHelper.updateTodo(todo);
    }
  }

  void navigateToDetail(Todo todo, String name) async {
    bool result =
    await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return TodoDetails(todo, name);
    }));

    if (result == true) {
      updateListView();
    }
  }

  void updateListView() {
    final Future<Database> dbFuture = todoHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Todo>> todoListFuture = todoHelper.getTodoList();
      todoListFuture.then((todoList) {
        if(!mounted) return;
        setState(() {
          this.todoList = todoList;
          this.count = todoList.length;
        });
      });
    });
  }

  Widget listViewWidget(List<Todo> todo) {
    return Container(
      child: ListView.separated(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          itemCount: todo.length,
          separatorBuilder: (BuildContext context, int index) => Padding(
            padding: const EdgeInsets.only(left: 65.0),
            child: Divider(
              height: 1,
              thickness: 2.0,
            ),
          ),
          padding: const EdgeInsets.all(2.0),
          itemBuilder: (context, position) {
            bool completed = (todo[position].completed == 0) ? false : true;

            return ListTile(
                title: Text('${todo[position].title}'),
                leading: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                        child: Icon(Icons.create_new_folder, color: Colors.black)
                    )),
                trailing: Checkbox(value: completed, activeColor: Colors.teal, onChanged: (bool value){
                  completed = value;
                  setState(() {
                    completed = value;
                  });
                  _setCheck(completed, todo[position]);
                }),
                onTap: () async{
                  navigateToDetail(
                      todo[position], 'Edit Todo');
                  print('edit');
                  debugPrint('FAB clicked');
                }
            );
          }),
    );
  }

}



