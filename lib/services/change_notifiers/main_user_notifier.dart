import 'package:comizy/services/auth/auth_service.dart';
import 'package:comizy/services/change_notifiers/database_loadable.dart';
import 'package:comizy/services/database/database_parser.dart';
import 'package:comizy/tads/app_user.dart';
import 'package:comizy/tads/wallet.dart';
import 'package:flutter/material.dart';

class MainUserNotifier extends DatabaseLoadable with ChangeNotifier {
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

  @override
  Future<void> handleLoadData() async {
    final authService = AuthService.instance;
    final user = authService.currentUser;
    if (user == null) {
      throw 'Usuário não logado';
    }

    _mainUser = await DatabaseParser.getUser(user.id);
  }
}
