import 'package:comizy/screen/home/home_screen.dart';
import 'package:comizy/screen/init_load_screen.dart';
import 'package:comizy/screen/login_screen.dart';
import 'package:comizy/state/cart_state.dart';
import 'package:comizy/state/geo_state.dart';
import 'package:comizy/state/market_state.dart';
import 'package:comizy/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // tema do app
    final theme = AppThemeData();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GeoState()),
        ChangeNotifierProvider(create: (_) => MarketState()),
        ChangeNotifierProvider(create: (_) => CartState()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Comizy",
        theme: theme.appThemeData(),
        initialRoute: '/login',
        routes: {
          '/login': (_) => const LoginScreen(),
          '/init_load': (_) => const InitLoadScreen(),
          '/home': (_) => const HomeScreen(),
          '/register': (_) => const Placeholder(),
          '/cart': (_) => const Placeholder(),
        },
      ),
    );
  }
}
