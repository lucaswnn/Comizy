import 'package:comizy/src/screen/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:comizy/src/screen/home.dart';
import 'package:comizy/src/theme/theme.dart';
import 'package:comizy/src/state/state.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    var themeData = MainThemeData.mainThemeData;
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "App",
        theme: themeData,
        home: const MyHome(),
        routes: {
          '/adicionar_produto': (context) => const ProductRegisterScreen(),
          '/adicionar_loja': (context) => const ShopRegisterScreen(),
        },
      ),
    );
  }
}
