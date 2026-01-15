import 'package:comizy/pages/detailed_product_page.dart';
import 'package:comizy/pages/user_section/app_info_page.dart';
import 'package:comizy/pages/edit_product_price_page.dart';
import 'package:comizy/pages/help_request_section/leaderboard_page.dart';
import 'package:comizy/pages/user_section/logout_page.dart';
import 'package:comizy/pages/main_pageview.dart';
import 'package:comizy/pages/set_location_map_page.dart';
import 'package:comizy/pages/set_location_page.dart';
import 'package:comizy/pages/help_request_section/product_help_request_page.dart';
import 'package:comizy/pages/product_page.dart';
import 'package:comizy/pages/search_section/search_page.dart';
import 'package:comizy/pages/user_section/user_personal_data_page.dart';
import 'package:comizy/pages/user_section/user_points_page.dart';
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
        return getRoute(widget: const MainPageView());

      case AppRoutes.setLocationPage:
        return getRoute(widget: const SetLocationPage());

      case AppRoutes.searchPage:
        return getRoute(widget: const SearchPage());

      case AppRoutes.productPage:
        return getRoute(widget: const ProductPage());

      case AppRoutes.detailedProductPage:
        return getRoute(widget: const DetailedProductPage());

      case AppRoutes.productHelpRequestPage:
        return getRoute(widget: const ProductHelpRequestPage());

      case AppRoutes.editProductPricePage:
        return getRoute(widget: const EditProductPricePage());

      case AppRoutes.userPointsPage:
        return getRoute(widget: const UserPointsPage());

      case AppRoutes.userPersonalDataPage:
        return getRoute(widget: const UserPersonalDataPage());

      case AppRoutes.appInfoPage:
        return getRoute(widget: const AppInfoPage());

      case AppRoutes.logoutPage:
        return getRoute(widget: const LogoutPage());

      case AppRoutes.leaderboardPage:
        return getRoute(widget: const LeaderboardPage());

      case AppRoutes.setLocationMapPage:
        return getRoute(widget: const SetLocationMapPage());

      /// An invalid route. User shouldn't see this,
      /// it's for debugging purpose only.
      default:
        return getRoute(widget: const InvalidRoute());
    }
  }
}
