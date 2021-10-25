import 'package:cokg/src/areas/models/devotion.dart';
import 'package:cokg/src/areas/services/data/firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';

class DevotionRepositry {
  final FirestoreService _firestoreService = FirestoreService.instance;
  var uuid = Uuid();

  // declaretion
  final _id = BehaviorSubject<String>();
  final _title = BehaviorSubject<String>();
  final _description = BehaviorSubject<String>();
  final _isUploaded = BehaviorSubject<bool>();
  final _url = BehaviorSubject<String>();
  final _fileName = BehaviorSubject<String>();
  final _createdBy = BehaviorSubject<String>();
  final _createdOn = BehaviorSubject<DateTime>();

  final _devotion = BehaviorSubject<Devotion>();

  //Gettes
  Stream<String> get getId => _id.stream;
  Stream<String> get getTitle => _title.stream;
  Stream<String> get getDescription => _description.stream;
  Stream<bool> get getIsUploaded => _isUploaded.stream;
  Stream<String> get getUrl => _url.stream;
  Stream<String> get getFileName => _fileName.stream;
  Stream<String> get getCreatedBy => _createdBy.stream;
  Stream<DateTime> get getCreatedOn => _createdOn.stream;
  Stream<Devotion> get getDevotion => _devotion.stream;

  //Settes
  Function(String) get setId => _id.sink.add;
  Function(String) get setTitle => _title.sink.add;
  Function(String) get setDescription => _description.sink.add;
  Function(bool) get setIsUploaded => _isUploaded.sink.add;
  Function(String) get setUrl => _url.sink.add;
  Function(String) get setFileName => _fileName.sink.add;
  Function(String) get setCreatedBy => _createdBy.sink.add;
  Function(DateTime) get setCreatedOn => _createdOn.sink.add;

  void setDevotion(Devotion devotion, String id) {
    setId(id);
    
    if (id != null && devotion.toMap() != null) {
      setTitle(devotion.title);
      setDescription(devotion.description);
      setUrl(devotion.url);
    } else {
      setTitle(null);
      setDescription(null);
      setUrl(null);
    }
  }

 Stream<List<Devotion>> get devotion => _firestoreService.getDevotions();

 Future<Devotion> getDevotionById(String id) => _firestoreService.getDevotionById(id);

  Future uploadFile() async {
    // var path = await FilePicker.getFilePath(type: FileType.AUDIO);
    

    // FilePickerResult result = await FilePicker.platform.pickFiles();
    
    // if (path != null) {
    //   setId(uuid.v4());
    //   _isUploaded.sink.add(true);
    //   setCreatedOn(DateTime.now());

    //   var audioUrl = await FirebaseStorageService.uploadAudio(File(path), uuid.v4());
    //   print(audioUrl);
      
    //   if (audioUrl != null) {
    //     setUrl(audioUrl);
    //     setFileName(basename(audioUrl));
    //   }
      
    //   return audioUrl;
    // }
    return null;
  }

  Future<void> saveDevotion() async {

    Devotion devotion = Devotion(
      id: _id.hasValue ? _id.value : Uuid().v4(), 
      title: _title.value,
      fileName: _fileName.hasValue ? _fileName.value : null,
      description: _description.hasValue ? _description.value : null,
      url: _url.value,
      createdOn: _createdOn.hasValue ? _createdOn.value.toIso8601String() : null
    );

    return await _firestoreService.createDevotion(devotion);
  }

  Future<void> deleteDevotion(String id) {
    return _firestoreService.deleteDevotion(id);
  }

  dispose() {
    _id.close();
    _title.close();
    _description.close();
    _isUploaded.close();
    _url.close();
    _fileName.close();
    _createdBy.close(); 
    _createdOn.close();

    _devotion.close();
  }
}