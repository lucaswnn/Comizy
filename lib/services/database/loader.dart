import 'package:comizy/services/auth/auth_service.dart';
import 'package:comizy/services/change_notifiers/help_request_notifier.dart';
import 'package:comizy/services/change_notifiers/location_notifier.dart';
import 'package:comizy/services/change_notifiers/main_user_notifier.dart';
import 'package:comizy/services/change_notifiers/showcase_notifier.dart';
import 'package:comizy/services/database/database_parser.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class Loader {
  Loader._();

  static bool _isLoaded = false;

  static Future<void> loadDatabaseDataToApp(BuildContext context) async {
    if (_isLoaded) {
      return;
    }

    final userNotifier = context.read<MainUserNotifier>();
    final showcaseNotifier = context.read<ShowcaseNotifier>();
    final locationNotifier = context.read<LocationNotifier>();
    final helpRequestNotifier = context.read<HelpRequestNotifier>();

    final authService = AuthService.instance;
    final user = authService.currentUser;
    if (user == null) {
      throw 'Usuário não logado';
    }
    userNotifier.mainUser = await DatabaseParser.getUser(user.id);
    showcaseNotifier.showcase = await DatabaseParser.getShowcase(user.id);
    locationNotifier.maxRadiusDistanceInKm =
        await DatabaseParser.getMaxSearchDistanceInKm(user.id);
    await locationNotifier.setNeighborhoods();
    final neighborhoods = locationNotifier.neighborhoods;
    if (neighborhoods != null) {
      helpRequestNotifier.helpRequests =
          await DatabaseParser.getHelpRequests(neighborhoods);
    }
    await DatabaseParser.getMarket();
    _isLoaded = true;
  }
}
