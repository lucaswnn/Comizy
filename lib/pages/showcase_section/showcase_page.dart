import 'package:comizy/services/change_notifiers/product_notifier.dart';
import 'package:comizy/services/change_notifiers/showcase_notifier.dart';
import 'package:comizy/utils/extensions.dart';
import 'package:comizy/utils/navigation_helper.dart';
import 'package:comizy/values/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShowcasePage extends StatelessWidget {
  const ShowcasePage({super.key});

  @override
  Widget build(BuildContext context) {
    final showcaseNotifier = context.watch<ShowcaseNotifier>();
    final showcase = showcaseNotifier.showcase;
    final products = showcase.showcaseProducts.keys.toList()..sort();

    return ListView.builder(
      itemCount: showcase.maxShowcaseProducts,
      itemBuilder: (_, i) {
        if (i >= products.length) {
          return ListTile(
            title: const Text('Adicionar produto'),
            leading: const Icon(Icons.add),
            onTap: () => NavigationHelper.pushNamed(AppRoutes.searchPage),
          );
        }
        final product = products[i];
        final productInfo = showcase.showcaseProducts[product]!;
        return ListTile(
          leading: const Icon(Icons.abc),
          title: Text(product.name),
          subtitle:
              Text('Adicionado em ${productInfo.addedAt.toShortDateString}'),
          onTap: () {
            context.read<ProductNotifier>().currentProduct = product;
            NavigationHelper.pushNamed(AppRoutes.productPage);
          },
        );
      },
    );
  }
}
