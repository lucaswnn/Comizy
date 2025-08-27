import 'package:comizy/services/change_notifiers/market_change_notifier.dart';
import 'package:comizy/services/change_notifiers/navigation_change_notifier.dart';
import 'package:comizy/tads/shop.dart';
import 'package:comizy/utils/navigation_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key});

  Future<void> _showShops(BuildContext context, List<Shop> shops) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true, // permite ocupar mais espaço
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.5,
          minChildSize: 0.3,
          maxChildSize: 0.9,
          builder: (context, scrollController) {
            return Column(
              children: [
                const SizedBox(height: 12),
                Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  "Lojas disponíveis",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: shops.length,
                    itemBuilder: (context, index) {
                      final shop = shops[index];
                      return ListTile(
                        leading: const Icon(Icons.store),
                        title: Text(shop.name),
                        subtitle: const Text(
                          "R\$...",
                        ),
                        trailing: const Text(
                          'data?',
                          style: TextStyle(color: Colors.grey),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final product = context.read<NavigationChangeNotifier>().currentProduct!;
    final market = context.read<MarketChangeNotifier>().market;
    final shops = market.productShops(product);

    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
        leading: BackButton(
          onPressed: () {
            context.read<NavigationChangeNotifier>().clearCurrentProduct();
            NavigationHelper.pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Foto
            Center(
              child: Image.asset(
                product.asset,
                height: 150,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),

            // Nome
            Text(
              product.name,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            // Menor preço
            const Text(
              "Menor preço: R\$...",
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),

            // Data do menor preço
            const Text(
              "Data: 01/01/1900",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 8),

            // Loja do menor preço
            const Text(
              "Loja: ...",
              style: TextStyle(fontSize: 16),
            ),
            const Spacer(),

            // Botão para ver todas as lojas
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _showShops(context, shops);
                },
                child: const Text("Ver lojas disponíveis"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
