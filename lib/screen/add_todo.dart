import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:toast/toast.dart';
import 'package:flutter/services.dart';
import 'package:unlimit/model/todo_model.dart';
import 'package:unlimit/controller/todo_helper.dart';
import 'package:date_format/date_format.dart';
import 'package:intl/intl.dart';
import 'package:unlimit/service/tab_value.dart';

class TodoDetails extends StatefulWidget {
  final String appBarTitle;
  final Todo todo;
  TodoDetails(this.todo, this.appBarTitle);
  @override
  State<StatefulWidget> createState() {
    return TodoDetailsState(this.todo, this.appBarTitle);
  }
}

enum Answers { SAVE, DELETE }

class TodoDetailsState extends State<TodoDetails> {
  TodoHelper todoHelper = TodoHelper();
  Todo todo;

  String appBarTitle;

  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  bool _autoValidate = false;

  static final formColor = Color(0xffD2E8E6);
  static final backColor = Color.fromRGBO(16, 143, 135, 1);

  TextEditingController _titleController = TextEditingController();
  TextEditingController _dateController = TextEditingController();

  bool _isCompleted;
  bool isLoading = false;
  String createdAt;
  String _value;
  bool isTyped = false;
 var newTab = Singleton;
  @override
  void initState() {
    super.initState();
    _setLinkedTodo();
    _setEditingValue();
  }

  void _setValue(String value) => setState(() => _value = value);

  _setEditingValue() {
    String checkEmpty(String text) {
      if (text == null) return '';
      return text;
    }
    _titleController.value = TextEditingValue(text: checkEmpty(todo.title));
  }

  _showLoading() {
    setState(() {
      isLoading = true;
    });
  }

  _hideLoading() {
    if (!mounted) return;
    setState(() {
      isLoading = false;
    });
  }

  _setLinkedTodo() {
    var varDate;
    if( todo.createdAt == ' ') {
      if(newTab.tabIndex == 0) {
        varDate = DateTime.now();
      } else if(newTab.tabIndex == 1) {
        varDate = DateTime.now().add(Duration(days: 1));
      } else {
        varDate = DateTime.now().add(Duration(days: 2));
      }
    } else {
      varDate = DateTime.parse(todo.createdAt);
    }
    setState(() {
      createdAt = formatDate(varDate, [yyyy, '-', mm, '-', dd]).toString();
      _isCompleted = todo.completed == 1 ? true : false;
    });
  }

