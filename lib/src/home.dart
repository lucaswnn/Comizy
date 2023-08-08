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
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    Widget page;
    switch (selectedIndex) {
      case 0:
        page = ListScreen();
        break;

      case 1:
        page = const MapScreen();
        break;

      case 2:
        page = UserScreen();
        break;

      default:
        throw UnimplementedError("Não foi implementado");
    }

    var mainArea = ColoredBox(
      color: colorScheme.background,
      child: page,
    );

    return Scaffold(
      body: LayoutBuilder(builder: ((context, constraints) {
        return Column(
          children: [
            Expanded(
              child: mainArea,
            ),
            SafeArea(
              child: BottomNavigationBar(
                  showSelectedLabels: false,
                  showUnselectedLabels: false,
                  items: const [
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
                    ),
                  ],
                  currentIndex: selectedIndex,
                  onTap: (value) {
                    setState(() {
                      selectedIndex = value;
                    });
                  }),
            ),
          ],
        );
      })),
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
