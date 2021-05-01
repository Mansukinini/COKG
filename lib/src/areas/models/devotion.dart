class Devotion {
  final String id;
  final String title;
  final String description;
  final bool isUploaded;
  final String url;
  final String fileName;
  final String displayName;
  final String miniType;
  final String createdBy;
  final String createdOn;

  Devotion({this.id, this.title, this.description, this.isUploaded, this.url, this.fileName, this.displayName, this.miniType, this.createdBy, this.createdOn});

  factory Devotion.fromFirestore(Map<String, dynamic> firestore) {
    return Devotion(
      id: firestore['id'],
      title: firestore['title'],
      description: firestore['description'],
      isUploaded: firestore['isUploaded'],
      url: firestore['url'],
      fileName: firestore['fileName'],
      // displayName: firestore['displayName'],
      // miniType: firestore['miniType'],
      createdBy: firestore['createdBy'],
      createdOn: firestore['createdOn']
    );
  }

  Map <String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isUploaded': isUploaded,
      'url': url,
      'fileName': fileName,
      // 'displayName': displayName,
      // 'miniType': miniType,
      'createdBy': createdBy,
      'createdOn': createdOn
    };
  }
}