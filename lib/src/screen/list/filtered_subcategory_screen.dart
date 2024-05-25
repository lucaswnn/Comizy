import 'dart:developer';

import 'package:comizy/src/search/register_form.dart';
import 'package:comizy/src/state/state.dart';
import 'package:comizy/src/tad/basic_market_item.dart';
import 'package:comizy/src/tad/selling.dart';

import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'dart:ui' as ui;

class FilteredSubCategoryScreen extends StatefulWidget {
  final SubCategory subCategory;
  const FilteredSubCategoryScreen({
    super.key,
    required this.subCategory,
  });

  @override
  State<FilteredSubCategoryScreen> createState() =>
      _FilteredSubCategoryScreenState();
}

class _FilteredSubCategoryScreenState extends State<FilteredSubCategoryScreen> {
  List<Widget> widgetStack = [];

  @override
  void initState() {
    final state = context.read<MyAppState>();
    widgetStack.add(listViewBuilder(state));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<MyAppState>();

    return Scaffold(
      appBar: AppBar(
        title: Text(state.currentShop!.name),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () =>
                  Navigator.popUntil(context, ModalRoute.withName('/init')),
              icon: const Icon(Icons.arrow_back))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Stack(
          fit: StackFit.expand,
          children: widgetStack,
        ),
      ),
    );
  }

  ListView listViewBuilder(MyAppState state) {
    var filteredProducts = _getProductsFromSubCategory(state);

    return ListView.builder(
      key: UniqueKey(),
      itemCount: filteredProducts.length,
      itemBuilder: (context, index) {
        return productListTile(index, filteredProducts, context, state);
      },
    );
  }

  List<Selling> _getProductsFromSubCategory(MyAppState state) {
    try {
      final actualProducts = state.currentShop!.associatedProducts;

      List<Selling> filteredProducts = [];
      for (var selling in actualProducts.values) {
        if (selling.product.subCategory.subtype == widget.subCategory.subtype) {
          filteredProducts.add(selling);
        }
      }
      return filteredProducts;
    } catch (error) {
      const debugOrigin =
          'filtered_category_screen:FilteredCategoryScreenState.getProductsFromCategory';
      log('comizy: exception on $debugOrigin: $error');
      return [];
    }
  }

  ListTile productListTile(
    int index,
    List<Selling> products,
    BuildContext context,
    MyAppState state,
  ) {
    String productValue = products[index].realFormattedValue;
    String productName = products[index].product.name;
    String shopName = products[index].shop.name;
    LatLng shopLocation = products[index].shop.location;
    String lastUpdate = products[index].lastUpdateFormatted;
    Selling product = products[index];

    return ListTile(
      title: Text(productName),
      leading: Icon(products[index].product.category.iconData),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            productValue,
            style: const TextStyle(fontSize: 15),
          ),
          const SizedBox(height: 3),
          Text(
            lastUpdate,
            style: const TextStyle(fontSize: 11),
          ),
        ],
      ),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      onTap: () {
        setState(() {
          widgetStack.add(
            Positioned.fill(
              key: UniqueKey(),
              child: BackdropFilter(
                filter: ui.ImageFilter.blur(
                  sigmaX: 3.0,
                  sigmaY: 3.0,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      minWidth: 100,
                      maxWidth: 300,
                      minHeight: 100,
                      maxHeight: 400,
                    ),
                    child: Column(
                      children: [
                        _commonCard(context, productValue, shopName, state,
                            shopLocation, lastUpdate, productName, product)
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
      },
    );
  }

  Card _commonCard(
      BuildContext context,
      String productValue,
      String shopName,
      MyAppState state,
      LatLng shopLocation,
      String lastUpdate,
      String productName,
      Selling product) {
    final registerType = 'Preço de $productName em $shopName';

    return Card(
      color: Colors.white,
      surfaceTintColor: Colors.white,
      elevation: 8.0,
      shadowColor: Colors.black,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Text(
                  productValue,
                  style: const TextStyle(fontSize: 20),
                ),
                Text(
                  'Preço em $shopName',
                  style: const TextStyle(fontSize: 15),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          Text(
            'Última atualização: $lastUpdate',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 15),
          const Text(
            'Tem algo de errado nesse preço?',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 5),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RegisterForm(type: registerType),
                ),
              );
            },
            icon: const Icon(Icons.money_off),
          ),
          const SizedBox(height: 20),
          _bottomButtons(context, state, shopLocation, product),
        ],
      ),
    );
  }

  Container _bottomButtons(
    BuildContext context,
    MyAppState state,
    LatLng shopLocation,
    Selling product,
  ) {
    return Container(
      height: 42,
      decoration: const BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            color: Colors.white,
            onPressed: () {
              setState(() {
                widgetStack.removeLast();
              });
            },
            icon: const Icon(Icons.arrow_back),
          ),
          IconButton(
            color: Colors.white,
            onPressed: () {
              state.setHomeIndex(1);
              state.mapController.move(shopLocation, 13.0);
              state.pageViewController.jumpToPage(1);
              Navigator.popUntil(context, ModalRoute.withName('/init'));
            },
            icon: const Icon(Icons.location_on),
          ),
          IconButton(
            color: Colors.white,
            onPressed: () {
              state.addProductOnCart(product.product);
              const message = 'Produto adicionado ao carrinho';
              const snackBar = SnackBar(content: Text(message));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);

              Future.delayed(const Duration(milliseconds: 500))
                  .whenComplete(() => Navigator.pop(context));
            },
            icon: const Icon(Icons.add_shopping_cart),
          ),
        ],
      ),
    );
  }
}
