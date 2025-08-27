import 'package:comizy/screens/home/pageviews/offer_register_list_pageview.dart';
import 'package:comizy/screens/home/pageviews/products_pageview.dart';
import 'package:comizy/screens/home/pageviews/user_pageview.dart';
import 'package:comizy/services/change_notifiers/user_change_notifier.dart';
import 'package:comizy/utils/navigation_helper.dart';
import 'package:comizy/values/app_assets.dart';
import 'package:comizy/values/app_colors.dart';
import 'package:comizy/values/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _pageController = PageController();
  final _pageViews = const <Widget>[
    ProductsPageView(),
    OfferRegisterListPageview(),
    UserPageview(),
  ];

  final _bottomNavItems = const [
    NavigationDestination(
      selectedIcon: Icon(
        Icons.list_outlined,
        color: Colors.black,
      ),
      icon: Icon(
        Icons.list,
        color: Colors.white,
      ),
      label: 'Produtos',
    ),
    NavigationDestination(
      selectedIcon: Icon(
        Icons.playlist_add,
        color: Colors.black,
      ),
      icon: Icon(
        Icons.playlist_add,
        color: Colors.white,
      ),
      label: 'Cadastros',
    ),
    NavigationDestination(
      selectedIcon: Icon(
        Icons.person_outline,
        color: Colors.black,
      ),
      icon: Icon(
        Icons.person,
        color: Colors.white,
      ),
      label: 'Usuário',
    ),
  ];

  int _currentNavIndex = 0;

  final _searchButton = IconButton(
    onPressed: () => NavigationHelper.pushNamed(AppRoutes.searchPage),
    icon: const Icon(
      Icons.search,
      color: Colors.white,
    ),
  );

  @override
  Widget build(BuildContext context) {
    final user = context.read<UserChangeNotifier>().user!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        automaticallyImplyLeading: false,
        title: Text(
          'Bem-vindo(a), ${user.name}',
          style: const TextStyle(fontSize: 14, color: Colors.white),
        ),
        actions: _currentNavIndex == 0 ? [_searchButton] : null,
        leading: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(AppAssets.simpleLogoSmall))),
        ),
      ),
      body: PageView(
        controller: _pageController,
        children: _pageViews,
        onPageChanged: (index) => setState(() => _currentNavIndex = index),
      ),
      bottomNavigationBar: NavigationBar(
        height: 60,
        labelTextStyle: const WidgetStatePropertyAll(
            TextStyle(color: Colors.white, fontSize: 12)),
        backgroundColor: AppColors.primaryColor,
        destinations: _bottomNavItems,
        selectedIndex: _currentNavIndex,
        onDestinationSelected: (index) => setState(
          () {
            _currentNavIndex = index;
            _pageController.animateToPage(
              _currentNavIndex,
              duration: Durations.medium1,
              curve: Curves.ease,
            );
          },
        ),
      ),
    );
  }
}
