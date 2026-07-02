import 'package:comizy/services/auth/auth_service.dart';
import 'package:comizy/services/change_notifiers/database_loadable.dart';
import 'package:comizy/services/database/database_parser.dart';
import 'package:comizy/tads/ranking.dart';
import 'package:flutter/material.dart';

class NullRankingException implements Exception {
  final String message;
  NullRankingException(this.message);

  @override
  String toString() => 'NullRankingException: $message';
}

class RankingNotifier extends DatabaseLoadable with ChangeNotifier {
  Ranking? _ranking;

  Ranking get ranking {
    if (_ranking == null) {
      throw NullRankingException('Ranking nao foi inicializado');
    }
    return _ranking!;
  }

  @override
  Future<void> handleLoadData() async {
    final authService = AuthService.instance;
    final user = authService.currentUser;
    if (user == null) {
      throw 'Usuario nao logado';
    }

    _ranking = await DatabaseParser.getRanking(currentUserId: user.id);
  }
}