  Future _askUser(String title, String yes, String no) async {
    TextStyle _style = TextStyle(color: Colors.teal);
    switch (await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            backgroundColor: Colors.white,
            title: new Text(
              title,
              style: _style,
            ),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Divider(
                  height: 2,
                  color: Colors.black12,
                  thickness: 2.0,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  new SimpleDialogOption(
                    child: new Text(
                      yes,
                      style: _style,
                    ),
                    onPressed: () {
                      Navigator.pop(context, Answers.SAVE);
                    },
                  ),
                  new SimpleDialogOption(
                    child: new Text(
                      no,
                      style: _style,
                    ),
                    onPressed: () {
                      Navigator.pop(context, Answers.DELETE);
                    },
                  ),
                ],
              ),
            ],
          );
        })) {
      case Answers.SAVE:
        _setValue('save');
        break;
      case Answers.DELETE:
        _setValue('delete');
        break;
    }
  }

  TodoDetailsState(this.todo, this.appBarTitle);

  String checkEmpty(String text) {
    if (text == null) return '';
    return text;
  }

  @override
  Widget build(BuildContext context) {
    TextStyle _labelStyle = TextStyle(
        height: 1.8, fontSize: 16.0, color: Color.fromRGBO(61, 61, 61, 1));
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () async {
            if (isTyped == false) {
              moveToLastScreen();
            } else {
              await _askUser('Do You Want To Save Changed', 'Save', 'Discard');
              if (_value == 'save') {
                _showLoading();
                _save();
                print('saved');
                debugPrint('FAB clicked');
              }
              if (_value == 'delete') {
                moveToLastScreen();
              }
            }
          },
        ),
        title: Text(
          appBarTitle,
          style: TextStyle(fontSize: 18.0),
        ),
        actions: <Widget>[
          todo.id == 0 || todo.id == null
              ? Container()
              : IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {
              await _askUser(
                  'Do You Want To Delete Todo', 'Yes', 'No');
              if (_value == 'save') {
                //here options are opposite
                _delete(todo.id);
              }
              if (_value == 'delete') {
                //THIS OPTIONS ALSO OPPOSITE
                debugPrint('FAB clicked');
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Center(
          child: Column(
            children: <Widget>[
              FormBuilder(
                autovalidate: _autoValidate,
                key: _fbKey,
                child: InkWell(
                  onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      const SizedBox(height: 24.0),

                      //title
                      Container(
                        child: new TextFormField(
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter title';
                            }
                            return null;
                          },
                          controller: _titleController,
                          onSaved: (_value) {
                            isTyped = true;
                            todo.title = _titleController.text;
                          },
                          onChanged: (_value) {
                            setState(() {
                              isTyped = true;
                            });
                          },
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 15.0, vertical: 17.0),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                                borderSide:
                                BorderSide(color: Colors.white, width: 0.1),
                              ),
                              icon: Icon(
                                FontAwesomeIcons.solidHandPointRight,
                                color: Colors.black,
                                size: 20.0,
                              ),
                              filled: true,
                              fillColor: Color(0xffD2E8E6),
                              labelText: 'Title',
                              alignLabelWithHint: true,
                              labelStyle: _labelStyle
                          ),
                        ),
                      ),
                      SizedBox(height: 24.0),

                      //start date
                      FormBuilderDateTimePicker(
                        attribute: "date",
                        inputType: InputType.date,
                        resetIcon: null,
                        format: DateFormat("yyyy-MM-dd"),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 15.0, vertical: 4.0),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                            borderSide:
                            BorderSide(color: Colors.white, width: 0.1),
                          ),
                          filled: true,
                          fillColor: Color(0xffD2E8E6),
                          labelText: "Date",
                          labelStyle: _labelStyle,
                          icon: Icon(
                            FontAwesomeIcons.solidCalendarAlt,
                            color: Colors.black,
                            size: 20.0,
                          ),
                        ),
                        initialValue: DateTime.parse(createdAt),
                        controller: _dateController,
                        onSaved: (value) {
                          setState(() {
                            isTyped = true;
                            var newDate = formatDate(
                                value, [yyyy, '-', mm, '-', dd]).toString();
                            print('user selected Date:  $newDate');
                            createdAt = newDate.substring(0, 10);
                          });
                        },
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      _showCircularProgress(),

                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          children: <Widget>[
                            //contentPadding: EdgeInsets.symmetric(horizontal: 100.0),
                            SizedBox(
                              width: 22.0,
                              child: Checkbox(
                                value: _isCompleted,
                                onChanged: (bool value) {
                                  setState(() {
                                    isTyped = true;
                                    _isCompleted = value;
                                    todo.completed = value ? 1 : 0;
                                  });
                                },
                                materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                              ),
                            ),
                            SizedBox(
                              width: 15.0,
                            ),
                            //contentPadding: EdgeInsets.only(right: 0),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                'Mark as Completed⭐',
                                style: TextStyle(
                                    fontSize: 18.0,
                                    color: Color.fromRGBO(61, 61, 61, 1)),
                              ),
                            ),
                          ],
                        ),
                      ),

                      //button
                      Row(
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 70.0, top: 10, bottom: 10),
                              child: SizedBox(
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width / 3,
                                height: 35.0,
                                child: new RaisedButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0)),
                                  color: Colors.teal,
                                  child: new Text('SAVE',
                                      style: TextStyle(color: Colors.white)),
                                  onPressed: () {
                                    _fbKey.currentState.save();
                                    if (_fbKey.currentState.validate()) {
                                      print(_fbKey.currentState.value);
                                      _showLoading();
                                      _save();
                                    } else {
                                      print(_fbKey.currentState.value);
                                      print("validation failed");
                                      _scaffoldKey.currentState.showSnackBar(
                                          SnackBar(
                                              duration: Duration(seconds: 3),
                                              backgroundColor: Colors.red,
                                              content: Text(
                                                  "Somthing went wrong!")));
                                    }
                                  },
                                ),
                              )),
                          Padding(
                              padding: EdgeInsets.only(left: 10.0),
                              child: SizedBox(
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width / 3.8,
                                height: 35.0,
                                child: new RaisedButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0)),
                                  color: Colors.redAccent,
                                  child: new Text('DISCARD',
                                      style: TextStyle(color: Colors.white)),
                                  onPressed: () {
                                    print('deleted todo');
                                    moveToLastScreen();
                                    /*if(todo.actId > 0)
                                      _delete(todo.id);
                                  */
                                  },
                                ),
                              )),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _showCircularProgress() {
    if (isLoading) {
      return Center(
          child: CircularProgressIndicator(backgroundColor: Colors.teal));
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  void _updateDateTime() {
    setState(() {
      createdAt =
          DateTime.parse(_dateController.text).toString().substring(0, 10);
    });
  }

  Future<int> _save() async {
    _updateDateTime();
    int result;
    todo.createdAt = createdAt;
    if (todo.id != null) {
      //update
      result = await todoHelper.updateTodo(todo);
    } else {
      //insert
      result = await todoHelper.insertTodo(todo);
    }
    if (result != 0) {
      _hideLoading();
      moveToLastScreen();
      _showToastMessage(context, 'Todo successfully Saved');
      return result;
    } else {
      _hideLoading();
      _showToastMessage(context, 'Problem on saveing Todo');
      return 0;
    }
  }

  void _delete(int newId) async {
    int result;
    result = await todoHelper.deleteTodo(newId);
    if (result != 0) {
      moveToLastScreen();
      _showToastMessage(context, "Todo Deleted Successfully");
    } else {
      _showToastMessage(context, "Todo Deleted Failed !!!");
    }
  }

  _showToastMessage(BuildContext context, String message) {
    return Toast.show(message, context,
        duration: Toast.LENGTH_LONG,
        gravity: Toast.BOTTOM,
        backgroundColor: Colors.teal,
        textColor: Colors.white);
  }
  }
