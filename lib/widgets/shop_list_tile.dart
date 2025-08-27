import 'package:comizy/services/change_notifiers/navigation_change_notifier.dart';
import 'package:comizy/tads/shop.dart';
import 'package:comizy/utils/navigation_helper.dart';
import 'package:comizy/values/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShopListTile extends StatelessWidget {
  final Shop shop;
  const ShopListTile({super.key, required this.shop});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.all(5.0),
      leading: Material(
        elevation: 2,
        child: Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(color: Colors.amber,
          ),
        ),
      ),
      title: Text(shop.name, style: const TextStyle(fontSize: 14)),
      subtitle: const Text(
        'reservado',
        style: TextStyle(fontSize: 12),
      ),
      onTap: () {
        context.read<NavigationChangeNotifier>().currentShop = shop;
        NavigationHelper.pushNamed(AppRoutes.shopDetails);
      },
    );
  }
}
