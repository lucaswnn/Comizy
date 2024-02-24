import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:comizy/src/state/state.dart';
import 'package:comizy/src/search/search.dart';
import 'package:comizy/src/screen/list_screen.dart';
import 'package:comizy/src/screen/map_screen.dart';
import 'package:comizy/src/screen/user_screen.dart';

class MyHome extends StatefulWidget {
  const MyHome({super.key});

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  final List<Widget> _pages = [ListScreen(), MapScreen(), UserScreen()];

  final PageController _pageController =
      PageController(initialPage: 1, keepPage: true);

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

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    var state = context.watch<MyAppState>();

    // carregar dados básicos de lojas e produtos
    state.loadDB();

    return Scaffold(
      // mostrar AppBar apenas nas páginas de lista e de mapa
      appBar: state.showAppBar
          ? AppBar(
              title: Text(
                state.appBarText ?? '',
                textAlign: TextAlign.right,
                style: const TextStyle(color: Colors.grey),
              ),
              
              actions: [
                IconButton(
                  onPressed: () {
                    showSearch(
                      context: context,
                      delegate: MySearchDelegate(),
                    );
                  },
                  icon: const Icon(Icons.search),
                )
              ],
            )
          : null,

      body: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            children: [
              Expanded(
                child: ColoredBox(
                  color: colorScheme.background,
                  child: PageView(
                    controller: _pageController,
                    children: _pages,
                  ),
                ),
              ),

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
        },
      ),
    );
  }
}
