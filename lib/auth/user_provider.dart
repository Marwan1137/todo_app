/* -------------------------------------------------------------------------- */
/*                               User Provider                                  */
/* -------------------------------------------------------------------------- */
import 'package:flutter/material.dart';
import 'package:todo_app/models/user_model.dart';

class UserProvider with ChangeNotifier {
  UserModel? userModel;
  /* -------------------------------------------------------------------------- */
  /*                            User Update Method                                */
  /* -------------------------------------------------------------------------- */
  void updateUser(UserModel? userModel) {
    this.userModel = userModel;
    notifyListeners();
  }
}
