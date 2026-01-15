import 'package:comizy/services/change_notifiers/product_notifier.dart';
import 'package:comizy/services/change_notifiers/showcase_notifier.dart';
import 'package:comizy/tads/showcase.dart';
import 'package:comizy/utils/invalid_route.dart';
import 'package:comizy/utils/navigation_helper.dart';
import 'package:comizy/values/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductPage extends StatelessWidget {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    final product = context.read<ProductNotifier>().currentProduct;
    final showcaseNotifier = context.read<ShowcaseNotifier>();
    final showcase = showcaseNotifier.showcase;
    final showcaseProducts = showcase.showcaseProducts.keys.toList();
    bool isProductInShowcase = showcaseProducts.contains(product);
    bool isShowcaseFull = showcase.isShowcaseFull;

    if (product == null) {
      return const InvalidRoute();
    }

    String message = 'Para mais detalhes do produto, substitua-o na vitrine';
    Widget? buttonOption;

    if (!isShowcaseFull && !isProductInShowcase) {
      message = 'Para mais detalhes do produto, adicione-o à vitrine';

      buttonOption = ElevatedButton(
        onPressed: () {
          showcaseNotifier.addShowcaseProduct(product);
          NavigationHelper.pop();
        },
        child: const Text('Adicionar'),
      );
    } else if (isProductInShowcase) {
      message = 'O produto está na sua vitrine';

      buttonOption = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              NavigationHelper.pushNamed(AppRoutes.detailedProductPage);
            },
            child: const Text('Detalhes'),
          ),
          const SizedBox(width: 10),
          ElevatedButton(
            onPressed: () {
              final status = showcaseNotifier.removeShowcaseProduct(product);
              if (status == ShowcaseRemoveStatus.notEnoughTime) {
                final productInfo = showcase.showcaseProducts[product]!;
                final differenceInDays = showcase.maxShowcaseDays -
                    DateTime.now().difference(productInfo.addedAt).inDays;
                final dayFormatting = differenceInDays == 1 ? 'dia' : 'dias';

                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    content: Text(
                        'O produto não pode ser removido da vitrine ainda. '
                        'Aguarde mais $differenceInDays $dayFormatting.'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          NavigationHelper.pop();
                        },
                        child: const Text('OK'),
                      )
                    ],
                  ),
                );
                return;
              }

              NavigationHelper.pop();
            },
            child: const Text('Remover'),
          )
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes do produto ${product.name}'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('${product.description}.'),
          const SizedBox(height: 20),
          Text(message),
          if (buttonOption != null) buttonOption,
        ],
      ),
    );
  }
}
