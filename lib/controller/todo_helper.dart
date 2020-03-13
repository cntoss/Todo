import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:unlimit/model/todo_model.dart';

class TodoHelper {
  static TodoHelper _todoHelper; // Singleton todoHelper
  Database _database;
  String actTable = 'todo_table';
  String colId = 'id';
  String colCompleted = 'completed';
  String colTitle = 'title';
  String colCreatedAt = 'createdAt';

  TodoHelper._createInstance(); // titled constructor to create instance of DatabaseHelper

  factory TodoHelper() {
    if (_todoHelper == null) {
      _todoHelper = TodoHelper
          ._createInstance(); // This is executed only once, singleton object
    }
    return _todoHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'todo.db';
    //open or create database
    var activitiesDatabase =
    await openDatabase(path, version: 1, onCreate: _createDB);
    return activitiesDatabase;
  }

  void _createDB(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $actTable($colId INTEGER PRIMARY KEY , $colCompleted INTEGER, $colTitle TEXT, $colCreatedAt TEXT)');
  }

  // Fetch Operation: Get all note objects from database
  Future<List<Map<String, dynamic>>> getTodoMapList() async {
    Database db = await this.database;

//		var result = await db.rawQuery('SELECT * FROM $orgTable order by $colId ASC');
    var result = await db.query(actTable, orderBy: '$colTitle DESC');
    return result;
  }

  //insert into database
  Future<int> insertTodo(Todo todo) async {
    Database db = await this.database;
    int result = await db.insert(actTable, todo.toMap());
    return result;
  }

/*
  Future batchInsert(List activities) async{
    try {
      Database db = await this.database;
      db.transaction((txn) async {
        Batch batch = txn.batch();
        for (var todo in activities) {
          var data = Todo.fromMap(todo);
          batch.insert(actTable, data.toMap());
        }
        batch.commit();
      });
    } on DatabaseException catch (e) {
      print('error: $e');
    }
  }
*/

  // Update Operation: Update a Todo object and save it to database
  Future<int> updateTodo(Todo todo) async {
    var db = await this.database;
    int result = await db.update(actTable, todo.toMap(),
        where: '$colId = ?', whereArgs: [todo.id]);
    return result;
  }
  
  //delete data base
  Future<int> deleteTodo(int id) async {
    var db = await this.database;
    int result = await db.rawDelete('DELETE FROM $actTable WHERE $colId = $id');
    return result;
  }

    //count todo
  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
    await db.rawQuery('SELECT COUNT (*) from $actTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  // Get the 'Map List' [ List<Map> ] and convert it to 'Todo List' [ List<Todo> ]
  Future<List<Todo>> getTodoList() async {
    var actMapList = await getTodoMapList(); // Get 'Map List' from database
    int count =  actMapList.length; // Count the number of map entries in db table
    List<Todo> todoList = List<Todo>();
    // For loop to create a 'todo List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      todoList.add(Todo.fromMapObject(actMapList[i]));
    }

    return todoList;
  }
  
/*
  Future<List<Todo>> getFilteredTodo(String newDate) async {
    int checkable = 0;
    Database db = await this.database;
    var actMapList = await db.rawQuery('SELECT *  from $actTable WHERE $colCompleted = $checkable AND $colStart = ?', ['$newDate']);
    // Get 'Map List' from database
    int count = actMapList.length;
    List<Todo> todoList = List<Todo>();
    // For loop to create a 'Todo List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      todoList.add(Todo.fromMapObject(actMapList[i]));
    }
    return todoList;
  }
*/

}
