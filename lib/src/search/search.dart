import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'package:comizy/src/screen/product_screen.dart';
import 'package:comizy/src/screen/register_screen.dart';
import 'package:comizy/src/screen/shop_screen.dart';
import 'package:comizy/src/state/state.dart';
import 'package:comizy/src/theme/style.dart';
import 'package:comizy/src/tad/product.dart';
import 'package:comizy/src/tad/shop.dart';

class MySearchDelegate extends SearchDelegate {
  @override
  String? get searchFieldLabel => 'Procurar...';

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
    if (state.queryState == SettedSearchFilter.shopQuery) {
      return ShopScreen(
        shop: state.currentShop!,
      );
    } else {
      return ProductScreen(
        product: state.currentProduct!,
      );
    }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final state = context.watch<MyAppState>();
    state.loadDB();

    if (state.queryState == SettedSearchFilter.shopQuery) {
      List<Shop> suggestions = [];
      HintElevatedButton hint = const HintElevatedButton();

      if (query.isNotEmpty) {
        suggestions = state.dataBaseShops.where((searchResult) {
          final result = searchResult.name.toLowerCase();
          final input = query.toLowerCase();
          return result.contains(input);
        }).toList();

        if (suggestions.isEmpty) {
          return Column(
            children: [
              hint,
              ShopProductRegister(
                delegate: this,
              ),
            ],
          );
        }
      }

      return Column(
        children: [
          if (query.isNotEmpty)
            Row(
              children: [hint],
            ),
          ShopListViewBuilder(suggestions: suggestions, delegate: this)
        ],
      );
    } else {
      List<Product> suggestions = [];
      HintElevatedButton hint = const HintElevatedButton();

      if (query.isNotEmpty) {
        suggestions = state.dataBaseProducts.where((searchResult) {
          final result = searchResult.name.toLowerCase();
          final input = query.toLowerCase();
          return result.contains(input);
        }).toList();

        if (suggestions.isEmpty) {
          return Column(
            children: [
              hint,
              ShopProductRegister(
                delegate: this,
              ),
            ],
          );
        }
      }

      return Column(
        children: [
          if (query.isNotEmpty)
            Row(
              children: [hint],
            ),
          ProductListViewBuilder(suggestions: suggestions, delegate: this)
        ],
      );
    }
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
      state.queryState == SettedSearchFilter.shopQuery
          ? hintLabel = 'Loja'
          : hintLabel = 'Produto';
    });
    return ElevatedButton(
      onPressed: () {
        state.toggleSearchFilterState();
        setState(() {
          state.queryState == SettedSearchFilter.shopQuery
              ? hintLabel = 'Loja'
              : hintLabel = 'Produto';
        });
      },
      style: MyButtonStyles.searchBarHint,
      child: Text(hintLabel!),
    );
  }
}

class ShopListViewBuilder extends StatelessWidget {
  final List<Shop> suggestions;
  final MySearchDelegate delegate;
  const ShopListViewBuilder(
      {super.key, required this.suggestions, required this.delegate});

  @override
  Widget build(BuildContext context) {
    var state = context.watch<MyAppState>();

    return ListView.builder(
      shrinkWrap: true,
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final suggestion = suggestions[index];
        return ListTile(
          title: Text(suggestion.name),
          onTap: () {
            delegate.query = suggestion.name;
            state.setCurrentShop(suggestion);
            state.setCurrentShopProducts();
            delegate.showResults(context);
          },
        );
      },
    );
  }
}

class ProductListViewBuilder extends StatelessWidget {
  final List<Product> suggestions;
  final MySearchDelegate delegate;
  const ProductListViewBuilder(
      {super.key, required this.suggestions, required this.delegate});

  @override
  Widget build(BuildContext context) {
    var state = context.watch<MyAppState>();
    return ListView.builder(
      shrinkWrap: true,
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final suggestion = suggestions[index];
        return ListTile(
          title: Text(suggestion.name),
          onTap: () {
            delegate.query = suggestion.name;
            state.setCurrentProduct(suggestion);
            state.setCurrentProductShops();
            delegate.showResults(context);
          },
        );
      },
    );
  }
}
