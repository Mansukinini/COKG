import 'dart:io';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';
import 'package:cokg/src/areas/models/Event.dart';
import 'package:cokg/src/areas/services/data/database.dart';
import 'package:cokg/src/areas/services/data/firebase-storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';


class EventProvider {
  final _auth = FirebaseAuth.instance;
  var uuid = Uuid();
 
  // declaretion
  final _id = BehaviorSubject<String>();
  final _name = BehaviorSubject<String>();
  final _description = BehaviorSubject<String>();
  final _dateTime = BehaviorSubject<DateTime>();
  final _imageUrl = BehaviorSubject<String>();
  final _isUploaded = BehaviorSubject<bool>();
  final _createdBy = BehaviorSubject<String>();
  final _createdOn = BehaviorSubject<DateTime>();
  final _lastUpdatedBy = BehaviorSubject<String>();
  final _lastUpdatedOn = BehaviorSubject<DateTime>();

  final _event = BehaviorSubject<Event>();

  //Gettes
  Stream<String> get getId => _id.stream;
  Stream<String> get getName => _name.stream;
  Stream<String> get getDescription => _description.stream;
  Stream<DateTime> get getDateTime => _dateTime.stream;
  Stream<String> get getImageUrl => _imageUrl.stream;
  Stream<bool> get getIsUploaded => _isUploaded.stream;
  Stream<String> get getCreatedBy => _createdBy.stream;
  Stream<DateTime> get getCreatedOn => _createdOn.stream;
  Stream<String> get getLastUpdatedBy => _lastUpdatedBy.stream;
  Stream<DateTime> get getLastUpdatedOn => _lastUpdatedOn.stream;
  Stream<Event> get getEvent => _event.stream;
 
  //Settes
  Function(String) get setId => _id.sink.add;
  Function(String) get setName => _name.sink.add;
  Function(String) get setDescription => _description.sink.add;
  Function(DateTime) get setDateTime => _dateTime.sink.add;
  Function(String) get setImageUrl => _imageUrl.sink.add;
  Function(bool) get setIsUploaded => _isUploaded.sink.add;
  Function(String) get setCreatedBy => _createdBy.sink.add;
  Function(DateTime) get setCreatedOn => _createdOn.sink.add;
  Function(String) get setLastUpdatedBy => _lastUpdatedBy.sink.add;
  Function(DateTime) get setLastUpdatedOn =>_lastUpdatedOn.sink.add;

  Function(Event) get setEvent => _event.sink.add;

  Stream<List<Event>> get events => DatabaseService.getEvents();

  Future<Event> getEventById(String id) {
    return DatabaseService.getEventById(id);
  }

  setChanges(Event event) {
   
    if (event.id != null) {
      setId(event.id);
      setName(event.name);
      setDescription(event.description);
      setDateTime(DateTime.parse(event.date));
      setImageUrl(event.imageUrl);
      setIsUploaded(event.isUploaded);
      setCreatedBy(event.createdBy);
      setCreatedOn(DateTime.parse(event.createdOn));
      setLastUpdatedBy(event.lastUploadBy);
      setLastUpdatedOn(DateTime.now());
    } else {
      setId(null);
      setName(null);
      setDescription(null);
      setDateTime(DateTime.parse(event.date));
      setImageUrl(null);
      setIsUploaded(event.isUploaded);
      setCreatedBy(_auth.currentUser.uid);
      setCreatedOn(DateTime.now());
      setLastUpdatedBy(null);
      setLastUpdatedOn(null);
    }
  }

  Future pickImage() async {

    //Get image from Device
    PickedFile image = await ImagePicker().getImage(source: ImageSource.gallery);

    //Upload to Firebase
    if (image != null) {
      var imageUrlDb = await FirebaseStorageService.uploadEventImage(File(image.path), uuid.v4());
      if (imageUrlDb != null) {
        setImageUrl(imageUrlDb);
        _isUploaded.sink.add(true);
      }

    } else {
      print('No path Received');
    }
  }

  // Todo: Add Validation

  Future<void> saveEvent() {

    if (_id.value != null) {
      // Edit new 
      var initialValues = Event(
        id: _id.value, 
        name: _name.value, 
        description: _description.hasValue ? _description.value : null,
        date: _dateTime.hasValue ? _dateTime.value.toIso8601String() : null,
        imageUrl: _imageUrl.hasValue ? _imageUrl.value : null, 
        isUploaded: _isUploaded.value, 
        createdBy: _auth.currentUser.uid, 
        createdOn: DateTime.now().toIso8601String()
      );

      print('Date Values');
      print(initialValues.date);

      return DatabaseService.saveChanges(initialValues).then((value) => print('Save'))
        .catchError((error) => print(error));
    } else {

      var event = Event(id: _id.value, 
        name: _name.value, 
        description: _description.value, 
        date: _dateTime.hasValue ? _dateTime.value.toString() : null,
        imageUrl: _imageUrl.value, 
        isUploaded: _isUploaded.value, 
        createdBy: _createdBy.value, 
        createdOn: _createdOn.value.toIso8601String(),
        lastUploadBy: _lastUpdatedBy.value,
        lastUploadOn: DateTime.now().toIso8601String());
        print('Edit ' + event.toString());

      return DatabaseService.saveChanges(event).then((value) => print(value))
        .catchError((error) => print(error));
    }
  }

  dispose() {
    _id.close();
    _name.close();
    _dateTime.close();
    _description.close();
    _imageUrl.close();
    _isUploaded.close();
    _createdBy.close(); 
    _createdOn.close();
    _lastUpdatedBy.close();
    _lastUpdatedOn.close();

    _event.close();
  }
}