import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'src/home.dart';
import 'src/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    var themeData = MainThemeData().mainThemeData;
    return ChangeNotifierProvider(
      create: (context) {},
      child: MaterialApp(
        title: "App",
        theme: themeData,
        home: const MyHome(),
      ),
    );
  }
}
