
import 'package:flutter/cupertino.dart';
import 'package:we_story/users.dart';

class UserDataProvider extends ChangeNotifier {
  UserModel? userData;
  void setUserData(UserModel user) {
    this.userData = user;
    notifyListeners();
  }
}
