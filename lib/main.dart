import 'package:comizy/src/screen/home.dart';
import 'package:comizy/src/screen/init_screen.dart';
import 'package:comizy/src/theme/theme.dart';
import 'package:comizy/src/state/state.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeData = MainThemeData.mainThemeData;
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Comizy",
        theme: themeData,
        initialRoute: '/init',
        routes: {
          '/init': (context) => const InitScreen(),
          '/home': (context) => const MyHome(),
        },
      ),
    );
  }
}
