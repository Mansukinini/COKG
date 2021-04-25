class Group {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final String startDateTime;
  final String endDateTime;

  Group({this.id, this.name, this.description, this.imageUrl, this.startDateTime, this.endDateTime});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'startDateTime': startDateTime,
      'endDateTime': endDateTime,
    };
  }

  factory Group.fromFirestore(Map<String, dynamic> group) {
    return Group(
      id: group['id'],
      name: group['name'],
      description: group['description'],
      imageUrl: group['imageUrl'],
      startDateTime: group['startDateTime'],
      endDateTime: group['endDateTime']
    );
  }
}