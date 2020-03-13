import 'package:flutter/material.dart';
import 'contact.dart';
import 'call.dart';

class DrawerPage extends StatefulWidget {
  @override
  _DrawerPageState createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> {

  @override
  Widget build(BuildContext context) {

    return Drawer(
      child: ListView(
        children: <Widget>[
          //todo
          ListTile(
            leading: new Icon(Icons.close),
            title: new Text("Todos"),
            trailing: new Text("Reset"),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
          SizedBox(height: 20.0),

          //contacts
          Padding(
              padding: EdgeInsets.only(left: 20.0),
              child: InkWell(
                child: Text("Contacts", style: TextStyle(color: Colors.grey)),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (BuildContext context) {
                        return ContactList();
                      }));
                },
              )),
          SizedBox(height: 10.0),

          //call
          Padding(
              padding: EdgeInsets.only(left: 20.0),
              child: InkWell(
                child: Text("Call"),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (BuildContext context) {
                        return CallList();
                      }));
                },
              )),
          SizedBox(height: 10.0),
          Divider(color: Colors.black),
        ],
      ),
    );
  }
}
