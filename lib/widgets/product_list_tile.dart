import 'package:comizy/services/change_notifiers/navigation_change_notifier.dart';
import 'package:comizy/tads/product.dart';
import 'package:comizy/utils/navigation_helper.dart';
import 'package:comizy/values/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductListTile extends StatelessWidget {
  final Product product;
  const ProductListTile({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.all(5.0),
      leading: Material(
        elevation: 2,
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage(product.asset)),
          ),
        ),
      ),
      title: Text(product.name, style: const TextStyle(fontSize: 14)),
      subtitle: Text(
        product.description,
        style: const TextStyle(fontSize: 12),
      ),
      onTap: () {
        context.read<NavigationChangeNotifier>().currentProduct = product;
        NavigationHelper.pushNamed(AppRoutes.productDetails);
      },
    );
  }
}
