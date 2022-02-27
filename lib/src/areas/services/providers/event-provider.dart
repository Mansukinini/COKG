import 'dart:io';
import 'dart:async';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';
import 'package:cokg/src/areas/models/event.dart';
import 'package:cokg/src/areas/services/data/firestore.dart';
import 'package:cokg/src/areas/services/data/firebase-storage.dart';
import 'package:uuid/uuid.dart';
import 'package:image/image.dart' as Img;


class EventProvider {
  final FirestoreService _firestoreService = FirestoreService.instance;
  var uuid = Uuid().v4();
  String medialUrl;
  PickedFile file;
 
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

  Future pickImage() async {
    //Get image from Device
    file = await ImagePicker().getImage(source: ImageSource.gallery);
    
    //Upload to Firebase
    if (file.path.isNotEmpty) {
      File compressFile = await compressImage();
      medialUrl = await FirebaseStorageService.uploadImage(compressFile, uuid);
      setImageUrl(medialUrl);
      _isUploaded.sink.add(true);
      
      // reset
      uuid = Uuid().v4();
      return compressFile;
    } else {
      return 'No path Received';
    }                                             
  }

  compressImage() async {
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;

    Img.Image imageFile = Img.decodeImage(List.from(await file.readAsBytes()));

    final compressedImageFile = File('$path/img_$uuid.jpg')..writeAsBytesSync(Img.encodeJpg(imageFile, quality: 85));

    return compressedImageFile;
  }

  Future<void> createEvent(String caption, String userId) {

    var initialValues = Event(
      id: uuid, 
      name: _name.hasValue ? _name.value : null, 
      description: caption.isNotEmpty ? caption : null,
      date: _dateTime.hasValue ? _dateTime.value.toIso8601String() : null,
      imageUrl: medialUrl != null ? medialUrl : null, 
      isUploaded: _isUploaded.hasValue ? _isUploaded.value : false, 
      createdBy: userId, 
      createdOn: DateTime.now().toIso8601String()
    );

    setId(null);
    setName(null);
    setDescription(null);
    setImageUrl(null);

    return _firestoreService.saveEvent(initialValues)
      .then((value) {
      })
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