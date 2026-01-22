import 'package:comizy/services/change_notifiers/market_notifier.dart';
import 'package:comizy/services/change_notifiers/product_notifier.dart';
import 'package:comizy/tads/offer.dart';
import 'package:comizy/utils/invalid_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DetailedProductPage extends StatelessWidget {
  const DetailedProductPage({super.key});

  Widget buildEmptyOffers() {
    return const Center(
      child: Text('Nenhuma oferta disponível para este produto.'),
    );
  }

  Widget buildOfferList(Map<Offer, OfferInfo> offers) {
    final entries = offers.entries.toList();
    return ListView.builder(
      itemCount: entries.length,
      itemBuilder: (_, index) {
        return ListTile(
          title: Text('${entries[index].key.shop}'),
          subtitle:
              Text('Última atualização: ${entries[index].value.lastUpdated}'),
          trailing: Text('Preço: ${entries[index].value.price}'),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final product = context.read<ProductNotifier>().currentProduct;
    if (product == null) return const InvalidRoute();

    final offers =
        context.read<MarketNotifier>().market.offersByProduct(product);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes completos do produto'),
      ),
      body: offers.isEmpty ? buildEmptyOffers() : buildOfferList(offers),
    );
  }
}
