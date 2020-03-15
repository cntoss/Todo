import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class JsonResponse extends StatefulWidget {
  @override
  _JsonResponseState createState() => _JsonResponseState();
}

class _JsonResponseState extends State<JsonResponse> {

  Future<List> fetchData() async {
    var response = await http.get("https://jsonplaceholder.typicode.com/todos");
    return json.decode(response.body) as List;
  }


  @override
  Widget build(BuildContext context) {
     return Container(
      padding: const EdgeInsets.all(16.0),
      child: FutureBuilder(
        future: fetchData(),
        builder:  (context, snapshot) {
          return snapshot.data != null
              ? listView(snapshot.data)
              : Center(child: CircularProgressIndicator());
        }),
     );
  }

  Widget listView(data) {
    return ListView.builder(
     // primary: false,
      shrinkWrap: true,
      itemCount: data.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading:CircleAvatar(
              backgroundColor: Colors.red,
              child: Text( data[index]["title"][0].toUpperCase())),
          title: Text(
            data[index]["title"],
          ),
        );
      },
    );
  }

}