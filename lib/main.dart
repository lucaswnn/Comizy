import 'package:comizy/app.dart';
import 'package:comizy/services/change_notifiers/market_change_notifier.dart';
import 'package:comizy/services/change_notifiers/navigation_change_notifier.dart';
import 'package:comizy/services/change_notifiers/offer_register_change_notifier.dart';
import 'package:comizy/services/database_dao.dart';
import 'package:comizy/services/change_notifiers/showcase_change_notifier.dart';
import 'package:comizy/services/change_notifiers/user_change_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:provider/provider.dart';

void main() async {
  usePathUrlStrategy();
  await DatabaseDAO.initialize();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserChangeNotifier()),
        ChangeNotifierProvider(create: (_) => ShowcaseChangeNotifier()),
        ChangeNotifierProvider(create: (_) => MarketChangeNotifier()),
        ChangeNotifierProvider(create: (_) => OfferRegisterChangeNotifier()),
        ChangeNotifierProvider(create: (_) => NavigationChangeNotifier()),
      ],
      child: const MyApp(),
    ),
  );
}
