class Todo {
  int _id;
  int _completed;
  String _title;
  String _createdAt;

  Todo(this._completed, this._title, this._createdAt);

  Todo.withID(this._id, this._completed, this._title, this._createdAt);


 /* Todo.fromMap(Map myMap){

    this._completed = checkInteger(myMap["check"]);
    this._title = myMap["title"];
    this._createdAt = myMap["assigned_to"];
  }
*/
  int get id => _id;

  int get completed => _completed;

  String get title => _title;

  String get createdAt => _createdAt;


  set completed(int newCheck) {
    if (newCheck.bitLength <= 3) {
      this._completed = newCheck;
    }
  }

  set title(String newTitle) {
    if (newTitle.length <= 255) {
      this._title = newTitle;
    }
  }

  set createdAt(String newOrg) {
    if (newOrg.length <= 255) {
      this._createdAt = newOrg;
    }
  }


  // Convert a Note object into a Map object
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = _id;
    }
    map['completed'] = _completed;
    map['title'] = _title;
    map['createdAt'] = _createdAt;

    return map;
  }

// Extract a Note object from a Map object
  Todo.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._title = map['title'];
    this._createdAt = map['createdAt'];
    this._completed = map['completed'];
  }

}