import 'package:comizy/services/change_notifiers/offer_register_change_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PendingPointsScreen extends StatelessWidget {
  const PendingPointsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pendingOffers = context.read<OfferRegisterChangeNotifier>().pendingOfferRegisters;

    return Scaffold(
      appBar: AppBar(title: const Text("Pontos Pendentes")),
      body: ListView.builder(
        itemCount: pendingOffers.length,
        itemBuilder: (context, index) {
          final offer = pendingOffers[index];
          return ListTile(
            leading: const Icon(Icons.shopping_cart),
            title: Text(offer.product.name),
            subtitle: Text(
              "Preço: R\$ ${offer.price.toStringAsFixed(2)}\n"
              "Data: ${offer.date.day}/${offer.date.month}/${offer.date.year}",
            ),
          );
        },
      ),
    );
  }
}