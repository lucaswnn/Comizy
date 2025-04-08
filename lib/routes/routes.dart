import 'package:flutter/material.dart';
import 'package:comizy/values/app_routes.dart';
import 'package:comizy/utils/invalid_route.dart';
import 'package:comizy/screens/landing_page.dart';

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
        return getRoute(widget: const LandingPage());

      /// An invalid route. User shouldn't see this,
      /// it's for debugging purpose only.
      default:
        return getRoute(widget: const InvalidRoute());
    }
  }
}
