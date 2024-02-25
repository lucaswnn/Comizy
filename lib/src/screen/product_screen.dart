import 'package:comizy/src/tad/product.dart';
import 'package:flutter/material.dart';

class ProductScreen extends StatelessWidget {
  final Product product;
  const ProductScreen({super.key, required this.product});

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
          children: [Text(product.name), Text(product.value.toString())],
        ),
      ),
    );
  }

  static void showProductScreen(BuildContext context, Product prod) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductScreen(
          product: prod,
        ),
      ),
    );
  }
}
