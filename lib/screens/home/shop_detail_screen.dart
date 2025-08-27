import 'package:comizy/services/change_notifiers/market_change_notifier.dart';
import 'package:comizy/services/change_notifiers/navigation_change_notifier.dart';
import 'package:comizy/tads/offer.dart';
import 'package:comizy/utils/navigation_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShopDetailScreen extends StatelessWidget {
  const ShopDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final shop = context.read<NavigationChangeNotifier>().currentShop!;
    final market = context.read<MarketChangeNotifier>().market;
    final categories = market.shopProductTypes(shop);
    final offers = market.shopOffers(shop);

    return Scaffold(
      appBar: AppBar(
        title: Text(shop.name),
        leading: BackButton(
          onPressed: () {
            context.read<NavigationChangeNotifier>().clearCurrentShop();
            NavigationHelper.pop();
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: ProductSearchDelegate(offers: offers),
              );
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          itemCount: categories.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
          ),
          itemBuilder: (context, index) {
            final category = categories[index];
            return ElevatedButton(
              onPressed: () {
                final filteredOffers = offers
                    .where((offer) => offer.product.productType == category)
                    .toList();
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(16)),
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
                            Text(
                              "Categoria: $category",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Expanded(
                              child: ListView.builder(
                                controller: scrollController,
                                itemCount: filteredOffers.length,
                                itemBuilder: (context, index) {
                                  final offer = filteredOffers[index];
                                  return ListTile(
                                    leading: Image.asset(
                                      offer.product.asset,
                                      width: 40,
                                      height: 40,
                                      fit: BoxFit.cover,
                                    ),
                                    title: Text(offer.product.name),
                                    subtitle: Text(
                                      "R\$ ${offer.price.toStringAsFixed(2)}",
                                    ),
                                    onTap: () {
                                      // Aqui você poderia navegar para ProductDetailPage
                                    },
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
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
              child: Text(category.toString()),
            );
          },
        ),
      ),
    );
  }
}

class ProductSearchDelegate extends SearchDelegate<Offer?> {
  final List<Offer> offers;

  ProductSearchDelegate({required this.offers});

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = offers
        .where(
            (p) => p.product.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return _buildList(results);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = offers
        .where(
            (p) => p.product.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return _buildList(suggestions);
  }

  Widget _buildList(List<Offer> list) {
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) {
        final offer = list[index];
        return ListTile(
          leading: Image.asset(
            offer.product.asset,
            width: 40,
            height: 40,
            fit: BoxFit.cover,
          ),
          title: Text(offer.product.name),
          subtitle: Text("R\$ ${offer.price.toStringAsFixed(2)}"),
          onTap: () => close(context, offer),
        );
      },
    );
  }
}
