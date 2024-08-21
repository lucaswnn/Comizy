import 'package:flutter/material.dart';

import 'package:comizy/tad/product.dart';

class CartState extends ChangeNotifier {
  // carrinho de compras
  Map<Product, int> productsCart = {};

  // método para adicionar produtos no carrinho
  void addProductOnCart(Product product) {
    if (!(productsCart.containsKey(product))) {
      productsCart[product] = 1;
      notifyListeners();
    }
  }

  // método para aumentar a quantidade do produto no carrinho
  void increaseProductOnCart({
    required Product product,
    int quantity = 1,
  }) {
    if (productsCart.containsKey(product)) {
      productsCart[product] = productsCart[product]! + 1;
      notifyListeners();
    }
  }

  // método para diminuir a quantidade do produto no carrinho
  void decreaseProductOnCart({
    required Product product,
    int quantity = 1,
  }) {
    if (productsCart.containsKey(product)) {
      if (productsCart[product]! > quantity) {
        productsCart[product] = productsCart[product]! - quantity;
        notifyListeners();
      } else if (productsCart[product]! == quantity) {
        productsCart.remove(product);
        notifyListeners();
      } else {
        throw CartUnderflowException(product);
      }
    }
  }

  // limpa o carrinho
  void clearCart() {
    productsCart.clear();
    notifyListeners();
  }
}

class CartUnderflowException implements Exception {
  final Product _product;

  CartUnderflowException(this._product);

  @override
  String toString() =>
      'CartUnderflow: remoção de ${_product.name} além da quantidade no carrinho';
}
