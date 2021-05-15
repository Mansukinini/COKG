class UserAuth {
  final String id;
  final String firstName;
  final String lastName;
  final String contactNo;
  final String email;
  final String imageUrl;
  final bool isValid;
  final String createdBy;
  final String createdOn;
  final String lastUploadBy;
  final String lastUploadOn;

  UserAuth({this.id, this.firstName, this.lastName, this.contactNo, this.email, this.imageUrl, this.isValid, this.createdBy, this.createdOn,
    this.lastUploadBy, this.lastUploadOn});


  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'contactNo': contactNo,
      'email': email,
      'imageUrl': imageUrl,
      'isValid': isValid,
      'createdBy': createdBy,
      'createdOn': createdOn,
      'lastUpdatedBy': lastUploadBy,
      'lastUpdatedOn': lastUploadOn
    };
  }

  UserAuth.fromFirestore(Map<String, dynamic> user)
    : id = user['id'],
    firstName = user['firstName'],
    lastName = user['lastName'],
    contactNo = user['contactNo'],
    email = user['email'],
    imageUrl = user['imageUrl'],
    isValid = user['isValid'],
    createdBy = user['createdBy'],
    createdOn = user['createdOn'],
    lastUploadBy = user['lastUpdatedBy'],
    lastUploadOn = user['lastUpdatedOn'];
}