import 'package:comizy/app.dart';
import 'package:comizy/services/change_notifiers/help_request_notifier.dart';
import 'package:comizy/services/change_notifiers/location_notifier.dart';
import 'package:comizy/services/change_notifiers/main_user_notifier.dart';
import 'package:comizy/services/change_notifiers/market_notifier.dart';
import 'package:comizy/services/change_notifiers/product_notifier.dart';
import 'package:comizy/services/change_notifiers/shop_notifier.dart';
import 'package:comizy/services/change_notifiers/showcase_notifier.dart';
import 'package:flutter/material.dart';
//import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
//import 'firebase_options.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Supabase.initialize(
    url: 'https://lcukugkbfzqfuehbxfqv.supabase.co',
    anonKey: 'sb_publishable_Lz4MYgQuF9EAVpVAtblp4g_Dtiuxo8r',
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MainUserNotifier()),
        ChangeNotifierProvider(create: (_) => LocationNotifier()),
        ChangeNotifierProvider(create: (_) => HelpRequestNotifier()),
        ChangeNotifierProvider(create: (_) => ShowcaseNotifier()),
        ChangeNotifierProvider(create: (_) => ProductNotifier()),
        ChangeNotifierProvider(create: (_) => ShopNotifier()),
        ChangeNotifierProvider(create: (_) => MarketNotifier()),
      ],
      child: const App(),
    ),
  );
}
