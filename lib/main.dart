import 'package:comizy/app.dart';
import 'package:comizy/services/change_notifiers/help_request_notifier.dart';
import 'package:comizy/services/change_notifiers/location_notifier.dart';
import 'package:comizy/services/change_notifiers/market_notifier.dart';
import 'package:comizy/services/change_notifiers/other_users_notifier.dart';
import 'package:comizy/services/change_notifiers/product_notifier.dart';
import 'package:comizy/services/change_notifiers/shop_notifier.dart';
import 'package:comizy/services/change_notifiers/showcase_notifier.dart';
import 'package:comizy/services/change_notifiers/main_user_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MainUserNotifier()),
        ChangeNotifierProvider(create: (_) => LocationNotifier()),
        ChangeNotifierProvider(create: (_) => ShowcaseNotifier()),
        ChangeNotifierProvider(create: (_) => ProductNotifier()),
        ChangeNotifierProvider(create: (_) => ShopNotifier()),
        ChangeNotifierProvider(create: (_) => MarketNotifier()),
        ChangeNotifierProvider(create: (_) => HelpRequestNotifier()),
        ChangeNotifierProvider(create: (_) => OtherUsersNotifier()),
      ],
      child: const App(),
    ),
  );
}
