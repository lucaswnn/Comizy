import 'package:comizy/tads/user.dart';
import 'package:flutter/material.dart';

class MainUserNotifier with ChangeNotifier {
  MainUser? _mainUser;
  MainUser? get mainUser => _mainUser;
  set mainUser(MainUser? mainUser) {
    _mainUser = mainUser;
    notifyListeners();
  }
}
