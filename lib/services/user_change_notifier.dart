import 'package:comizy/exceptions/user_exception.dart';
import 'package:comizy/tads/user.dart';
import 'package:flutter/material.dart';

class UserChangeNotifier extends ChangeNotifier {
  User? _user;
  User? get user =>
      _user ??
      const User(
          name: 'name',
          number: 'number'
          ); //(throw UserIsNullException('failed to get user in UserChangeNotifier: _user == null'));

  void createUser({
    required String name,
    required String number,
  }) {
    if (_user != null) {
      throw UserAlreadyCreatedException(
          'failed to create user in UserChangeNotifier.createUser: _user != null');
    }
    _user = User(
      name: name,
      number: number,
    );
    notifyListeners();
  }
}
