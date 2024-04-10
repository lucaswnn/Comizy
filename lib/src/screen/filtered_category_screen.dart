import 'package:comizy/src/search/register_form.dart';
import 'package:comizy/src/state/state.dart';
import 'package:comizy/src/tad/basic_market_item.dart';
import 'package:comizy/src/tad/product.dart';
import 'package:comizy/src/util/string_util.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'dart:ui' as ui;

class FilteredCategoryScreen extends StatefulWidget {
  final Category category;
  FilteredCategoryScreen({
    super.key,
    required this.category,
  });

  @override
  State<FilteredCategoryScreen> createState() => _FilteredCategoryScreenState();
}

class _FilteredCategoryScreenState extends State<FilteredCategoryScreen> {
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
                  Navigator.popUntil(context, ModalRoute.withName('/home')),
              icon: const Icon(Icons.arrow_back))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Stack(
          fit: StackFit.expand,
          children: widgetStack,
        ),
      ),
    );
  }

  ListView listViewBuilder(MyAppState state) {
    var filteredProducts = getProductsFromCategory(state);

    return ListView.builder(
      key: UniqueKey(),
      itemCount: filteredProducts.length,
      itemBuilder: (context, index) {
        return productListTile(index, filteredProducts, context, state);
      },
    );
  }

  List<Product> getProductsFromCategory(MyAppState state) {
    try {
      final actualProducts = state.currentShop!.products;

      List<Product> filteredProducts = [];
      for (var product in actualProducts) {
        if (product.category.type == widget.category.type) {
          filteredProducts.add(product);
        }
      }
      return filteredProducts;
    } catch (e) {
      print(e);
      return [];
    }
  }

  ListTile productListTile(
    int index,
    List<Product> products,
    BuildContext context,
    MyAppState state,
  ) {
    final curFormat = NumberFormat.currency(symbol: r'R$', locale: 'pt_BR');
    double productValue = products[index].value!;
    String productName = products[index].name;
    String shopName = products[index].shops.first.name;
    LatLng shopLocation = products[index].shops.first.location;
    String lastUpdate = products[index].lastDate;

    return ListTile(
      title: Text(productName),
      leading: Icon(products[index].category.iconData),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            curFormat.format(productValue),
            style: const TextStyle(fontSize: 15),
          ),
          const SizedBox(width: 10),
          const Icon(Icons.attach_money)
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
                      maxWidth: 200,
                      minHeight: 100,
                      maxHeight: 400,
                    ),
                    child: Column(
                      children: [
                        _commonCard(context, curFormat, productValue, shopName,
                            state, shopLocation, lastUpdate, productName)
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
    NumberFormat curFormat,
    double productValue,
    String shopName,
    MyAppState state,
    LatLng shopLocation,
    String lastUpdate,
    String productName,
  ) {
    final lastUpdateFormatted =
        mySqlDateConversion(lastUpdate.substring(0, 10));

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
                  curFormat.format(productValue),
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
            'Última atualização: $lastUpdateFormatted',
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
          _bottomButtons(context, state, shopLocation),
        ],
      ),
    );
  }

  Container _bottomButtons(
      BuildContext context, MyAppState state, LatLng shopLocation) {
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
              Navigator.popUntil(context, ModalRoute.withName('/home'));
            },
            icon: const Icon(Icons.location_on),
          ),
        ],
      ),
    );
  }
}
