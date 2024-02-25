import 'package:comizy/src/tad/shop.dart';
import 'package:flutter/material.dart';

class ShopScreen extends StatelessWidget {
  final Shop shop;
  const ShopScreen({super.key, required this.shop});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () => Navigator.pushNamed(context, '/home'),
              icon: const Icon(Icons.arrow_back))
        ],
      ),
      body: Center(
        child: Column(
          children: [Text(shop.name), Text(shop.address)],
        ),
      ),
    );
  }

  static void showShopScreen(BuildContext context, Shop shop) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ShopScreen(
          shop: shop,
        ),
      ),
    );
  }
}
