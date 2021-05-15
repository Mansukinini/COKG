import 'package:cokg/src/areas/models/user.dart';

class AppState {
  UserAuth _userProfile;

  String userFullName() {
    String result;

    result = _userProfile.firstName.toString() + " " + _userProfile.lastName.toString();
    return result;
  }

  setUserAuthorization(UserAuth userProfile) {
    _userProfile = userProfile;
  }
}