import 'package:cokg/src/areas/models/user.dart';

class AppState {
  Users _userProfile;

  String userFullName() {
    String result;

    result = _userProfile.firstName.toString() + " " + _userProfile.lastName.toString();
    return result;
  }

  setUserAuthorization(Users userProfile) {
    _userProfile = userProfile;

    print(_userProfile.firstName + ' from Authorization');
    print(_userProfile.lastName + ' from Authorization');
  }


}