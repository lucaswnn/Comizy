import 'package:comizy/tads/app_user.dart';
import 'package:comizy/tads/wallet.dart';
import 'package:flutter/material.dart';

class MainUserNotifier with ChangeNotifier {
  AppMainUser? _mainUser;
  AppMainUser? get mainUser => _mainUser;

  set mainUser(AppMainUser? user) {
    _mainUser = user;
    notifyListeners();
  }

  RemoveCashStatus removeCash(int value) {
    if (_mainUser == null) {
      return RemoveCashStatus.error;
    }

    final result = _mainUser!.wallet.removeCash(value);
    if (result == RemoveCashStatus.success) {
      notifyListeners();
    }
    return result;
  }
}
