import 'package:cokg/src/app-state.dart';
import 'package:cokg/src/areas/models/user.dart';

class AuthorizeStep {
  final appState = AppState();

  setUserProfileAuthorization(Users userProfile) {
    if (userProfile != null) {
      appState.setUserAuthorization(userProfile);
    }
  }
}