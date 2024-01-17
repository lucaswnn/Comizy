import 'package:comizy/src/db/db_access.dart';
import 'package:comizy/src/screen/product_screen.dart';
import 'package:comizy/src/tad/product.dart';
import 'package:comizy/src/theme/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
                style: TextStyle(color: Colors.grey),
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
  List<Product> searchResults = [];

  Future<void> loadResults() async {
    searchResults = Product.productList(await DbAccess.getProductList());
  }

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
    if (state.shopOrProduct == 'Loja') {
      state.setCurrentShop(query);
      return const ShopScreen();
    } else {
      state.setCurrentProduct(query);
      return const ProductScreen();
    }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<Product> suggestions = [];
    HintElevatedButton hint = const HintElevatedButton();

    if (query.isNotEmpty) {
      suggestions = searchResults.where((searchResult) {
        final result = searchResult.name.toLowerCase();
        final input = query.toLowerCase();
        return result.contains(input);
      }).toList();
      if (suggestions.isEmpty) {
        return ShopProductRegister(
          delegate: this,
        );
      }
    }

    loadResults();
    return Column(
      children: [
        if (query.isNotEmpty)
          Row(
            children: [hint],
          ),
        ListView.builder(
          shrinkWrap: true,
          itemCount: suggestions.length,
          itemBuilder: (context, index) {
            final suggestion = suggestions[index];
            return ListTile(
              title: Text(suggestion.name),
              onTap: () {
                query = suggestion.name;
                showResults(context);
              },
            );
          },
        ),
      ],
    );
  }
}

class HintElevatedButton extends StatefulWidget {
  const HintElevatedButton({super.key});

  @override
  State<HintElevatedButton> createState() => _HintElevatedButtonState();
}

class _HintElevatedButtonState extends State<HintElevatedButton> {
  String? hintLabel;

  @override
  Widget build(BuildContext context) {
    var state = context.watch<MyAppState>();
    setState(() {
      hintLabel = state.shopOrProduct;
    });
    return ElevatedButton(
      onPressed: () {
        setState(() {
          state.toggleShopProduct();
          hintLabel = state.shopOrProduct;
        });
      },
      style: MyButtonStyles.searchBarHint,
      child: Text(hintLabel!),
    );
  }
}

class ShopProductRegister extends StatelessWidget {
  final MySearchDelegate delegate;
  ShopProductRegister({super.key, required this.delegate});

  @override
  Widget build(BuildContext context) {
    var state = context.watch<MyAppState>();
    String? noFindText;
    if (state.shopOrProduct == 'Produto') {
      noFindText =
          'Produto não encontrado. Sentiu falta de algum produto? Cadastre um novo produto na plataforma';
    } else {
      noFindText =
          'Loja não encontrada. Sentiu falta de alguma loja? Cadastre uma nova loja na plataforma';
    }
    return SizedBox(
      height: 100,
      width: 400,
      child: Card(
        color: Colors.amber,
        shadowColor: Colors.grey,
        child: Column(
          children: [
            Text(noFindText),
            ElevatedButton(
              onPressed: () {
                delegate.close(context, null);
              },
              child: const Icon(Icons.add),
            )
          ],
        ),
      ),
    );
  }
}
