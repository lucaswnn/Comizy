import 'package:comizy/src/screen/product_screen.dart';
import 'package:comizy/src/screen/shop_screen.dart';
import 'package:comizy/src/state/state.dart';
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
      }
    } else if (state.settedState == SettedState.currentProductSetted) {
      for (Shop shop in state.currentProduct!.shops) {
        shops.add(shop);
      }
    }
  }

  ListView listViewBuilder(MyAppState state) {
    if (state.settedState == SettedState.currentShopSetted) {
      return ListView.builder(
        itemCount: products.length,
        itemBuilder: (BuildContext context, int index) {
          return productListTile(index);
        },
      );
    } else if (state.settedState == SettedState.currentProductSetted) {
      return ListView.builder(
        itemCount: shops.length,
        itemBuilder: (BuildContext context, int index) {
          return shopListTile(index);
        },
      );
    }
    return ListView.builder(
      itemCount: 1,
      itemBuilder: (BuildContext context, int index) {
        return const ListTile(
          title: Text('Pesquise algo para encontrar as melhores condições'),
        );
      },
    );
  }

  Card productListTile(int index) {
    final curFormat = NumberFormat.currency(symbol: r'R$', locale: 'pt_BR');

    return Card(
      child: ListTile(
        title: Text(products[index].name),
        subtitle: Row(
          children: [
            const Icon(Icons.grade_outlined),
            const SizedBox(width: 10),
            Text('${products[index].rating} / 5'),
          ],
        ),
        leading: Icon(products[index].iconData),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(curFormat.format(products[index].value)),
            const SizedBox(width: 10),
            const Icon(Icons.attach_money)
          ],
        ),
        onTap: () {
          ProductScreen.showProductScreen(context, products[index]);
        },
      ),
    );
  }

  Card shopListTile(int index) {
    final curFormat = NumberFormat.currency(symbol: r'R$', locale: 'pt_BR');

    return Card(
      child: ListTile(
        title: Text(shops[index].name),
        subtitle: Row(
          children: [
            const Icon(Icons.grade_outlined),
            const SizedBox(width: 10),
            Text('${shops[index].rating} / 5'),
          ],
        ),
        leading: Icon(shops[index].iconData),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(curFormat.format(shops[index].products.first.value)),
            const SizedBox(width: 10),
            const Icon(Icons.attach_money)
          ],
        ),
        onTap: () {
          ShopScreen.showShopScreen(context, shops[index]);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<MyAppState>(context, listen: true);
    loadList(state);

    return listViewBuilder(state);
  }
}
