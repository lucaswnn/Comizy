import 'package:comizy/utils/navigation_helper.dart';
import 'package:comizy/utils/snackbar_helper.dart';
import 'package:comizy/values/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:comizy/routes.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      restorationScopeId: 'app',
      initialRoute: AppRoutes.landingPage,
      navigatorKey: NavigationHelper.key,
      onGenerateRoute: Routes.generateRoute,
      scaffoldMessengerKey: SnackbarHelper.key,
    );
  }
}
