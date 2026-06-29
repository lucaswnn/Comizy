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

  Future<ShowcaseAddSpaceStatus> addShowcaseSpace(Wallet wallet) async {
    if (_showcase == null) {
      return ShowcaseAddSpaceStatus.error;
    }
    if (!_showcase!.isSpaceAddable(wallet)) {
      return ShowcaseAddSpaceStatus.notEnoughCash;
    }

    try {
      await DatabaseParser.addShowcaseSpace(
        newWalletCash: wallet.cash - _showcase!.newSpaceCost,
      );
      final result = _showcase!.addShowcaseSpace(wallet);
      if (result == ShowcaseAddSpaceStatus.success) {
        notifyListeners();
      }
      return result;
    } catch (_) {
      return ShowcaseAddSpaceStatus.error;
    }
  }

  Future<ShowcaseAddItemStatus> addShowcaseItem(ShowcaseItem item) async {
    if (_showcase == null) {
      return ShowcaseAddItemStatus.error;
    }

    final status = _showcase!.previewAddShowcaseItem(item);
    if (status != ShowcaseAddItemStatus.success) {
      return status;
    }

    try {
      await DatabaseParser.addShowcaseItem(item);
      final result = _showcase!.addShowcaseItem(item);
      if (result == ShowcaseAddItemStatus.success) {
        notifyListeners();
      }
      return result;
    } catch (_) {
      return ShowcaseAddItemStatus.error;
    }
  }

  Future<ShowcaseRemoveStatus> removeShowcaseItem(ShowcaseItem item) async {
    if (_showcase == null) {
      return ShowcaseRemoveStatus.error;
    }

    final status = _showcase!.previewRemoveShowcaseItem(item);
    if (status != ShowcaseRemoveStatus.success) {
      return status;
    }

    try {
      await DatabaseParser.removeShowcaseItem(item);
      final result = _showcase!.removeShowcaseItem(item);
      if (result == ShowcaseRemoveStatus.success) {
        notifyListeners();
      }
      return result;
    } catch (_) {
      return ShowcaseRemoveStatus.error;
    }
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
