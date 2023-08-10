import 'package:flutter/material.dart';

import 'list_screen.dart';
import 'map_screen.dart';
import 'user_screen.dart';

class MyHome extends StatefulWidget {
  const MyHome({super.key});

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  var _selectedIndex = 1;
  final List<Widget> _pages = [ListScreen(), MapScreen(), UserScreen()];

  final PageController _pageController =
      PageController(initialPage: 1, keepPage: true);

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
        Icons.map,
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

    return Scaffold(
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
                    onPageChanged: (index) {
                      setState(
                        () {
                          _selectedIndex = index;
                        },
                      );
                    },
                  ),
                ),
              ),
              SafeArea(
                child: BottomNavigationBar(
                  showSelectedLabels: false,
                  showUnselectedLabels: false,
                  items: _bottomNavigationBarItems,
                  currentIndex: _selectedIndex,
                  onTap: (index) {
                    setState(
                      () {
                        _selectedIndex = index;
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

class AppBottomNavigationBar extends StatelessWidget {
  const AppBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      showSelectedLabels: false,
      showUnselectedLabels: false,
      items: [
        BottomNavigationBarItem(
          label: "Lista",
          icon: IconButton(
            onPressed: () {
              print("Lista");
            },
            icon: const Icon(Icons.list),
          ),
        ),
        BottomNavigationBarItem(
          label: "Home",
          icon: IconButton(
            onPressed: () {
              print("Home");
            },
            icon: const Icon(Icons.home_filled),
          ),
        ),
        BottomNavigationBarItem(
          label: "User",
          icon: IconButton(
            onPressed: () {
              print("User");
            },
            icon: const Icon(Icons.person),
          ),
        ),
      ],
    );
  }
}
