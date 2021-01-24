import 'dart:io';
import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';
import 'package:cokg/src/areas/models/Event.dart';
import 'package:cokg/src/areas/services/data/database.dart';
import 'package:cokg/src/areas/services/data/firebase-storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';


class EventProvider {
  final databaseService = DatabaseService();
  final storageService = FirebaseStorageService();
  final _picker = ImagePicker();
  var uuid = Uuid();

  // declaretion
  final _id = BehaviorSubject<String>();
  final _name = BehaviorSubject<String>();
  final _description = BehaviorSubject<String>();
  final _date = BehaviorSubject<DateTime>();
  final _imageUrl = BehaviorSubject<String>();
  final _isUploaded = BehaviorSubject<bool>();
  final _createdBy = BehaviorSubject<String>();
  final _createdOn = BehaviorSubject<DateTime>();
  final _lastUpdatedBy = BehaviorSubject<String>();
  final _lastUpdatedOn = BehaviorSubject<DateTime>();
 

  //Gettes
  Stream<String> get id => _id.stream;
  Stream<String> get name => _name.stream;
  Stream<String> get description => _description.stream;
  Stream<DateTime> get date => _date;
  Stream<String> get imageUrl => _imageUrl;
  Stream<bool> get isUploaded => _isUploaded;
  Stream<String> get createdBy => _createdBy;
  Stream<DateTime> get createdOn => _createdOn;
  Stream<String> get lastUpdatedBy => _lastUpdatedBy;
  Stream<DateTime> get lastUpdatedOn => _lastUpdatedOn;


  //Settes
  Function(String) get setId => _id.sink.add;
  Function(String) get setName => _name.sink.add;
  Function(String) get setDescription => _description.sink.add;
  Function(DateTime) get setDate => _date.sink.add;
  Function(String) get setImageUrl =>_imageUrl.sink.add;
  Function(bool) get setIsUploaded => _isUploaded.sink.add;
  Function(String) get setCreatedBy => _createdBy.sink.add;
  Function(DateTime) get setCreatedOn => _createdOn.sink.add;
  Function(String) get setLastUpdatedBy => _lastUpdatedBy.sink.add;
  Function(DateTime) get setLastUpdatedOn =>_lastUpdatedOn.sink.add;

  dispose() {
    _id.close();
    _name.close();
    _date.close();
    _description.close();
    _imageUrl.close();
    _isUploaded.close();
    _createdBy.close();
    _createdOn.close();
    _lastUpdatedBy.close();
    _lastUpdatedOn.close();
    
  }
  
  Stream<List<Event>> get events => databaseService.getEvents();

  Future<Event> getEventByIdForDisplay(String id) {
    return databaseService.getEventById(id);
  }

  setChanges(Event event) {

    if (event.id != null) {
      setId(event.id);
      setName(event.name);
      setDescription(event.description);
      setDate(DateTime.parse(event.date));
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
      setDate(DateTime.parse(event.date));
      setImageUrl(null);
      setIsUploaded(event.isUploaded);
      setCreatedBy(null);
      setCreatedOn(DateTime.parse(event.createdOn));
      setLastUpdatedBy(null);
      setLastUpdatedOn(DateTime.now());
    }
  }

  pickImage() async {
    PickedFile image;
   
    //Get image from Device
    image = await _picker.getImage(source: ImageSource.gallery);
    print(image.path);

    //Upload to Firebase
    if (image != null) {
      var imageUrlDb = await storageService.uploadEventImage(File(image.path), uuid.v4());
      if (imageUrlDb != null) {
        setImageUrl(imageUrlDb);
        _isUploaded.sink.add(true);
      }

    } else {
      print('No path Received');
    }
  }

  // Todo: Add Validation

  save() {
    if (id.toString() == null) {
      // Add new 
      var initialValues = Event(id: uuid.v4(), name: _name.value, description: _description.value, date: _date.value.toIso8601String(),
        imageUrl: _imageUrl.value, isUploaded: _isUploaded.value, createdBy: _createdBy.value, createdOn: DateTime.now().toIso8601String(),
        lastUploadBy: _lastUpdatedBy.value, lastUploadOn: DateTime.now().toIso8601String());
      
      databaseService.saveChanges(initialValues)
      .then((value) => print('Save'))
      .catchError((error) => print(error));
    } else {

      // Edit
      var event = Event(id: _id.value, name: _name.value, description: _description.value, date: _date.value.toIso8601String(),
        imageUrl: _imageUrl.value, isUploaded: _isUploaded.value, createdBy: _createdBy.value, createdOn: _createdOn.value.toIso8601String(),
        lastUploadBy: _lastUpdatedBy.value, lastUploadOn: DateTime.now().toIso8601String());

      databaseService.saveChanges(event)
      .then((value) => print(value))
      .catchError((error) => print(error));
    }
  }
}