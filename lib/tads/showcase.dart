import 'dart:collection';

import 'package:comizy/exceptions/showcase_exception.dart';
import 'package:comizy/tads/product.dart';

class Showcase {
  final List<Product> _products = [];
  int _showcaseLimit;

  Showcase({required int showcaseLimit}) : _showcaseLimit = showcaseLimit;

  Showcase.withProducts({
    required List<Product> products,
    required int showcaseLimit,
  }) : _showcaseLimit = showcaseLimit {
    showcaseLimit < products.length
        ? throw ShowcaseOverflowException(
            'Número de produtos (${products.length}) excede o limite do vitrine ($showcaseLimit).')
        : addProducts(products);
  }

  UnmodifiableListView<Product> get products => UnmodifiableListView(_products);

  void addProduct(Product product) {
    _showcaseLimit == _products.length
        ? throw ShowcaseOverflowException(
            'Número máximo de produtos na vitrine atingido ($_showcaseLimit).')
        : _products.add(product);
  }

  void removeProduct(Product product) {
    _products.remove(product);
  }

  void clearShowcase() {
    _products.clear();
  }

  void addProducts(List<Product> products) {
    _showcaseLimit < _products.length + products.length
        ? throw ShowcaseOverflowException(
            'Número de produtos (${_products.length + products.length}) excede o limite do vitrine ($_showcaseLimit).')
        : _products.addAll(products);
  }

  int get productCount => _products.length;

  void modifyShowcaseLimit(int increment) {
    increment + _showcaseLimit < 0
        ? throw ShowcaseOverflowException(
            'O incremento ($increment) não pode reduzir o limite da vitrine ($_showcaseLimit) para um valor negativo.')
        : _showcaseLimit += increment;
  }

  bool containsProduct(Product product) {
    return _products.contains(product);
  }

  operator[](int index)=> _products[index];
}
