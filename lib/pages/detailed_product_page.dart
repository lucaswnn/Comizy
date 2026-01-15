import 'package:comizy/services/change_notifiers/market_notifier.dart';
import 'package:comizy/services/change_notifiers/product_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DetailedProductPage extends StatelessWidget {
  const DetailedProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    final product = context.read<ProductNotifier>().currentProduct!;
    final offers =
        context.read<MarketNotifier>().market.offersByProduct(product);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes completos do produto'),
      ),
      body: ListView.builder(
        itemCount: offers.length,
        itemBuilder: (_, index) {
          return ListTile(
            title: Text('${offers[index]}'),
          );
        },
      ),
    );
  }
}
