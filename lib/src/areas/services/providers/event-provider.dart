import 'dart:io';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';
import 'package:cokg/src/areas/models/Event.dart';
import 'package:cokg/src/areas/services/data/firestore.dart';
import 'package:cokg/src/areas/services/data/firebase-storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';


class EventProvider {
  final FirestoreService _firestoreService = FirestoreService.instance;
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
  final _isEventSaved = BehaviorSubject<bool>();

  //Gettes
  Stream<String> get getId => _id.stream;
  Stream<String> get getName => _name.stream.transform(_validateTitle);
  Stream<String> get getDescription => _description.stream;
  Stream<DateTime> get getDateTime => _dateTime.stream;
  Stream<String> get getImageUrl => _imageUrl.stream;
  Stream<bool> get getIsUploaded => _isUploaded.stream;
  Stream<String> get getCreatedBy => _createdBy.stream;
  Stream<DateTime> get getCreatedOn => _createdOn.stream;
  Stream<String> get getLastUpdatedBy => _lastUpdatedBy.stream;
  Stream<DateTime> get getLastUpdatedOn => _lastUpdatedOn.stream;
  Stream<Event> get getEvent => _event.stream;
  Stream<bool> get getIsEventSaved => _isEventSaved.stream;
 
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

  // Function(Event) get setEvent => _event.sink.add;
  Function(bool) get setIsEventSaved => _isEventSaved.sink.add;

  // Get all events
  Stream<List<Event>> get events => _firestoreService.getEvents();

  Future<Event> getEventById(String id) {
    return _firestoreService.getEventById(id);
  }

  void setEvent(Event event, String id) {
    setId(id);
    
    if (id != null && event.toMap() != null) {
      setName(event.name);
      setDescription(event.description);
      if (event.date != null)
        setDateTime(DateTime.parse(event.date));

        if (event != null && event.imageUrl != null)
          setImageUrl(event.imageUrl);
    } else {
      setImageUrl(null);
      setName(null);
      setDescription(null);
      setDateTime(null);
    }
  }

  Future pickImage() async {
    //Get image from Device
    PickedFile image = await ImagePicker().getImage(source: ImageSource.gallery);

    await Permission.photos.request();

    var permissionStatus = await Permission.photos.status;
    if (permissionStatus.isGranted) {

    }

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

  Future<void> saveEvent() {

    var initialValues = Event(
      id: _id.value ?? uuid.v4(), 
      name: _name.value, 
      description: _description.hasValue ? _description.value : null,
      date: (_dateTime.hasValue && _dateTime.value != null) ? _dateTime.value.toIso8601String() : null,
      imageUrl: _imageUrl.hasValue ? _imageUrl.value : null, 
      isUploaded: _isUploaded.hasValue ? _isUploaded.value : false, 
      createdBy: _auth.currentUser.uid, 
      createdOn: DateTime.now().toIso8601String()
    );

    return _firestoreService.saveEvent(initialValues)
      .then((value) => _isEventSaved.sink.add(true))
      .catchError((error) => _isEventSaved.sink.add(false));
  }

  Future<void> deleteEvent(String id) {
    return _firestoreService.deleteEvent(id);
  }

  final _validateTitle = StreamTransformer<String, String>.fromHandlers(handleData: (data, sink) {
    if (data != null) {
      if (data.length >= 3 && data.length <= 30){
        sink.add(data.trim());
      } else {
        sink.addError('Enter Title');
      }
    } 
  });

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
    _isEventSaved.close();
  }
}