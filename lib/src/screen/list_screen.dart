import 'package:comizy/src/screen/filtered_category_screen.dart';
import 'package:comizy/src/screen/shop_screen.dart';
import 'package:comizy/src/state/state.dart';
import 'package:comizy/src/tad/basic_market_item.dart';
import 'package:comizy/src/tad/product.dart';
import 'package:comizy/src/tad/shop.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class ListScreen extends StatefulWidget {
  ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  List<Product> products = [];
  List<Shop> shops = [];

  @override
  void initState() {
    super.initState();
  }

  void loadList(MyAppState state) {
    products.clear();
    shops.clear();

    if (state.settedState == SettedState.currentShopSetted) {
      for (Product product in state.currentShop!.products) {
        products.add(product);
        products.last.shops.add(state.currentShop!);
      }
    } else if (state.settedState == SettedState.currentProductSetted) {
      for (Shop shop in state.currentProduct!.shops) {
        shops.add(shop);
      }
    }
  }

  ListView shopListViewBuilder() {
    return ListView.builder(
      itemCount: shops.length,
      itemBuilder: (BuildContext context, int index) {
        return shopListTile(index);
      },
    );
  }

  ListTile shopListTile(int index) {
    final curFormat = NumberFormat.currency(symbol: r'R$', locale: 'pt_BR');

    return ListTile(
      title: Text(shops[index].name),
      leading: Icon(shops[index].category.iconData),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            curFormat.format(shops[index].products.first.value),
            style: const TextStyle(fontSize: 15),
          ),
          const SizedBox(width: 10),
          const Icon(Icons.attach_money)
        ],
      ),
      onTap: () {
        ShopScreen.showShopScreen(context, shops[index]);
      },
    );
  }

  GridView categoryGridViewBuilder() {
    final categories = _getCategorySet().toList();

    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 150),
        itemCount: categories.length,
        padding: const EdgeInsets.all(8.0),
        itemBuilder: (context, index) {
          return categoryTile(index, categories);
        });
  }

  Set<Category> _getCategorySet() {
    Set<Category> categories = {};

    for (Product product in products) {
      categories.add(Category(type: product.category.type));
    }

    return categories;
  }

  Padding categoryTile(int index, List<Category> categories) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all<Color>(categories[index].color),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16))),
            foregroundColor: MaterialStateProperty.all<Color>(Colors.black)),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  FilteredCategoryScreen(category: categories[index]),
            ),
          );
        },
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              categories[index].iconData,
              weight: 1.5,
              size: 30,
            ),
            Text(
              categories[index].type,
              style: const TextStyle(fontSize: 20),
            ),
          ],
        )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<MyAppState>(context, listen: true);
    loadList(state);

    if (state.settedState == SettedState.currentShopSetted) {
      return categoryGridViewBuilder();
    } else if (state.settedState == SettedState.currentProductSetted) {
      return shopListViewBuilder();
    } else {
      return const Center(
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
      ));
    }
  }
}
