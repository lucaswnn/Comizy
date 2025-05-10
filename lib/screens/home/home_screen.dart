import 'package:comizy/screens/home/products_pageview.dart';
import 'package:comizy/screens/home/user_pageview.dart';
import 'package:comizy/services/user_change_notifier.dart';
import 'package:comizy/values/app_assets.dart';
import 'package:comizy/values/app_colors.dart';
import 'package:comizy/widgets/layout_builder_wrapper.dart';
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

  @override
  Widget build(BuildContext context) {
    final user = context.read<UserChangeNotifier>().user!;

    return LayoutBuilderWrapper(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primaryColor,
          automaticallyImplyLeading: false,
          title: Text(
            'Bem-vindo(a), ${user.name}',
            style: const TextStyle(fontSize: 14, color: Colors.white),
          ),
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
      ),
    );
  }
}
