import 'package:comizy/src/screen/cart/cart_optimization_screen.dart';
import 'package:comizy/src/state/state.dart';
import 'package:comizy/src/tad/product.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productsCart = context.watch<MyAppState>().productsCart;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Meu carrinho'),
        actions: [
          IconButton(
            onPressed: () =>
                Navigator.popUntil(context, ModalRoute.withName('/init')),
            icon: const Icon(Icons.arrow_back),
          )
        ],
      ),
      floatingActionButton:
          productsCart.isNotEmpty ? _floatingActionButtons(context) : null,
      body: productsCart.isEmpty ? _emptyCartView() : _listView(productsCart),
    );
  }

  Center _emptyCartView() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 35,
          ),
          SizedBox(height: 15),
          Text(
            'Carrinho vazio',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }

  Row _floatingActionButtons(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        FloatingActionButton(
          heroTag: 'Clear cart',
          elevation: 6.0,
          shape: const CircleBorder(),
          onPressed: () {
            _alertForClearCart(context).then(
              (answer) {
                if (answer == 'Sim') {
                  context.read<MyAppState>().clearCart();
                }
              },
            );
          },
          child: const Icon(Icons.remove_shopping_cart),
        ),
        const SizedBox(width: 5),
        FloatingActionButton(
          heroTag: 'Show suggestions',
          elevation: 6.0,
          shape: const CircleBorder(),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CartOptimizationScreen()));
          },
          child: const Icon(Icons.checklist),
        ),
      ],
    );
  }

  SafeArea _listView(Map<Product, int> productsCart) {
    return SafeArea(
      child: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: productsCart.length,
        itemBuilder: (context, index) =>
            _listTile(context, productsCart, index),
      ),
    );
  }

  ListTile _listTile(
      BuildContext context, Map<Product, int> productsCart, int index) {
    final productData = productsCart.entries.elementAt(index);
    final product = productData.key;
    final productCount = productData.value;

    final state = context.watch<MyAppState>();

    return ListTile(
      title: Text(product.name),
      leading: Icon(product.category.iconData),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () {
              if (state.productsCart[product] == 1) {
                _alertForEraseProduct(context).then(
                  (answer) {
                    if (answer == 'Sim') {
                      state.decreaseProductOnCart(product);
                    }
                  },
                );
              } else {
                state.decreaseProductOnCart(product);
              }
            },
            icon: const Icon(Icons.arrow_circle_down),
          ),
          Text('$productCount'),
          IconButton(
            onPressed: () => state.increaseProductOnCart(product),
            icon: const Icon(Icons.arrow_circle_up),
          ),
        ],
      ),
    );
  }

  Future<String?> _alertForEraseProduct(BuildContext context) {
    return showDialog<String>(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Deletar produto'),
          content: const Text('Deseja retirar o produto do carrinho?'),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context, 'Sim');
                },
                child: const Text('Sim')),
            TextButton(
                onPressed: () => Navigator.pop(context, 'Não'),
                child: const Text('Não')),
          ],
        );
      },
    );
  }

  Future<String?> _alertForClearCart(BuildContext context) {
    return showDialog<String>(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Esvaziar carrinho'),
          content: const Text('Deseja mesmo esvaziar o carrinho?'),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context, 'Sim');
                },
                child: const Text('Sim')),
            TextButton(
                onPressed: () => Navigator.pop(context, 'Não'),
                child: const Text('Não')),
          ],
        );
      },
    );
  }
}
