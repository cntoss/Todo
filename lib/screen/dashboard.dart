import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//import 'package:toast/toast.dart';
import 'package:date_format/date_format.dart';
import 'package:sqflite/sqflite.dart';
import 'add_todo.dart';
import 'package:unlimit/model/todo_model.dart';
import 'package:unlimit/controller/todo_helper.dart';
import 'package:unlimit/layout/todo_floating.dart';
import 'drawer.dart';
import 'package:unlimit/service/tab_value.dart';
class DashBoard extends StatefulWidget {
  static const String id = "dashboard_screen";
  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> with SingleTickerProviderStateMixin{
  TodoHelper todoHelper = TodoHelper();
  List<Todo> todoList = List();
  var newTab = Singleton;
  int count = 0;
  TabController tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: 3,vsync: this)
    ..addListener(() {
      newTab.tabIndex = tabController.index;
      print(newTab.tabIndex);
    });
  }

@override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    tabController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final _kTabs = <Tab>[
      Tab(text: 'All'),
      Tab(text: 'Today',),
      Tab(text: 'Tomorrow'),
    ];      //main function
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: DrawerPage(),
      appBar: AppBar(
        title: Center(child: Text('Your Todos')),
      ),
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 4.0, right: 4.0),
          children: <Widget>[
            Column(
              children: <Widget>[
                TabBar(
                  isScrollable: true,
                  labelColor: Colors.teal,
                  indicatorColor: Colors.teal,
                  indicatorWeight: 2.0,
                  //labelPadding: EdgeInsets.only(right: 250.0, left: 40.0),
                  //indicatorPadding: EdgeInsets.only(left: 40.0),
                  labelStyle: TextStyle(fontSize: 16.0),
                  tabs: _kTabs,
                  controller: tabController,
                ),
                Container(
                  height: 600.0,
                  child: TabBarView(
                      controller: tabController,
                      children: [
                        //all
                        FutureBuilder(
                            future: todoHelper.getTodoList(),
                            builder:  (context, snapshot) {
                              return snapshot.data != null
                                  ? listViewWidget(snapshot.data)
                                  : Container();
                              //Center(child: Text('no response',style: TextStyle(height: 20.0,color: Colors.red),),);
                            }),
                        // today
                        FutureBuilder(
                            future: todoHelper.getTodoList(),
                            builder:  (context, snapshot) {
                              return snapshot.data != null
                                  ? listViewWidget(snapshot.data)
                                  : Container();
                              //Center(child: Text('no response',style: TextStyle(height: 20.0,color: Colors.red),),);
                            }),
                        //tomorrow
                        FutureBuilder(
                            future: todoHelper.getTodoList(),
                            builder:  (context, snapshot) {
                              return snapshot.data != null
                                  ? listViewWidget(snapshot.data)
                                  : Container();
                              //Center(child: Text('no response',style: TextStyle(height: 20.0,color: Colors.red),),);
                            }),
                      ]),
                )
              ],
            )           ],
        ),
      ),
      floatingActionButton: SizedBox(
        height: 35.0,
        child: TodoFloatingButton(),
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



