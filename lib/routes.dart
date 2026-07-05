import 'package:comizy/pages/auth_section/auth_gate_page.dart';
import 'package:comizy/pages/auth_section/change_password_page.dart';
import 'package:comizy/pages/auth_section/create_account_page.dart';
import 'package:comizy/pages/auth_section/forgot_password_page.dart';
import 'package:comizy/pages/auth_section/landing_page.dart';
import 'package:comizy/pages/auth_section/login_page.dart';
import 'package:comizy/pages/auth_section/tutorial_page.dart';
import 'package:comizy/pages/detailed_product_page.dart';
import 'package:comizy/pages/showcase_section/showcase_product_page.dart';
import 'package:comizy/pages/user_section/app_info_page.dart';
import 'package:comizy/pages/help_request_section/edit_product_price_page.dart';
import 'package:comizy/pages/user_section/leaderboard_page.dart';
import 'package:comizy/pages/user_section/logout_page.dart';
import 'package:comizy/pages/main_page.dart';
import 'package:comizy/pages/set_location_map_page.dart';
import 'package:comizy/pages/set_location_page.dart';
import 'package:comizy/pages/search_section/search_product_page.dart';
import 'package:comizy/pages/search_section/search_page.dart';
import 'package:comizy/pages/user_section/user_personal_page.dart';
import 'package:flutter/material.dart';
import 'package:comizy/values/app_routes.dart';
import 'package:comizy/utils/invalid_route.dart';

// Class that handles the app routes.
class Routes {
  const Routes._();

  // Route generator
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Additional function to generate the route widget.
    Route<T> getRoute<T>({
      required Widget widget,
      bool fullscreenDialog = false,
    }) {
      return MaterialPageRoute<T>(
        builder: (context) => widget,
        settings: settings,
        fullscreenDialog: fullscreenDialog,
      );
    }

    // Switch between routes.
    switch (settings.name) {
      case AppRoutes.mainPage:
        return getRoute(widget: const MainPage());

      case AppRoutes.landingPage:
        return getRoute(widget: const LandingPage());

      case AppRoutes.loginPage:
        return getRoute(widget: const LoginPage());

      case AppRoutes.forgotPasswordPage:
        return getRoute(widget: const ForgotPasswordPage());

      case AppRoutes.changePasswordPage:
        return getRoute(widget: const ChangePasswordPage());

      case AppRoutes.createAccountPage:
        return getRoute(widget: const CreateAccountPage());

      case AppRoutes.tutorialPage:
        return getRoute(widget: const TutorialPage());

      case AppRoutes.setLocationPage:
        return getRoute(widget: const SetLocationPage());

      case AppRoutes.searchPage:
        return getRoute(widget: const SearchPage());

      case AppRoutes.searchProductPage:
        return getRoute(widget: const SearchProductPage());

      case AppRoutes.detailedProductPage:
        return getRoute(widget: const DetailedProductPage());

      case AppRoutes.editProductPricePage:
        return getRoute(widget: const EditProductPricePage());

      case AppRoutes.userPersonalPage:
        return getRoute(widget: const UserPersonalPage());

      case AppRoutes.appInfoPage:
        return getRoute(widget: const AppInfoPage());

      case AppRoutes.logoutPage:
        return getRoute(widget: const LogoutPage());

      case AppRoutes.leaderboardPage:
        return getRoute(widget: const LeaderboardPage());

      case AppRoutes.setLocationMapPage:
        return getRoute(widget: const SetLocationMapPage());

      case AppRoutes.showcaseProductPage:
        return getRoute(widget: const ShowcaseProductPage());

      case AppRoutes.authGate:
        return getRoute(widget: const AuthGatePage());

      /// An invalid route. User shouldn't see this,
      /// it's for debugging purpose only.
      default:
        return getRoute(widget: const InvalidRoute());
    }
  }
}
