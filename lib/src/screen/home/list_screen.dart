import 'package:comizy/src/screen/list/filtered_subcategory_screen.dart';
import 'package:comizy/src/screen/etc/shop_screen.dart';
import 'package:comizy/src/state/state.dart';
import 'package:comizy/src/tad/basic_market_item.dart';
import 'package:comizy/src/tad/selling.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  Map<int, Selling> _products = {};
  Map<int, Selling> _shops = {};

  void _loadList(MyAppState state) {
    _products = {};
    _shops = {};

    if (state.settedState == SettedState.currentShopSetted) {
      _products = state.currentShop!.associatedProducts;
    } else if (state.settedState == SettedState.currentProductSetted) {
      _shops = state.currentProduct!.associatedShops;
    }
  }

  Widget _shopListViewBuilder() {
    if (_shops.isEmpty) {
      return _emptyView(
        'Produto sem lojas associadas',
        Icons.remove_shopping_cart_outlined,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(4),
      itemCount: _shops.length,
      itemBuilder: (BuildContext context, int index) {
        return _shopListTile(index);
      },
    );
  }

  ListTile _shopListTile(int index) {
    final id = _shops.keys.elementAt(index);
    final shop = _shops[id]!.shop;

    return ListTile(
      title: Text(shop.name),
      subtitle: Text(shop.address),
      leading: Icon(shop.category.iconData),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _shops[id]!.realFormattedValue,
            style: const TextStyle(fontSize: 15),
          ),
          const SizedBox(height: 3),
          Text(
            _shops[id]!.lastUpdateFormatted,
            style: const TextStyle(fontSize: 11),
          ),
        ],
      ),
      onTap: () {
        ShopScreen.showShopScreen(context, shop);
      },
    );
  }

  Widget _categoryGridViewBuilder() {
    final subCategories = _getSubCategorySet().toList();

    if (subCategories.isEmpty) {
      return _emptyView(
        'Loja sem produtos associados',
        Icons.no_food,
      );
    }

    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200,
          childAspectRatio: 1.5,
        ),
        itemCount: subCategories.length,
        padding: const EdgeInsets.all(4.0),
        itemBuilder: (context, index) {
          return _categoryTile(index, subCategories);
        });
  }

  Set<SubCategory> _getSubCategorySet() {
    Set<SubCategory> subCategories = {};

    for (var selling in _products.values) {
      subCategories.add(selling.product.subCategory);
    }

    return subCategories;
  }

  Padding _categoryTile(int index, List<SubCategory> subCategories) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
          shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
          foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
          elevation: MaterialStateProperty.all<double>(8.0),
          shadowColor:
              MaterialStateProperty.all<Color>(subCategories[index].color),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  FilteredSubCategoryScreen(subCategory: subCategories[index]),
            ),
          );
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                subCategories[index].iconData,
                weight: 1.5,
                size: 30,
              ),
              Text(
                subCategories[index].subtype,
                style: const TextStyle(fontSize: 15),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Center _emptyView(String message, IconData iconData) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            iconData,
            size: 35,
          ),
          const SizedBox(height: 15),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<MyAppState>();
    _loadList(state);

    if (state.settedState == SettedState.currentShopSetted) {
      return _categoryGridViewBuilder();
    } else if (state.settedState == SettedState.currentProductSetted) {
      return _shopListViewBuilder();
    } else {
      return const Padding(
        padding: EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.manage_search,
                size: 50,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Pesquise algo para encontrar as melhores condições',
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }
  }
}
