import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:comizy/src/home.dart';
import 'package:comizy/src/theme.dart';
import 'package:comizy/src/state.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    var themeData = MainThemeData().mainThemeData;
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: "App",
        theme: themeData,
        home: const MyHome(),
      ),
    );
  }
}
