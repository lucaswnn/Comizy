import 'dart:math';
import 'package:comizy/src/db/db_access.dart';
import 'package:comizy/src/screen/etc/shop_screen.dart';
import 'package:comizy/src/search/register_form.dart';
import 'package:comizy/src/tad/basic_market_item.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'package:comizy/src/screen/etc/product_screen.dart';
import 'package:comizy/src/state/state.dart';
import 'package:comizy/src/tad/product.dart';
import 'package:comizy/src/tad/shop.dart';

class MySearchDelegate extends SearchDelegate {
  Set<SearchSuggestionType> _suggestionsOnScreen = {};
  List<BasicMarketItem> _suggestions = [];
  List<BasicMarketItem> _results = [];

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
            _suggestions = [];
            _results = [];
            query = '';
          }
        },
        icon: const Icon(Icons.clear),
      ),
      IconButton(
        onPressed: () => showResults(context),
        icon: const Icon(Icons.search),
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
  Widget buildSuggestions(BuildContext context) {
    _suggestions = [];
    _suggestionsOnScreen = {};
    final state = context.watch<MyAppState>();
    state.resetSearchFilterState();
    state.loadMarket();

    if (query.isNotEmpty) {
      _suggestions = [
        ...state.market.shops.values.toList(),
        ...state.market.products.values.toList()
      ].where((searchResult) {
        final result = searchResult.name.toLowerCase();
        final input = query.toLowerCase();
        return result.contains(input);
      }).toList()
        ..sort((a, b) => a.name.compareTo(b.name));

      _suggestionsOnScreen = _suggestions
          .map((item) => SearchSuggestionType(
              name: item.name, type: item is Shop ? 'Loja' : 'Produto'))
          .toSet();
    }

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: suggestionsListViewBuilder(),
    );
  }

  ListView suggestionsListViewBuilder() {
    return ListView.builder(
      itemCount: min(_suggestionsOnScreen.length, 10),
      itemBuilder: (context, index) {
        final state = context.watch<MyAppState>();
        final suggestion = _suggestionsOnScreen.elementAt(index);
        return suggestionsListTile(suggestion, state, context);
      },
    );
  }

  ListTile suggestionsListTile(
    SearchSuggestionType suggestion,
    MyAppState state,
    BuildContext context,
  ) {
    return ListTile(
      title: Text(suggestion.name),
      subtitle: Text(suggestion.type),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      onTap: () {
        query = suggestion.name;
        if (suggestion.type == 'Loja') {
          state.setSearchFilterState(SearchFilterLabel.shopQuery, true);
          state.setSearchFilterState(SearchFilterLabel.productQuery, false);
        } else if (suggestion.type == 'Produto') {
          state.setSearchFilterState(SearchFilterLabel.shopQuery, false);
          state.setSearchFilterState(SearchFilterLabel.productQuery, true);
        }
        showResults(context);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final state = context.watch<MyAppState>();
    _results = [];

    _results
      ..addAll(
        _suggestions.where(
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
        _suggestions.where(
          (searchResult) {
            final result = searchResult.name.toLowerCase();
            final input = query.toLowerCase();
            return result.contains(input) &&
                searchResult is Product &&
                state.queryState[SearchFilterLabel.productQuery]!;
          },
        ),
      )
      ..sort((a, b) => a.name.compareTo(b.name));
    if (query.isNotEmpty) {
      if (_results.isEmpty) {
        // cria histórico de pesquisa na tabela avulsa
        DbAccess.addGenericSearchHistory(state.currentLocation, query);

        return noSearchStatus(context);
      }
      return Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: resultsListViewBuilder(),
      );
    } else {
      return Container();
    }
  }

  Column resultsListViewBuilder() {
    return Column(
      children: [
        const SearchFilterButtons(),
        const SizedBox(height: 15),
        ListView.builder(
          itemCount: min(_results.length, 8),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            final state = context.watch<MyAppState>();
            final result = _results[index];
            if (state.queryState[SearchFilterLabel.shopQuery]!) {
              return resultsShopListTile(result, state, context);
            } else {
              return resultsProductListTile(result, state, context);
            }
          },
        ),
      ],
    );
  }

  ListTile resultsShopListTile(
      BasicMarketItem result, MyAppState state, BuildContext context) {
    if (result is! Shop) {
      return const ListTile();
    } else {
      return ListTile(
        title: Text(result.name),
        subtitle: Text(result.address),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              result.category.type,
              style: const TextStyle(fontSize: 15),
            ),
            const SizedBox(
              width: 10,
            ),
            Icon(result.category.iconData),
          ],
        ),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        onTap: () {
          // cria histórico de pesquisa na tabela pesquisa_loja
          DbAccess.addGenericSearchHistory(state.currentLocation, result.name);

          state.setCurrentShop(result);
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
    }
  }

  ListTile resultsProductListTile(
      BasicMarketItem result, MyAppState state, BuildContext context) {
    return ListTile(
      title: Text(result.name),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            result.category.type,
            style: const TextStyle(fontSize: 15),
          ),
          const SizedBox(
            width: 10,
          ),
          Icon(result.category.iconData),
        ],
      ),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      onTap: () {
        if (result is Product) {
          // cria histórico de pesquisa na tabela pesquisa_produto
          DbAccess.addGenericSearchHistory(state.currentLocation, result.name);

          state.setCurrentProduct(result);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CurrentProductScreen(
                product: state.currentProduct!,
              ),
            ),
          );
        }
      },
    );
  }

  Column noSearchStatus(BuildContext context) {
    final queryState = context.read<MyAppState>().queryState;
    String type;
    queryState[SearchFilterLabel.productQuery]!
        ? type = 'Produto'
        : type = 'Loja';

    return Column(
      children: [
        const SearchFilterButtons(),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.no_food_outlined,
                size: 45,
              ),
              const SizedBox(
                height: 25,
              ),
              const Text(
                'Ops, parece que não encontramos o item que você procurou nesta área...\n'
                'Ajude-nos a registrar o item que você está tentando encontrar!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),
              ),
              IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RegisterForm(type: type)),
                    );
                  },
                  icon: const Icon(Icons.add)),
            ],
          ),
        ),
      ],
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
      mainAxisAlignment: MainAxisAlignment.spaceAround,
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
          width: 1,
          height: 30,
          child: ColoredBox(color: Colors.grey),
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

  const FilterButton({
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
              : Colors.white, // Cor diferente para ativo e inativo
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isActive ? Colors.white : Colors.black, // Cor do texto
          fontSize: 15,
        ),
      ),
    );
  }
}

class SearchSuggestionType {
  final String name;
  final String type;

  const SearchSuggestionType({required this.name, required this.type});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SearchSuggestionType &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          type == other.type;

  @override
  int get hashCode => Object.hash(name, type);
}
