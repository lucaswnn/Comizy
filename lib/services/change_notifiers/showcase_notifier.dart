import 'package:comizy/services/auth/auth_service.dart';
import 'package:comizy/services/change_notifiers/database_loadable.dart';
import 'package:comizy/services/database/database_parser.dart';
import 'package:comizy/tads/showcase.dart';
import 'package:comizy/tads/wallet.dart';
import 'package:flutter/material.dart';

class ShowcaseNotifier extends DatabaseLoadable with ChangeNotifier {
  Showcase? _showcase;
  Showcase? get showcase => _showcase;

  set showcase(Showcase? showcase) {
    _showcase = showcase;
    notifyListeners();
  }

  ShowcaseItem? _currentShowcaseItem;
  ShowcaseItem? get currentShowcaseItem => _currentShowcaseItem;

  set currentShowcaseItem(ShowcaseItem? item) {
    _currentShowcaseItem = item;
    notifyListeners();
  }

  ShowcaseAddSpaceStatus addShowcaseSpace(Wallet wallet) {
    if (_showcase == null) {
      return ShowcaseAddSpaceStatus.error;
    }
    final result = _showcase!.addShowcaseSpace(wallet);
    if (result == ShowcaseAddSpaceStatus.success) {
      notifyListeners();
    }
    return result;
  }

  ShowcaseAddItemStatus addShowcaseItem(ShowcaseItem item) {
    if (_showcase == null) {
      return ShowcaseAddItemStatus.error;
    }
    final status = _showcase!.addShowcaseItem(item);
    if (status != ShowcaseAddItemStatus.success) {
      return status;
    }
    notifyListeners();
    return status;
  }

  ShowcaseRemoveStatus removeShowcaseItem(ShowcaseItem item) {
    if (_showcase == null) {
      return ShowcaseRemoveStatus.error;
    }
    final status = _showcase!.removeShowcaseItem(item);
    if (status != ShowcaseRemoveStatus.success) {
      return status;
    }
    notifyListeners();
    return status;
  }

  @override
  Future<void> handleLoadData() async {
    final authService = AuthService.instance;
    final user = authService.currentUser;
    if (user == null) {
      throw 'Usuário não logado';
    }
    
    _showcase = await DatabaseParser.getShowcase(user.id);
  }
}
