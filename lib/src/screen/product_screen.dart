import 'package:comizy/src/state/state.dart';
import 'package:comizy/src/tad/product.dart';
import 'package:flutter/material.dart';

import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

class CurrentProductScreen extends StatelessWidget {
  final Product product;
  const CurrentProductScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<MyAppState>();

    String productValue = '-';
    String shopName = '-';
    LatLng shopLocation = const LatLng(0.0, 0.0);

    final minSelling = state.market.getMinSellingValue(product.id);
    if (minSelling != null) {
      productValue = minSelling.realFormattedValue;
      shopName = minSelling.shop.name;
      shopLocation = minSelling.shop.location;
    }

    return _buildProductScaffold(
        context, state, productValue, shopName, shopLocation);
  }

  Scaffold _buildProductScaffold(BuildContext context, MyAppState state,
      String productValue, String shopName, LatLng shopLocation) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () =>
                  Navigator.popUntil(context, ModalRoute.withName('/init')),
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
              _mainCard(
                context,
                state,
                productValue,
                shopName,
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
    MyAppState state,
    String productValue,
    String shopName,
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
                const Text(
                  'Menor preço',
                  style: TextStyle(fontSize: 15),
                ),
                const SizedBox(height: 2),
                Text(
                  productValue,
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        shopName,
                        softWrap: true,
                        style: const TextStyle(fontSize: 15),
                      ),
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
                            context, ModalRoute.withName('/init'));
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                const Text(
                  'Preço médio',
                  style: TextStyle(fontSize: 15),
                ),
                const SizedBox(height: 2),
                Text(
                  product.meanValueFormatted(),
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 5),
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
                Navigator.popUntil(context, ModalRoute.withName('/init'));
              },
              icon: const Icon(Icons.list)),
          IconButton(
              color: Colors.white,
              onPressed: () {
                state.setHomeIndex(1);
                state.mapController.move(shopLocation, 13.0);
                state.pageViewController.jumpToPage(1);
                Navigator.popUntil(context, ModalRoute.withName('/init'));
              },
              icon: const Icon(Icons.location_on)),
        ],
      ),
    );
  }

  static void showProductScreen(BuildContext context, Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CurrentProductScreen(
          product: product,
        ),
      ),
    );
  }
}
