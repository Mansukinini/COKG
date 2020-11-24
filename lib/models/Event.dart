class Event {
  int _id;
  String _name;
  String _description;
  String _date;

  Event(this._name, this._description, this._date);

  Event.withId(this._id, this._name, this._description, this._date);

  int get id => _id;
  String get name => _name;
  String get description => _description;
  String get date => _date;


  set name(String name) {
    this._name = name;
  }

  set description(String description) {
    this._description = description;
  }

  set date(String date) {
    this._date = date;
  }

  Map <String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["name"] = _name;
    map["description"] = _description;
    map["date"] = _date;

    if (_id != null) {
      map["id"] = _id;
    }
    return map;
  }

  Event.fromObject(dynamic e) {
    this._id = e["id"];
    this._name = e["name"];
    this._description = e["description"];
    this._date = e["date"];
  }
}