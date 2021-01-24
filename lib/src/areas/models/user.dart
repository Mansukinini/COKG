class Users {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final bool isValid;
  final String createdBy;
  final String createdOn;
  final String lastUploadBy;
  final String lastUploadOn;

  Users({this.id, this.firstName, this.lastName, this.email, this.isValid, this.createdBy, this.createdOn,
    this.lastUploadBy, this.lastUploadOn});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstName': firstName,
      'lastname': lastName,
      'email': email,
      'isValid': isValid,
      'createdBy': createdBy,
      'createdOn': createdOn,
      'lastUpdatedBy': lastUploadBy,
      'lastUpdatedOn': lastUploadOn
    };
  }

  Users.fromFirestore(Map<String, dynamic> user)
    : id = user['id'],
    firstName = user['firstName'],
    lastName = user['lastName'],
    email = user['email'],
    isValid = user['isValid'],
    createdBy = user['createdBy'],
    createdOn = user['createdOn'],
    lastUploadBy = user['lastUpdatedBy'],
    lastUploadOn = user['lastUpdatedOn'];
}