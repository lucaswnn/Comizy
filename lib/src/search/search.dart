import 'dart:math';

import 'package:comizy/src/db/db_access.dart';
import 'package:comizy/src/screen/shop_screen.dart';
import 'package:comizy/src/search/register_form.dart';
import 'package:comizy/src/tad/basic_market_item.dart';
import 'package:comizy/src/util/geo_util.dart';
import 'package:latlong2/latlong.dart';
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
            suggestions = [];
            results = [];
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
      )
      ..sort((a, b) => a.name.compareTo(b.name));
    if (query.isNotEmpty) {
      if (results.isEmpty) {
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
      }).toList()
        ..sort((a, b) => a.name.compareTo(b.name));
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: suggestionsListViewBuilder(),
    );
  }

  Column resultsListViewBuilder() {
    return Column(
      children: [
        const SearchFilterButtons(),
        const SizedBox(height: 15),
        ListView.builder(
          itemCount: min(results.length, 10),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            final state = context.watch<MyAppState>();
            final result = results[index];
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
    final myLocation = LatLng(
        state.currentLocation!.latitude!, state.currentLocation!.longitude!);
    double actualDistance;
    if (result is Shop) {
      actualDistance = calculateDistance(myLocation, result.location);
    } else {
      actualDistance = 0;
    }

    return ListTile(
      title: Text(result.name),
      subtitle:
          Text('Distância atual: ${actualDistance.toStringAsFixed(2)} km'),
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
        if (result is Shop) {
          // cria histórico de pesquisa na tabela pesquisa_loja
          DbAccess.addGenericSearchHistory(state.currentLocation, result.name);

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
        }
      },
    );
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
  }

  ListView suggestionsListViewBuilder() {
    return ListView.builder(
      itemCount: min(suggestions.length, 10),
      itemBuilder: (context, index) {
        final state = context.watch<MyAppState>();
        final suggestion = suggestions[index];
        return suggestionsListTile(suggestion, state, context);
      },
    );
  }

  ListTile suggestionsListTile(
    BasicMarketItem suggestion,
    MyAppState state,
    BuildContext context,
  ) {
    return ListTile(
      title: Text(suggestion.name),
      subtitle: Text(suggestion is Shop ? 'Loja' : 'Produto'),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
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
