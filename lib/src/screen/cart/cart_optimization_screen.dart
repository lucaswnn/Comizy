import 'package:comizy/src/state/state.dart';
import 'package:comizy/src/tad/shop.dart';
import 'package:comizy/src/util/string_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartOptimizationScreen extends StatelessWidget {
  CartOptimizationScreen({super.key});

  final Set<Shop> _minimumPriceShops = {};
  late final Shop _cheapestShop;
  late final double _minimumPrice;
  late final double _cheapestShopPrice;

  void _calculateMinimumPriceShops(BuildContext context) {
    final state = context.read<MyAppState>();
    final productsCart = state.productsCart;
    final market = state.market;

    var minimumPrice = 0.0;

    for (final productEntry in productsCart.entries) {
      final productId = productEntry.key.id;
      final minimumSelling = market.getMinSellingValue(productId);

      if (minimumSelling == null) {
        _minimumPriceShops.clear();
        _minimumPrice = 0;
        return;
      }

      final productQuantity = productEntry.value;

      minimumPrice += minimumSelling.value * productQuantity;
      _minimumPriceShops.add(minimumSelling.shop);
    }

    _minimumPrice = minimumPrice;
  }

  void _calculateCheapestShop(BuildContext context) {
    final state = context.read<MyAppState>();
    final productsCart = state.productsCart;
    final shops = state.market.shops;

    Shop? bestShop;
    var minimumValue = double.infinity;

    for (final shopEntries in shops.entries) {
      final shop = shopEntries.value;
      double shopValue = 0;
      bool isShopValid = true;

      for (final productEntries in productsCart.entries) {
        final productId = productEntries.key.id;

        if (!shop.associatedProducts.containsKey(productId)) {
          isShopValid = false;
          break;
        }

        final productQuantity = productEntries.value;
        final productPrice = shop.associatedProducts[productId]!.value;
        shopValue += productQuantity * productPrice;
      }

      if (isShopValid) {
        if (shopValue < minimumValue) {
          bestShop = shop;
          minimumValue = shopValue;
        }
      }
    }

    if (bestShop == null) {
      _cheapestShop = Shop.empty();
    } else {
      _cheapestShop = bestShop;
      _cheapestShopPrice = minimumValue;
    }
  }

  Padding _buildCards() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _minimumPriceCard(),
          const SizedBox(height: 10),
          _cheapestShopCard(),
        ],
      ),
    );
  }

  SizedBox _minimumPriceCard() {
    final minimumPriceFormatted = realFormattedValue(_minimumPrice);

    return SizedBox(
      width: 300,
      height: 200,
      child: Card(
        color: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 8.0,
        shadowColor: Colors.black,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Menor preço possível'),
              const SizedBox(height: 5),
              Text(minimumPriceFormatted),
              const SizedBox(height: 5),
              SizedBox(
                height: 100,
                child: _minimumPriceShopsListView(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ListView _minimumPriceShopsListView() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: _minimumPriceShops.length,
      itemBuilder: (context, index) {
        final shop = _minimumPriceShops.elementAt(index);
        return ListTile(
          title: Text(shop.name),
          subtitle: Text(shop.address),
        );
      },
    );
  }

  SizedBox _cheapestShopCard() {
    final minimumPriceFormatted = realFormattedValue(_cheapestShopPrice);

    return SizedBox(
      width: 300,
      height: 200,
      child: Card(
        color: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 8.0,
        shadowColor: Colors.black,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Loja com menor custo geral'),
              const SizedBox(height: 5),
              Text(minimumPriceFormatted),
              const SizedBox(height: 5),
              ListTile(
                title: Text(_cheapestShop.name),
                subtitle: Text(_cheapestShop.address),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _calculateMinimumPriceShops(context);
    _calculateCheapestShop(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Melhores opções de mercado'),
        actions: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: _buildCards(),
        ),
      ),
    );
  }
}
