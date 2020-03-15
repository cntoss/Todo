import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:http/http.dart' as http;
import 'dart:convert';

class AppState with ChangeNotifier {
  AppState();

  String _displayText = "";

  void setDisplayText(String text) {
    _displayText = text;
    notifyListeners();
  }

  String get getDisplayText => _displayText;
  String _jsonResponse = '';
  String _dataUrl = "https://jsonplaceholder.typicode.com/todos";
  bool _isFetching = false;

  bool get isFetching => _isFetching;

  Future<void> fetchData() async {
    _isFetching = true;
    notifyListeners();

    //var response = await http.get(_dataUrl);
    var response = await rootBundle.loadString('json/country.json');
    _jsonResponse = response;
    //return json.decode(response) as List;
    /*if (response.statusCode == 200) {
      _jsonResponse = response.body;
    }*/

    _isFetching = false;
    notifyListeners();
  }
  String get getResponseText => _jsonResponse;

  List<dynamic> getResponseJson() {
    if (_jsonResponse.isNotEmpty) {
      return json.decode(_jsonResponse) as List;
     // Map<String, dynamic> json = jsonDecode(_jsonResponse);
     // return json['data'];
    }
    return null;
  }


}