import 'package:flutter/material.dart';

// User Define Package
import 'dashboard.dart';
import 'call.dart';
import 'contact.dart';

class HomePage extends StatefulWidget {
  static String id = "home-page";

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  callPage(int currentIndex) {
    switch (currentIndex) {
      case 0:
        return DashBoard();
        break;
      case 1:
        return CallList();
        break;
      case 2:
        return ContactList();
      }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        body: callPage(_currentIndex),
        bottomNavigationBar: BottomNavigationBar(
          showSelectedLabels: true,
          currentIndex: _currentIndex,
          onTap: (value) {
            _currentIndex = value;
            setState(() {});
          },
          items: [
            BottomNavigationBarItem(
              icon: Hero(
                  tag: "hero120",
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: 30.0,
                        height: 30.0,
                          child: Icon(Icons.dashboard,color: Colors.black,),
                      )
                    ],
                  )),
              activeIcon: Hero(
                  tag: "hero121",
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: 30.0,
                        height: 30.0,
                        child: Icon(Icons.dashboard, color: Colors.teal,),
                      )
                    ],
                  )),
              title: Text("Todos",
                  style: TextStyle(color: Colors.teal, fontSize: 10.0)),
              backgroundColor: Colors.white,
            ),
            BottomNavigationBarItem(
              icon: Hero(
                  tag: "hero122",
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: 30.0,
                        height: 30.0,
                        child: Icon(Icons.contacts,color: Colors.black,)),
                    ],
                  )),
              activeIcon: Hero(
                  tag: "hero123",
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: 30.0,
                        height: 30.0,
                          child: Icon(Icons.contacts,color: Colors.teal,),
                      )
                    ],
                  )),
              title: Text("Contacts",
                  style: TextStyle(color: Colors.teal, fontSize: 10.0)),
              backgroundColor: Colors.white,
            ),
            BottomNavigationBarItem(
              icon: Hero(
                  tag: "hero124",
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: 30.0,
                        height: 30.0,
                          child: Icon(Icons.call,color: Colors.black,),
                      )
                    ],
                  )),
              activeIcon: Hero(
                  tag: "hero125",
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: 30.0,
                        height: 30.0,
                        child: Icon(Icons.call,color: Colors.teal,),
                      )
                    ],
                  )),
              title: Text("Call",
                  style: TextStyle(color: Colors.teal, fontSize: 10.0)),
              backgroundColor: Colors.white,
            ),
           ],
        ),
      ),
      onWillPop:  () async => false,
    );
  }
}
