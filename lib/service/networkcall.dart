import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
class NetworkCall extends StatelessWidget {
final String root = 'https://jsonplaceholder.typicode.com/todos';
  Future updateStatus(actId, statusCode) async {
    var res = await http.post(root);
    print(res.body);
    if (res.statusCode == 200) {
      var data = json.decode(res.body);
      print(data["message"]);
    } else {
      print('something error on deal status');
      print(res.statusCode);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
