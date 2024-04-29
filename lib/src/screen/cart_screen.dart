import 'package:comizy/src/state/state.dart';
import 'package:comizy/src/tad/product.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productsCart = context.read<MyAppState>().productsCart;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meu carrinho'),
        actions: [
          IconButton(
              onPressed: () =>
                  Navigator.popUntil(context, ModalRoute.withName('/init')),
              icon: const Icon(Icons.arrow_back))
        ],
      ),
      body: listView(productsCart),
    );
  }

  SafeArea listView(Map<Product, int> productsCart) {
    return SafeArea(
      child: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: productsCart.length,
        itemBuilder: (context, index) => listTile(productsCart, index),
      ),
    );
  }

  ListTile listTile(Map<Product, int> productsCart, int index) {
    final productData = productsCart.entries.elementAt(index);
    final product = productData.key;
    final productCount = productData.value;

    return ListTile(
      title: Text(product.name),
      leading: Icon(product.category.iconData),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
              onPressed: () {}, icon: const Icon(Icons.arrow_circle_down)),
          Text('$productCount'),
          IconButton(onPressed: () {}, icon: const Icon(Icons.arrow_circle_up)),
        ],
      ),
    );
  }
}
