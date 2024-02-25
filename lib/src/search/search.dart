import 'package:comizy/src/screen/shop_screen.dart';
import 'package:comizy/src/tad/basic_market_item.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'package:comizy/src/screen/product_screen.dart';
import 'package:comizy/src/state/state.dart';
import 'package:comizy/src/tad/product.dart';
import 'package:comizy/src/tad/shop.dart';

class MySearchDelegate extends SearchDelegate {
  List<BasicMarketItem> suggestions = [];
  List<BasicMarketItem> results = [];

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
    results = [];

    results
      ..addAll(
        suggestions.where(
          (searchResult) {
            final result = searchResult.name.toLowerCase();
            final input = query.toLowerCase();
            return result.contains(input) &&
                searchResult is Shop &&
                state.queryState[SearchFilterLabel.shopQuery]!;
          },
        ),
      )
      ..addAll(
        suggestions.where(
          (searchResult) {
            final result = searchResult.name.toLowerCase();
            final input = query.toLowerCase();
            return result.contains(input) &&
                searchResult is Product &&
                state.queryState[SearchFilterLabel.productQuery]!;
          },
        ),
      );

    return resultsListViewBuilder();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    suggestions = [];
    final state = context.watch<MyAppState>();
    state.resetSearchFilterState();
    state.loadDB();

    if (query.isNotEmpty) {
      suggestions = [...state.dataBaseShops, ...state.dataBaseProducts]
          .where((searchResult) {
        final result = searchResult.name.toLowerCase();
        final input = query.toLowerCase();
        return result.contains(input);
      }).toList();

      if (suggestions.isEmpty) {
        return const Card(
          child: Text('Ops... não encontramos resultados para a pesquisa'),
        );
      }
    }

    return suggestionsListViewBuilder();
  }

  Column resultsListViewBuilder() {
    return Column(
      children: [
        const SearchFilterButtons(),
        ListView.builder(
          itemCount: results.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            final state = context.watch<MyAppState>();
            final result = results[index];
            return ListTile(
              title: Text(result.name),
              onTap: () {
                if (result is Shop) {
                  state.setCurrentShop(result);
                  state.setCurrentShopProducts().then(
                    (value) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ShopScreen(
                            shop: state.currentShop!,
                          ),
                        ),
                      );
                    },
                  );
                } else if (result is Product) {
                  state.setCurrentProduct(result);
                  state.setCurrentProductShops().then(
                    (value) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductScreen(
                            product: state.currentProduct!,
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            );
          },
        ),
      ],
    );
  }

  ListView suggestionsListViewBuilder() {
    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final state = context.watch<MyAppState>();
        final suggestion = suggestions[index];
        return ListTile(
          title: Text(suggestion.name),
          subtitle: Text(suggestion is Shop ? 'Loja' : 'Produto'),
          onTap: () {
            query = suggestion.name;
            if (suggestion is Shop) {
              state.setSearchFilterState(SearchFilterLabel.shopQuery, true);
              state.setSearchFilterState(SearchFilterLabel.productQuery, false);
            } else if (suggestion is Product) {
              state.setSearchFilterState(SearchFilterLabel.shopQuery, false);
              state.setSearchFilterState(SearchFilterLabel.productQuery, true);
            }
            showResults(context);
          },
        );
      },
    );
  }
}

class SearchFilterButtons extends StatefulWidget {
  const SearchFilterButtons({super.key});

  @override
  State<SearchFilterButtons> createState() => _SearchFilterButtonsState();
}

class _SearchFilterButtonsState extends State<SearchFilterButtons> {
  @override
  Widget build(BuildContext context) {
    final state = context.watch<MyAppState>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FilterButton(
            isActive: state.queryState[SearchFilterLabel.productQuery]!,
            onPressed: () {
              if (!state.queryState[SearchFilterLabel.productQuery]!) {
                state.toggleSearchFilterState();
              }
            },
            text: 'Produto'),
        const SizedBox(
          width: 50,
        ),
        FilterButton(
            isActive: state.queryState[SearchFilterLabel.shopQuery]!,
            onPressed: () {
              if (!state.queryState[SearchFilterLabel.shopQuery]!) {
                state.toggleSearchFilterState();
              }
            },
            text: 'Loja'),
      ],
    );
  }
}

class FilterButton extends StatelessWidget {
  final bool isActive;
  final VoidCallback onPressed;
  final String text;

  FilterButton({
    super.key,
    required this.isActive,
    required this.onPressed,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(
          isActive
              ? Colors.blue
              : Colors.grey, // Cor diferente para ativo e inativo
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isActive ? Colors.white : Colors.black, // Cor do texto
        ),
      ),
    );
  }
}
