import 'package:comizy/services/change_notifiers/database_loadable.dart';
import 'package:comizy/services/change_notifiers/help_request_notifier.dart';
import 'package:comizy/services/change_notifiers/location_notifier.dart';
import 'package:comizy/services/change_notifiers/main_user_notifier.dart';
import 'package:comizy/services/change_notifiers/market_notifier.dart';
import 'package:comizy/services/change_notifiers/showcase_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void resetLoadableNotifiers(BuildContext context) {
  final notifiers = <DatabaseLoadable>[
    context.read<HelpRequestNotifier>(),
    context.read<LocationNotifier>(),
    context.read<MainUserNotifier>(),
    context.read<MarketNotifier>(),
    context.read<ShowcaseNotifier>(),
  ];

  for (final notifier in notifiers) {
    notifier.resetReloadFlag();
  }
}
