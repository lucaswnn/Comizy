import 'package:comizy/pages/main_pageview.dart';
import 'package:comizy/routes.dart';
import 'package:comizy/values/app_routes.dart';
import 'package:comizy/utils/navigation_helper.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      restorationScopeId: 'app',
      initialRoute: AppRoutes.mainPage,
      navigatorKey: NavigationHelper.key,
      onGenerateRoute: Routes.generateRoute,
      home: const MainPageView(),
    );
  }
}
