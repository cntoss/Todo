import 'package:flutter/material.dart';
import 'dart:async';

import 'package:call_log/call_log.dart';

class CallList extends StatefulWidget {
  static const String id = "call_screen";
  @override
  _CallListState createState() => _CallListState();
}

class _CallListState extends State<CallList> {
  Iterable<CallLogEntry> _callLogEntries = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    starter();
  }

  starter() async{
    var result = await CallLog.query();
    setState(() {
      _callLogEntries = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    var mono = TextStyle(fontFamily: 'monospace');

    var children = <Widget>[];

    _callLogEntries.forEach((entry) {
      children.add(
        Column(
          children: <Widget>[
            Divider(),
            Text('NUMBER   : ${entry.number}', style: mono),
            Text('NAME     : ${entry.name}', style: mono),
            Text('TYPE     : ${entry.callType}', style: mono),
            Text('DATE     : ${DateTime.fromMillisecondsSinceEpoch(entry.timestamp)}', style: mono),
            Text('DURATION :  ${entry.duration}', style: mono),
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
        ),
      );
    });

    return Scaffold(
      appBar: AppBar(title: Center(child: Text('Call Log'))),
      body: children.length >0 ?
      SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(children: children),
            ),
          ],
        )
      ) : Center(
        child: SizedBox(
          height: 100,
          width: 100,
          child: CircularProgressIndicator()),
      )
    );
  }
}



