import 'package:comizy/app.dart';
import 'package:comizy/services/database_dao.dart';
import 'package:comizy/services/product_cart_change_notifier.dart';
import 'package:comizy/services/showcase_change_notifier.dart';
import 'package:comizy/services/user_change_notifier.dart';
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
        ChangeNotifierProvider(create: (_) => ProductCartChangeNotifier()),
        ChangeNotifierProvider(create: (_) => ShowcaseChangeNotifier()),
      ],
      child: const MyApp(),
    ),
  );
}
