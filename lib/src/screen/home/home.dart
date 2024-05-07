import 'package:comizy/src/screen/cart/cart_screen.dart';
import 'package:comizy/src/screen/etc/product_screen.dart';
import 'package:comizy/src/screen/etc/shop_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:comizy/src/state/state.dart';
import 'package:comizy/src/search/search.dart';
import 'package:comizy/src/screen/home/list_screen.dart';
import 'package:comizy/src/screen/home/map_screen.dart';
import 'package:comizy/src/screen/home/user_screen.dart';

class MyHome extends StatefulWidget {
  const MyHome({super.key});

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  final List<Widget> _pages = [
    const ListScreen(),
    const MapScreen(),
    UserScreen()
  ];

  late PageController _pageController;

  // Ícones de navegação da PageView
  final List<BottomNavigationBarItem> _bottomNavigationBarItems = const [
    BottomNavigationBarItem(
      label: "Lista",
      icon: Icon(
        Icons.list,
        size: 28,
      ),
    ),
    BottomNavigationBarItem(
      label: "Home",
      icon: Icon(
        Icons.location_on,
        size: 28,
      ),
    ),
    BottomNavigationBarItem(
      label: "User",
      icon: Icon(
        Icons.person,
        size: 28,
      ),
    )
  ];

  final List<NavigationRailDestination> _navigationRailDestinationItems =
      const [
    NavigationRailDestination(
      label: Text('Lista'),
      icon: Icon(
        Icons.list,
        size: 28,
      ),
    ),
    NavigationRailDestination(
      label: Text('Home'),
      icon: Icon(
        Icons.location_on,
        size: 28,
      ),
    ),
    NavigationRailDestination(
      label: Text('User'),
      icon: Icon(
        Icons.person,
        size: 28,
      ),
    )
  ];

  @override
  void initState() {
    super.initState();
    final state = context.read<MyAppState>();
    _pageController = state.pageViewController;
  }

  PageView _pageView(ColorScheme colorScheme, Axis scrollDirection) {
    return PageView(
      scrollDirection: scrollDirection,
      controller: _pageController,
      physics: const NeverScrollableScrollPhysics(),
      children: _pages,
    );
  }

  Column _mobileFriendlyLayout(MyAppState state, ColorScheme colorScheme) {
    return Column(
      children: [
        Expanded(child: _pageView(colorScheme, Axis.horizontal)),
        SafeArea(
          child: BottomNavigationBar(
            showSelectedLabels: false,
            showUnselectedLabels: false,
            items: _bottomNavigationBarItems,
            currentIndex: state.selectedHomeIndex,
            onTap: (index) {
              setState(
                () {
                  state.setHomeIndex(index);
                  _pageController.animateToPage(
                    index,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.ease,
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Row _webFriendlyLayout(
      MyAppState state, ColorScheme colorScheme, BoxConstraints constraints) {
    return Row(
      children: [
        SafeArea(
          child: NavigationRail(
            indicatorColor: colorScheme.primary,
            extended: false,
            destinations: _navigationRailDestinationItems,
            selectedIndex: state.selectedHomeIndex,
            onDestinationSelected: (index) {
              setState(
                () {
                  state.setHomeIndex(index);
                  _pageController.animateToPage(
                    index,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.ease,
                  );
                },
              );
            },
          ),
        ),
        Expanded(child: _pageView(colorScheme, Axis.vertical)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    var state = context.watch<MyAppState>();

    // carregar dados básicos de lojas e produtos
    state.loadMarket();
    List<IconButton> actionButtons = [];
    if (state.showAppBar) {
      if (state.currentShop != null) {
        actionButtons
          ..add(IconButton(
              onPressed: () {
                ShopScreen.showShopScreen(context, state.currentShop!);
              },
              icon: const Icon(Icons.question_mark)))
          ..add(IconButton(
              onPressed: () {
                state.resetItemState();
              },
              icon: const Icon(Icons.clear)));
      } else if (state.currentProduct != null) {
        actionButtons
          ..add(IconButton(
              onPressed: () {
                CurrentProductScreen.showProductScreen(
                    context, state.currentProduct!);
              },
              icon: const Icon(Icons.question_mark)))
          ..add(IconButton(
              onPressed: () {
                state.resetItemState();
              },
              icon: const Icon(Icons.clear)));
      }

      actionButtons.add(IconButton(
        onPressed: () {
          showSearch(
            context: context,
            delegate: MySearchDelegate(),
          );
        },
        icon: const Icon(Icons.search),
      ));
    }

    String appBarText = state.appBarText ?? '';

    return Scaffold(
      // mostrar AppBar apenas nas páginas de lista e de mapa
      appBar: AppBar(
        title: Text(
          state.showAppBar ? appBarText : 'Painel do usuário',
          textAlign: TextAlign.right,
        ),
        actions: actionButtons,
      ),
      floatingActionButton: state.showAppBar
          ? FloatingActionButton(
              elevation: 6.0,
              shape: const CircleBorder(),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CartScreen()));
              },
              child: const Icon(Icons.shopping_cart),
            )
          : null,

      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 450) {
            return _mobileFriendlyLayout(state, colorScheme);
          } else {
            return _webFriendlyLayout(state, colorScheme, constraints);
          }
        },
      ),
    );
  }
}
