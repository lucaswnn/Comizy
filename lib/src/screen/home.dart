import 'package:comizy/src/theme/style.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:comizy/src/screen/shop_screen.dart';
import 'package:comizy/src/state/state.dart';
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
    var state = context.watch<MyAppState>();

    return Scaffold(
      appBar: state.showAppBar
          ? AppBar(
              title: const Text(
                'Procurar...',
                textAlign: TextAlign.right,
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

class MySearchDelegate extends SearchDelegate {
  List<String> searchResults = ['P1', 'P2'];

  @override
  String? get searchFieldLabel => 'procurar produto';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          if (query.isEmpty) {
            close(context, null);
          } else {
            query = '';
          }
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final state = context.watch<MyAppState>();
    state.setCurrentShop(query);
    return const ShopScreen();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> suggestions = [];
    List<ElevatedButton> hints = [];

    if (query.isNotEmpty) {
      suggestions = searchResults.where((searchResult) {
        final result = searchResult.toLowerCase();
        final input = query.toLowerCase();
        return result.contains(input);
      }).toList();

      int focus = 0;
      hints = [
        ElevatedButton(
          onPressed: () {},
          style: MyButtonStyles.searchBarHint,
          child: const Text('Loja'),
        ),
        ElevatedButton(
          onPressed: () {},
          child: const Text('Produto'),
        ),
      ];
    }

    return Column(
      children: [
        Row(
          children: hints,
        ),
        ListView.builder(
          shrinkWrap: true,
          itemCount: suggestions.length,
          itemBuilder: (context, index) {
            final suggestion = suggestions[index];
            return ListTile(
              title: Text(suggestion),
              onTap: () {
                query = suggestion;
                showResults(context);
              },
            );
          },
        ),
      ],
    );
  }
}
