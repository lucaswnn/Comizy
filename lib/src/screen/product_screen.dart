import 'package:comizy/src/state/state.dart';
import 'package:comizy/src/tad/product.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

class ProductScreen extends StatelessWidget {
  final Product product;
  const ProductScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<MyAppState>();

    final double productValue;
    final String shopName;
    LatLng shopLocation;

    if (state.currentProduct == null) {
      productValue = product.value!;
      shopName = product.shops.first.name;
      shopLocation = product.shops.first.location;
    } else {
      productValue = Product.minimumValue!;
      shopName = Product.minimumValueShop!.name;
      shopLocation = Product.minimumValueShop!.location;
    }
    return _buildProductScaffold(
        context, state, productValue, shopName, shopLocation);
  }

  Scaffold _buildProductScaffold(BuildContext context, MyAppState state,
      double productValue, String shopName, LatLng shopLocation) {
    final curFormat = NumberFormat.currency(symbol: r'R$', locale: 'pt_BR');

    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () =>
                  Navigator.popUntil(context, ModalRoute.withName('/home')),
              icon: const Icon(Icons.arrow_back))
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minWidth: 100,
            maxWidth: 200,
            minHeight: 100,
            maxHeight: 400,
          ),
          child: Column(
            children: [
              state.currentProduct != null
                  ? _mainCard(
                      context,
                      curFormat,
                      productValue,
                      shopName,
                      state,
                      shopLocation,
                    )
                  : _commonCard(
                      context,
                      curFormat,
                      productValue,
                      shopName,
                      state,
                      shopLocation,
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Card _mainCard(
    BuildContext context,
    NumberFormat curFormat,
    double productValue,
    String shopName,
    MyAppState state,
    LatLng shopLocation,
  ) {
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
                const Text(
                  'Menor preço',
                  style: TextStyle(fontSize: 15),
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      shopName,
                      style: const TextStyle(fontSize: 15),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    IconButton(
                      color: Colors.red,
                      icon: const Icon(Icons.location_on),
                      onPressed: () {
                        state.setHomeIndex(1);
                        state.pageViewController.jumpToPage(1);
                        state.mapController.move(shopLocation, 13.0);
                        Navigator.popUntil(
                            context, ModalRoute.withName('/home'));
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _bottomButtons(context, state, shopLocation),
        ],
      ),
    );
  }

  Card _commonCard(
    BuildContext context,
    NumberFormat curFormat,
    double productValue,
    String shopName,
    MyAppState state,
    LatLng shopLocation,
  ) {
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
                state.setHomeIndex(0);
                state.pageViewController.jumpToPage(0);
                Navigator.popUntil(context, ModalRoute.withName('/home'));
              },
              icon: const Icon(Icons.list)),
          IconButton(
              color: Colors.white,
              onPressed: () {
                state.setHomeIndex(1);
                state.mapController.move(shopLocation, 13.0);
                state.pageViewController.jumpToPage(1);
                Navigator.popUntil(context, ModalRoute.withName('/home'));
              },
              icon: const Icon(Icons.location_on)),
        ],
      ),
    );
  }

  static void showProductScreen(BuildContext context, Product prod) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductScreen(
          product: prod,
        ),
      ),
    );
  }
}
