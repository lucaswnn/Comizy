import 'package:comizy/services/change_notifiers/market_change_notifier.dart';
import 'package:comizy/services/change_notifiers/navigation_change_notifier.dart';
import 'package:comizy/utils/navigation_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShopCategoryScreen extends StatelessWidget {
  const ShopCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final navigationData = context.read<NavigationChangeNotifier>();
    final category = navigationData.currentCategory!;
    final shop = navigationData.currentShop!;
    final market = context.read<MarketChangeNotifier>().market;
    final allOffers = market.shopOffersByCategory(shop, category);
    final subcategories = allOffers
        .map((offer) => offer.product.productType.subcategory)
        .toSet()
        .toList();

    final offersMap = {
      for (var cat in subcategories)
        cat: [
          for (var offer in allOffers
              .where((offer) => offer.product.productType.subcategory == cat))
            offer
        ]
    };

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            context.read<NavigationChangeNotifier>().clearCurrentCategory();
            NavigationHelper.pop();
          },
        ),
      ),
      body: ListView.builder(
        itemCount: subcategories.length,
        itemBuilder: (_, subcategoryIndex) {
          final offers = offersMap[subcategories[subcategoryIndex]]!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${subcategories[subcategoryIndex]}'),
              SizedBox(
                height: 100,
                child: ListView.builder(
                  itemCount: offers.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (_, productIndex) {
                    final offer = offers[productIndex];
                    return SizedBox(
                      width: 150,
                      child: ListTile(
                        title: Text(offer.product.name),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
