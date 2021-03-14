import 'package:cokg/src/areas/models/group.dart';
import 'package:cokg/src/areas/services/data/database.dart';
import 'package:cokg/src/areas/services/data/firebase-storage.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';
import 'package:uuid/uuid.dart';

class GroupProvider {
  final databaseService = DatabaseService();
  final storageService = FirebaseStorageService();
  var uuid = Uuid();
  
  final _id = BehaviorSubject<String>();
  final _name = BehaviorSubject<String>();
  final _description = BehaviorSubject<String>();
  final _imageUrl = BehaviorSubject<String>();
  final _startDateTime = BehaviorSubject<DateTime>();
  final _endDateTime = BehaviorSubject<DateTime>();

  //Gettes
  Stream<String> get getId => _id.stream;
  Stream<String> get getName => _name.stream;
  Stream<String> get getDescription => _description.stream;
  Stream<String> get getImageUrl => _imageUrl.stream;
  Stream<DateTime> get getStartDateTime => _startDateTime.stream;
  Stream<DateTime> get getEndDateTime => _endDateTime.stream;

  //Settes
  Function(String) get setId => _id.sink.add;
  Function(String) get setName => _name.sink.add;
  Function(String) get setDescription => _description.sink.add;
  Function(String) get setImageUrl => _imageUrl.sink.add;
  Function(DateTime) get setStartDateTime => _startDateTime.sink.add;
  Function(DateTime) get setEndDateTime => _endDateTime.sink.add;

  Future save() async {
    var group = Group(id: uuid.v4(), name: _name.value, description: _description.value);
    print(group.toMap());
  }

  dispose() {
    _id.close();
    _name.close();
    _description.close();
    _imageUrl.close();
    _startDateTime.close();
    _endDateTime.close();
  }
}