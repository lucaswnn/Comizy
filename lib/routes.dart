import 'package:comizy/screens/auth/choose_first_products_screen.dart';
import 'package:comizy/screens/auth/create_account_screen.dart';
import 'package:comizy/screens/auth/login_screen.dart';
import 'package:comizy/screens/auth/tutorial_screen.dart';
import 'package:comizy/screens/home/home_screen.dart';
import 'package:comizy/screens/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:comizy/values/app_routes.dart';
import 'package:comizy/utils/invalid_route.dart';
import 'package:comizy/screens/auth/landing_page_screen.dart';

// Class that handles the app routes.
class Routes {
  const Routes._();

  // Route generator
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Additional function to generate the route widget.
    Route<dynamic> getRoute({
      required Widget widget,
      bool fullscreenDialog = false,
    }) {
      return MaterialPageRoute<void>(
        builder: (context) => widget,
        settings: settings,
        fullscreenDialog: fullscreenDialog,
      );
    }

    // Switch between routes.
    switch (settings.name) {
      case AppRoutes.landingPage:
        return getRoute(widget: const LandingPageScreen());

      case AppRoutes.createAccount:
        return getRoute(widget: const CreateAccountScreen());

      case AppRoutes.login:
        return getRoute(widget: const LoginScreen());

      case AppRoutes.tutorial:
        return getRoute(widget: const TutorialScreen());

      case AppRoutes.chooseFirstProducts:
        return getRoute(widget: const ChooseFirstProductsScreen());

      case AppRoutes.homePage:
        return getRoute(widget: const HomeScreen());

      case AppRoutes.searchPage:
        return getRoute(widget: const SearchScreen());

      /// An invalid route. User shouldn't see this,
      /// it's for debugging purpose only.
      default:
        return getRoute(widget: const InvalidRoute());
    }
  }
}
