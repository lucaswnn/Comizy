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
    BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Produtos'),
    BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Usuário'),
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
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white,
          unselectedFontSize: 10,
          backgroundColor: AppColors.primaryColor,
          items: _bottomNavItems,
          currentIndex: _currentNavIndex,
          onTap: (index) => setState(
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
