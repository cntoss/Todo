import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<List<ServerTodo>> fetchServerTodo(http.Client client) async {
  final response =  await client.get('https://jsonplaceholder.typicode.com/todos');
  print(response);
  return compute(parseServerTodo, response.body);
}

// A function that converts a response body into a List<ServerTodo>.
List<ServerTodo> parseServerTodo(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<ServerTodo>((json) =>  ServerTodo.fromJson(json)).toList();
}

class ServerTodo {
  final String title;
  final bool completed;

  ServerTodo({this.title,  this.completed});

  factory ServerTodo.fromJson(Map<String, dynamic> json) {
    return ServerTodo(
      title: json['title'] as String,
      completed: json['completed'] as bool,
    );
  }
}

class TodoServerPage extends StatelessWidget {
   @override
  Widget build(BuildContext context) {
    return Scaffold(
      body : FutureBuilder<List<ServerTodo>>(
        future: fetchServerTodo(http.Client()),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);

          return snapshot.hasData
              ? TodoList(todoList: snapshot.data)
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class TodoList extends StatelessWidget {
  final List<ServerTodo> todoList;

  TodoList({Key key, this.todoList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemCount: todoList.length,
      itemBuilder: (context, index) {
        return Text('${todoList[index].title}');
      },
    );
  }
}
